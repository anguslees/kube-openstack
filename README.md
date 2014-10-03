Deploying OpenStack on kubernetes on docker
===========================================

(... on CoreOS on Rackspace public cloud)

Howto
-----

1. First get a kubernetes environment working.

   Exactly how you do this will likely vary greatly depending on your
   environment - see
   [the kubernetes docs](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/README.md).

   If you are running on Rackspace public cloud, you can use the
   included heat template and script to set up an appropriate ssh
   tunnel:
   ```
   heat stack-create -f heat-kube-coreos-rax.yaml -P key-name=mykey corekube
   wget https://storage.googleapis.com/kubernetes/kubecfg -O /usr/local/bin/kubecfg
   ./setup-kube-tunnel.sh
   ```

2. Generate the parameters unique to your OpenStack install.

   ```
   heat stack-create -f heat-setup.yaml mystack
   ```

   This step generates all the passwords, and also configures a
   database and Swift container.

   Note we do not actually start any servers here, it is just a place
   to generate and store the configuration that we are going to use for
   our kubernetes jobs that will run on the machines we created in
   step 1.

3. Generate the kubernetes config files with the parameters from step 2.

   Kubernetes configs have no way to pull in parameters from outside
   at present, so we substitute the values directly into the files.
   This step is deliberately simple at the moment and would be easy to
   make it look nicer.

   ```
   ./heat-replace.py mystack kubernetes-in kubernetes
   ```

4. Bring up private docker registry.

   This is not strictly required, but I like to use a private docker
   registry when I am doing high-churn development work - and the
   names of images in the kubernetes configs currently assume this.

   ```
   kubecfg -c kubernetes/docker-registry-service.yaml create services
   kubecfg -c kubernetes/docker-registry-repcon.yaml create replicationControllers
   ```

   Note that these are really just proxies and the actual registry
   contents are stored in the swift container created in step 2.
   Consequently, any other instance running with the same parameters
   given in `kubernetes/docker-registry-repcon.yaml` will also be able
   to read from and write to this registry.  This may be a useful
   option during step 5.

   Note also that these configs run the docker registry on port 4999
   instead of the usual port 5000 to avoid conflicting with keystone.

5. Populate private docker registry.

   Build the docker images and push them to your private docker
   registry.  This step essentially downloads a minimal OS and uploads
   it back to the private docker registry, so it is good to perform
   this step on a well-connected machine (eg: on another Rackspace VM,
   not on your desktop).

   If you are using `heat-kube-coreos-rax.yaml`, then it is fine to do
   this step from one of the CoreOS minion machines.  Just rsync the
   `docker` sub directory to one of the minions, ssh in as root, and
   run the following.

   ```
   cd docker
   ./build.sh
   ```

6. Bring up kubernetes jobs.

   Order matters here.  The services have to be created before any
   jobs that need to refer to them.

   ```
   ./kubecfg-create.sh
   ```

7. Remove one-shot jobs that are no longer necessary.

   Optional.  Kubernetes has poor support for non-persistent jobs at
   present, so these are a slight abuse of kubernetes.  They should be
   harmless if left configured or if they are re-run.

   ```
   for s in keystone nova glance; do
     kubecfg delete pods/$s-db-sync
   done
   ```

8. Enjoy.

   Some useful commands

   ```
   # See what is running where
   kubecfg list pods

   # Adjust the number of nova-api servers
   kubecfg resize nova-api 3

   # Increase the number of hosts running openstack services (default is 3)
   # (For users of heat-kube-coreos-rax.yaml)
   # Kubernetes will assign jobs randomly amongst available hosts
   # whenever a pod needs to be (re)started.
   heat stack-update -f heat-kube-coreos-rax.yaml \
     -P key-name=mykey -P kubernetes-minion-count=4 corekube
   ```
