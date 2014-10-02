#!/bin/sh

set -x

# Services must be brought up first
for f in kubernetes/*-service.yaml; do
    kubecfg -c $f create services
done

for f in kubernetes/*-pod.yaml; do
    kubecfg -c $f create pods
done

for f in kubernetes/*-repcon.yaml; do
    kubecfg -c $f create replicationControllers
done
