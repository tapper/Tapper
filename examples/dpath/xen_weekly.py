#!/usr/bin/env python

###
# Author : Conny Seidel <conny.seidel@amd.com.de>
# Descr. : plot "MetaReport: XEN testing effort"
# Created: 2009-09-28
# Updated: 2009-12-05
###
'''
Plot timely overview of XEN testing effort
'''

import re
import simplejson
import socket
from matplotlib.pylab import *
from matplotlib.colors import colorConverter

Mason = '''#! mason <<EOTEMPLATE
% use DateTime;
% my $dt1 = DateTime->today();
% my $dt2 = DateTime->today()->subtract( weeks => 4);
% my @res  = reportdata "{suite_name => {'like', 'Topic-%'}, created_at => { -between => ['$dt2' , '$dt1' ]  } } :: /";
% my @tests;
% foreach my $lala (@res){
%   my $platform = $lala ~~ dpath "//report/*/key_word/";
%   my $cpu_type = $lala ~~ dpath "//revision";
%   my $xen_keys = $lala ~~ dpath "//xen_version/../";
%   if (keys %{$xen_keys->[0]} != 0){
%       my $platf = "$platform->[0] ($cpu_type->[0])" || 'unknown';
%       my $test  = { "platform" => $platf,  %{$xen_keys->[0]} };
%       push @tests, $test;
%   }
%}
<% to_json( unbless \@tests) %>
EOTEMPLATE
'''


def pastel(colour, weight=2.4):
    '''
    Convert colour into a nice pastel shade
    '''

    rgb = asarray(colorConverter.to_rgb(colour))
    # scale colour
    maxc = max(rgb)
    if maxc < 1.0 and maxc > 0:
        # scale colour
        scale = 1.0 / maxc
        rgb = rgb * scale
    # now decrease saturation
    total = sum(rgb)
    slack = 0
    for x in rgb:
        slack += 1.0 - x

    # want to increase weight from total to weight
    # pick x s.t.  slack * x == weight - total
    # x = (weight - total) / slack
    x = (weight - total) / slack

    rgb = [c + (x * (1.0-c)) for c in rgb]

    return rgb

def get_colours(n):
    '''
    Return n pastel colours.
    '''

    colours = []
    for cols in range(n):
        list = []
        for i in range(3):
            col = "%1.2f" %  random()
            list.append(float(col))
        colours.append(list)
    return [pastel(c) for c in colours[0:n]]


def send_template(template):
    '''
    send the template to the receiver api
    '''

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    received_data = ''
    try:
        s.connect(("165.204.15.71", 7358))
        s.send(template)
        while 1:
            data = s.recv(4096)
            if not data:
                break
            received_data += data
        return_data = simplejson.loads(received_data)
    finally:
        s.close()
        return return_data


def prep_data(data):
    '''
    format, count and generate data structure
    '''

    hardware = { '32 bit': {}, '64 bit': {} }
    version_list = []
    plat_list = []
    for i in data:
        # has "i686" in the value?
        if re.search(regex[0], i['xen_dom0_kernel']):
            bitness = '32 bit'
        # has "x86_64" in the value?
        elif re.search(regex[1], i['xen_dom0_kernel']):
            bitness = '64 bit'
        # short the expression for key
        version = i['xen_version']
        # so that the plots are compareable we collect the versions
        if not version_list.count(version):
            version_list.append(version)
        # same shortcut here
        platf = i['platform'].upper().replace('_', '-')
        if not plat_list.count(platf):
            plat_list.append(platf)
        if not hardware[bitness].has_key(platf):
            hardware[bitness][platf] = {version: 1 }
        elif not hardware[bitness][platf].has_key(version):
            hardware[bitness][platf][version] = 1
        else:
            hardware[bitness][platf][version] += 1
    return hardware, sorted(version_list), plat_list


regex = [ re.compile('i686'), re.compile('x86_64') ]
test_data = send_template(Mason)
results, versions, platforms = prep_data(test_data)
platforms.sort()

data = {'32 bit':[], '64 bit':[]}
rows = {'32 bit':[], '64 bit':[]}
for bit in results.keys():
    for plat in platforms:
        tmp_data = []
        # add data for missing platforms
        if not results[bit].has_key(plat):
            tmp_data.append([0] * len(versions))
        else:
            for v in versions:
                if results[bit][plat].has_key(v):
                    tmp_data.append(results[bit][plat][v])
                else:
                    tmp_data.append(0)
        data[bit].append(tmp_data)
        rows[bit].append(plat)
'''
#debug
print '%s\n%s\n%s' % (data, platforms, versions)
'''

rc("font", family="terminus")
rc("font", size=8)


axes([0.2, 0.2, 0.7, 0.6])   # leave room below the axes for the table

data1 = data['32 bit']
data2 = data['64 bit']

colLabels = versions
rowLabels = platforms
# Get some pastel shades for the colours
colours = get_colours(len(rowLabels))
rows = len(data1)
ind = arange(len(colLabels)) +0.3  # the x locations for the groups
cellText1 = []
cellText2 = []
width = .45     # the width of the bars
plt.subplots_adjust(bottom=0.2,left=0.23, right=0.90, hspace=0.85)

plt.subplot(211)
title('Weekly XEN testing effort per Platform')
ylabel("32bit tests")
yoff = array([0.0] * len(colLabels)) # the bottom values for stacked bar chart
for row in xrange(rows):
    bar(ind, data1[row], width, bottom=yoff , color=colours[row])
    yoff = yoff + data1[row]
    cellText1.append(['%i' % (x) for x in data1[row]])
cellText1.reverse()
colours.reverse()
rc("font", size=10)
# Add a table at the bottom of the axes
the_table = table(cellText=cellText1,
                  rowLabels=rowLabels, rowColours=colours,
                  colLabels=colLabels,
                  loc='bottom')
rc("font", size=8)
xticks([])
colours.reverse()
plt.subplot(212)
ylabel("64bit tests")
yoff = array([0.0] * len(colLabels)) # the bottom values for stacked bar chart
for row in xrange(rows):
    bar(ind, data2[row], width, bottom=yoff, color=colours[row])
    yoff = yoff + data2[row]
    cellText2.append(['%i' % (x) for x in data2[row]])
cellText2.reverse()
colours.reverse()

# Add a table at the bottom of the axes
rc("font", size=10)
the_table = table(cellText=cellText2,
                  rowLabels=rowLabels, rowColours=colours,
                  colLabels=colLabels,
                  loc='bottom')

xticks([])
savefig('xen_testing_effort', dpi=150)
#show()

# vim:set sr et ts=4 sw=4 st=4 ft=python syn=python fenc=utf-8:
