#!/usr/bin/env python

import re
import simplejson
import socket
import yaml
import urllib2
import sys
mason = '''#! mason debug=1 <<EOTEMPLATE
% use DateTime;
% my $dt1 = DateTime->new(year => 2010, month=>2, day =>8 );
% my $dt2 = DateTime->new( year => 2010, month=>3, day =>14 );
% my $counter = 0;
% my %summary = ();
% my @t  = reportdata "{ suite_name => { 'like', [ 'Topic-xen%' ]}, created_at => { -between => ['$dt1' , '$dt2' ]  }} :: /";
% foreach my $run (@t){
%   my $tmp_meta = $run ~~ dpath "//meta//XEN-Metainfo";
%   if ( ! $tmp_meta->[0] ){
%      my $testrun = ($run ~~ dpath "//groupcontext/testrun/")->[0];
%      my $runid = (keys %$testrun)[0];
%      my $machine = ($run ~~ dpath "//hostname")->[0];
%      $summary{ $counter } = [ $runid, $machine ];
%      $counter++;
%   }
% }
<% to_json(\%summary) %>
EOTEMPLATE
'''

def send_template(template, port):
    '''
    send the template to the receiver api
    '''

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    received_data = ''
    try:
        s.connect(("165.204.15.71", port))
        s.send(template)
        if port == 7358:
            while 1:
                data = s.recv(4096)
                if not data:
                    break
                received_data += data
            return_data = simplejson.loads(received_data)
            return return_data
    finally:
        s.close()

def fetch_precond(runid):
    url = "http://tapper/tapper/testruns/%s/preconditions/yaml/" % runid
    response = urllib2.urlopen(urllib2.Request(url))
    precond = response.read()
    return precond


machines = {
             "uruk": {    "type":"warthog",
                          "ram":"12288 MB",
                          "cpu":"2x Family: 16, Model: 2, Stepping: 3"},
             "incubus": { "type":"warthog",
                          "ram":"6144 MB",
                          "cpu":""},
             "kobold": {  "type":"Cheatah",
                          "ram":"5122 MB",
                          "cpu":"2x Family: 16, Model: 2, Stepping: 2"},
             "satyr": {  "type":"PC-Ware",
                          "ram":"8192 MB",
                          "cpu":"1x Family: 15, Model: 75, Stepping: 2"},
             "lemure": {  "type":"PC-Ware",
                          "ram":"4096 MB",
                          "cpu":"1x Family: 15, Model: 107, Stepping: 1"},
             "azael": {   "type":"PC-Ware",
                          "ram":"8192 MB",
                          "cpu":"1x Family: 15, Model: 75, Stepping: 2"},
             "athene": {  "type":"PC-Ware",
                          "ram":"8192 MB",
                          "cpu":"1x Family: 15, Model: 75, Stepping: 2"},
           }


testdata = send_template(mason, 7358)
for key in testdata.keys():
    runid = testdata[key][0]
    precond = yaml.load(fetch_precond(runid))
    arch = precond["host"]["preconditions"][0]["filename"].rsplit("/",3)[-3]
    changeset = ":".join(precond["host"]["preconditions"][0]["filename"].rsplit("/",1)[-1].rsplit(".",3)[-3].split("_",2)[:2])
    xenversion = precond["host"]["preconditions"][0]["filename"].rsplit("/",2)[-2]
    dom0_kernel = "2.6.18.8-xen %s" % (arch)
    base_image = "%s (%s)" % (precond["host"]["root"]["image"].rsplit("/")[-1].rsplit("_", 3)[0].replace(
                              "_", " ").upper(), arch)
    host = testdata[key][1]

    # host meta
    tapreport = "1..1\n# Tapper-section: Metainfo\n"
    tapreport += "# Tapper-Suite-Name: Host-Overview\n"
    tapreport += "# Tapper-Suite-version: manual\n"
    tapreport += "# Tapper-machine-name: %s\n" % host
    tapreport += "# Tapper-machine-description: %s\n" % (
            machines[host]["type"])
    tapreport += "# Tapper-cpuinfo: %s\n" % (
            machines[host]["cpu"])
    tapreport += "# Tapper-ram:%s \n" % (
            machines[host]["ram"])
    tapreport += "# Tapper-uptime: 0 hrs\n"
    tapreport += "# Tapper-reportgroup-testrun: %s \n" % runid
    tapreport += "ok 1 host metadata\n"

    # xen meta
    tapreport += "1..1\n# Tapper-section: XEN-Metainfo\n"
    tapreport += "# Tapper-xen-version: %s \n" % xenversion
    tapreport += "# Tapper-xen-changeset: %s\n" % changeset
    tapreport += "# Tapper-xen-base-os-description: %s\n" % base_image
    tapreport += "# Tapper-xen-dom0-kernel: %s\n" % dom0_kernel
    tapreport += "ok 1 xen metadata\n"
    # guest meta
    for guest in precond["guests"]:
        image = guest["root"]["name"].rsplit("/",1)[-1].rsplit(".",1)[0]
        tapreport += "1..1\n# Tapper-section: %s\n" % image
        count = precond["guests"].index(guest) + 1
        desc = guest["testprogram"]["execname"].rsplit("/",1)[-1].split("_")[1]
        tapreport += "# Tapper-xen-guest-description: 00%s-%s\n" % (count,
                desc)
        tapreport += "# Tapper-xen-guest-start: not available\n"
        tapreport += "# Tapper-xen-guest-flags: not available\n"
        tapreport += "ok 1 - Guest info\n"

    send_template(tapreport, 7357)


# vim:set ft=python et ts=4 sw=4 sts=4 sta ai si tw=78:

