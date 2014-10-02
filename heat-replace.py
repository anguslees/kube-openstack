#!/usr/bin/python

import errno
import os
import re
import sys
import urllib
import urlparse

from keystoneclient.v2_0 import client as ksclient
from heatclient.v1 import client as heatclient


def get_ksclient():
    return ksclient.Client(auth_url=os.getenv('OS_AUTH_URL'),
                           token=os.getenv('OS_AUTH_TOKEN'),
                           username=os.getenv('OS_USERNAME'),
                           password=os.getenv('OS_PASSWORD'),
                           tenant_name=os.getenv('OS_TENANT_NAME'),
                           tenant_id=os.getenv('OS_TENANT_ID'),
                           region_name=os.getenv('OS_REGION_NAME'))


def get_hclient():
    ksclient = get_ksclient()

    heat_url = os.getenv('HEAT_URL')
    if not heat_url:
        heat_url = ksclient.service_catalog.url_for(
            service_type='orchestration',
            attr='region', filter_value=os.getenv('OS_REGION_NAME'),
            endpoint_type='publicURL')

    token = os.getenv('OS_AUTH_TOKEN', ksclient.auth_token)

    return heatclient.Client(endpoint=heat_url, token=token)


def main(stack_name, in_dir, out_dir):
    if in_dir == out_dir:
        raise ValueError('Cowardly refusing to work on %s in-place' % in_dir)

    hc = get_hclient()
    stack = hc.stacks.get(stack_name)

    if stack.status != 'COMPLETE':
        raise RuntimeError('%s is still in state %s. Try again later.' % (
            stack_name, stack.stack_status))

    outputs = dict((o['output_key'], o['output_value'])
                   for o in stack.to_dict().get('outputs'))

    # Heat can't do a string split, and the Swift resource type
    # returns various unhelpful forms.  Yes, I know.
    if 'swift_siteurl' in outputs:
        path = urlparse.urlparse(urllib.unquote(outputs['swift_siteurl']))[2]
        pieces = path.split('/')
        outputs.update({
            'swift_container': pieces[-1],
            'swift_tenant_name': pieces[-2],
        })

    #import pprint
    #pprint.pprint(outputs)

    in_to_out = os.path.relpath(out_dir, start=in_dir)

    def raise_error(e):
        raise e

    for dirpath, dirs, files in os.walk(in_dir, onerror=raise_error):
        outpath = os.path.normpath(os.path.join(out_dir, os.path.relpath(dirpath, in_dir)))
        try:
            os.makedirs(outpath)
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise

        for file_name in files:
            in_name = os.path.join(dirpath, file_name)
            out_name = os.path.join(outpath, file_name)
            print '%s => %s' % (in_name, out_name)

            with open(in_name) as in_f, open(out_name, mode='w') as out_f:
                out_f.write(
                    re.sub('%(\w+)%',
                           lambda m: outputs[m.group(1)],
                           in_f.read()))


if __name__ == '__main__':
    main(*sys.argv[1:])
