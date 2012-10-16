#!/usr/bin/env python
'''
This script connects to the Tapper server and retrieves data from the performed
Phoronix tests in the last 1 week.
'''

import socket
import sys
import simplejson as json
import yaml
from statlib import stats


def send(perl_template):
    '''
    send the template to the receiver api
    '''
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    received_data = ''
    try:
        sock.connect(("165.204.15.71", 7358))
        sock.send(perl_template)
        while 1:
            data = sock.recv(1024)
            if not data:
                break
            received_data += data
        #print received_data
        #sys.exit(0)
        return_data = json.loads(received_data)
        #print return_data
        #sys.exit(0)
        return return_data
    except socket.gaierror, err:
        print "Address-related error connecting to server: %s" % err
        sys.exit(1)
    except socket.error, err:
        print "Connection error: %s" % err
        sys.exit(1)
    finally:
        sock.close()

def template():
    '''
    This is just a placeholder to part the Python and the Perl code
    '''
    mason = '''#! mason debug=1 <<EOTEMPLATE
% use DateTime;
% my $dt1 = DateTime->today()->subtract(days => 1);
%# my $dt1 = DateTime->new(year => 2010, month=>9, day =>18 );
% my $dt2 = DateTime->today()->add(days => 1);
% my @runs  = reportdata "{
%    suite_name => { 'like', [ 'Phoronix%' ] },
%    created_at => { -between => ['$dt1' , '$dt2' ]  },
%    machine_name => { 'like', ['calcium', 'incubus', 'schwertleite'] }
% } :: /";
% my %sumary;
% foreach my $run (@runs){
%   my $kernel_ver =  $run ~~ dpath "//groupcontext//kernel";
%   my $hostname =  $run ~~ dpath "//hostname";
%   my $testid =  $run ~~ dpath "//id";
%   my @data = $run ~~ dpath "//Phoronix-Results//data/";
%   foreach my $result (@data){
%   my @res= ($hostname->[0], @$result);
%   push @{$sumary{$kernel_ver->[0]}{$testid->[0]}}, @res;
%   }
% }
<% to_json( unbless \%sumary) %>
EOTEMPLATE
'''
    return mason

def main():
    '''
    this is the main section

    {kernel: {machine : {[results]} } }
    '''
    scales = {}
    data = send(template())
    for kernel, results in data.iteritems():
        for testid, run_data in results.iteritems():
            machine = run_data.pop(0)
            print "\n%s" % (kernel,)
            for i in range(len(run_data)):
                for single_bench in run_data[i].itervalues():
                    if type(single_bench) == dict:
                        value = [float(x) for x in
                                single_bench.get("RawString").split(":")]
                        val = stats.mean(value)
                        if len(value) > 1:
                            std = stats.stdev(value)
                        else:
                            std = float(0)
                        name = single_bench.get("Name")
                        attr = single_bench.get("Attributes")
                        scale = single_bench.get("Scale")
                        print "%s: %s (%s): %.2f %s (std %.2f)" % (machine,
                                name, attr, val, scale, std)
                        scales[scale] = scales.get(scale, "")
    print scales
if __name__ == '__main__':
    main()

# vim:set sr et tw=80 ts=4 sw=4 st=4 ft=python syn=python fenc=utf-8:
