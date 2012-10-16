#!/usr/bin/env python

#############
# Author : Conny Seidel <conny.seidel@amd.com>
#############

'''
This is a testscript to gather the needed information in Python via socket and
mason template.
'''
import sys
import re
import numpy as np
import matplotlib.pyplot as plt
from socket import *


mason='''#! mason <<EOTEMPLATE
% use Data::DPath 'dpath';
% use Data::Dumper;
% use DateTime;
%# my $dt1 = DateTime->new( year => 2009, month => 9,day => 11,hour => 7,minute => 29,second => 58,nanosecond => 0,time_zone => 'GMT',);
%# my $dt2 = DateTime->new( year => 2009, month => 9,day => 11,hour => 7,minute => 30,second => 59,nanosecond => 0,time_zone => 'GMT',);
%# proper timedefinition
% my $dt1 = DateTime->today()->subtract( weeks => 1 );
% my $dt2 = DateTime->today();
% my @test  = reportdata "{ suite_name => {'like', 'Topic-%'}, created_at => { -between => [ '$dt1' , '$dt2' ] } } :: //xen_changeset/../";
% foreach my $t (@test) {
%    while ( my ($key, $value) = each(%$t) ) {
%        print "$value,";
%    }
%    print "\\n";
% }
EOTEMPLATE
'''

def send_template(template):
    '''
    send the template to the receiver api
    '''
    s = socket(AF_INET, SOCK_STREAM)
    received_data = ''
    try:
        s.connect(("165.204.15.71",7358))
        s.send(template)
        while 1:
            data = s.recv(4096)
            if not data: break
            received_data += data
    finally:
        s.close()
        return received_data.split('\n')



def parse(data):
    '''
    sort the collected data
    '''
    summary = { 32 : [], 64 : [] }
    for lines in data:
        if not data == '':
            split = re.sub(r',$','', lines).split(',')
        if re.search('.*xen.*i686.*', lines):
            summary[32].append(split)
        elif re.search('.*xen.*x86_64.*', lines):
            summary[64].append(split)
    return summary

def format_results(format):
    res = {}
    for key in format.keys():
        tmp_dict = {}
        for value in format[key]:
            if not tmp_dict.has_key(value[1]):
                tmp_dict[value[1]] = 1
            else:
                tmp_dict[value[1]] += 1
        res[key] = { 'versions': sorted(tmp_dict.keys()),
                'values': [tmp_dict[i] for i in sorted(tmp_dict.keys())] }
    return res[32], res[64]

test_data = send_template(mason)
parsed_data = parse(test_data)
i386, x86_64 = format_results(parsed_data)

N = len(i386['values'])

bit32 = i386['values']

ind = np.arange(N)  # the x locations for the groups
width = 0.35       # the width of the bars

fig = plt.figure()
ax = fig.add_subplot(111)
rects1 = ax.bar(ind, bit32, width, color='b')

bit64 = x86_64['values']
rects2 = ax.bar(ind+width, bit64, width, color='g')

# add some
ax.set_ylabel('Tests')
ax.set_title('Overview:\nXEN testing effort')
ax.set_xticks(ind+width)
ax.set_xticklabels( i386['versions'] )
ax.set_yticks(np.arange(0,60,10))

ax.legend( (rects1[0], rects2[0]), ('32 bit', '64 bit') )

def autolabel(rects):
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x()+rect.get_width()/2., 1.05*height, '%d'%int(height),
                ha='center', va='bottom')

autolabel(rects1)
autolabel(rects2)

plt.show()




# vim:set ft=python et ts=4 sw=4 sts=4 sta ai si tw=78:
