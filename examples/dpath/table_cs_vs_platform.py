#!/usr/bin/env python
'''
This script connects to the Tapper server and retrieves data from the performed
XEN tests in the last 2 weeks. It will generate a HTML table for each
XEN-Version with XEN-changesets as rows.
'''

import socket
import sys
import simplejson
import HTML

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
        return_data = simplejson.loads(received_data)
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
    mason = '''#! mason <<EOTEMPLATE
% use DateTime;
% my $dt1 = DateTime->today()->subtract( months => 1);
% my $dt2 = DateTime->today();
% my @collected_data = reportdata "{suite_name => {'like', 'Topic-xen%'}, created_at => { -between => ['$dt1' , '$dt2' ]  } } :: /";
% my %results;
% my @platforms = qw();
% foreach my $run_temp (@collected_data){
%   my $xen_cs    = $run_temp ~~ dpath "//xen_changeset";
%   my $xen_vers  = $run_temp ~~ dpath "//xen_version";
%   my $ratio     = $run_temp ~~ dpath "//success_ratio";
%   my $platform  = $run_temp ~~ dpath "//hardwaredb/key_word";
%   my $cpu       = $run_temp ~~ dpath "/report//hardwaredb/cpus/*/revision";
%   my $report_id = $run_temp ~~ dpath "//report/id";
%   my %platforms = map { $_ => 1 } @platforms;
%
%   if ( $xen_cs->[0] ){
%       $xen_cs->[0] =~ s/:.*//;
%       $xen_vers->[0] =~ s/-[^u].*//;
%       my $platf=$platform->[0] || 'unknown';
%       my $cpuf=$cpu->[0] || 'unknown';
%       my $platf_str = $platf.' ('.$cpuf.')';
%       push @platforms, $platf_str if not $platforms{$platf_str};
%       if ($ratio->[0] == 100){
%           $results{$xen_vers->[0]}{$xen_cs->[0]}{$platf_str}{'green'}++;
%           $results{$xen_vers->[0]}{$xen_cs->[0]}{$platf_str}{'red'} += 0;
%       } else {
%           $results{$xen_vers->[0]}{$xen_cs->[0]}{$platf_str}{'red'}++;
%           $results{$xen_vers->[0]}{$xen_cs->[0]}{$platf_str}{'green'} += 0;
%       }
%       push @{$results{$xen_vers->[0]}{$xen_cs->[0]}{$platf_str}{list}}, $report_id->[0]
%   }
% }
% foreach my $key (keys %results){
%   $results{$key}{"platforms"} = \@platforms;
% }
<% to_json(unbless \%results) %>
EOTEMPLATE
'''
    return mason

def def_colors():
    '''
    setup colors / ratio
    '''
    colors = {0:'red', 50:'orange', 75:'yellow', 95:'greenyellow',
            100:'green'}
    return colors

def legend():
    '''
    create a legend from colors()
    '''
    list_col = []
    leg = HTML.TableCell('Legend', bgcolor='lightgray',
                            width='10%', align='center')
    col = def_colors()
    for ratio in sorted(col):
        if ratio == 0:
            cell_txt =  str(ratio) + ' %'
        else:
            cell_txt = '<= %s' % (str(ratio) + '%')
        list_col.append(HTML.TableCell(cell_txt, bgcolor=col[ratio],
                        width='10%', align='center'))
    my_legend = HTML.Table(rows=[[leg] + list_col])
    return str(my_legend)

def link(tmp_list):
    '''
    generate links to Tapper
    '''
    if len(tmp_list) > 1:
        link_html = HTML.link('results+',
        'https://tapper/tapper/reports/idlist/' +
        ','.join(str(l) for l in tmp_list))
    elif len(tmp_list) == 1:
        link_html = HTML.link('results',
            'https://tapper/tapper/reports/id/' +
            ','.join(str(l) for l in tmp_list))
    return link_html

def main():
    '''
    this is the main section
    '''
    data = send(template())
    path = ""
    my_file_all = open(path + 'table_XEN_changeset_vs_platform.html', 'w')
    for xen_ver in sorted(data):
        my_file = open('table_' + xen_ver + '_changeset_vs_platform.html', 'w')
        head = HTML.TableRow(cells=([xen_ver] + [i.upper() for i in
            sorted(data[xen_ver]['platforms'])]), bgcolor='white', header=True)
        my_table = HTML.Table(rows=[head])
        for xen_cs, values in sorted(data[xen_ver].iteritems()):
            if xen_cs == 'platforms':
                break
            list_ratio = []
            for platform in sorted(data[xen_ver]['platforms']):
                if values.has_key(platform):
                    plat = values[platform]
                    res_link = link(plat['list'])
                    cols = def_colors()
                    for rcol in sorted(cols):
                        if plat['green'] * 100 / (plat['green'] +
                                plat['red']) >= rcol:
                            color = cols[rcol]
                else:
                    res_link = 'no tests'
                    color = 'gray'
                list_ratio.append(HTML.TableCell(res_link, bgcolor=color,
                                                width='7%', align='center'))
            my_table.rows.append([HTML.TableCell(xen_cs, bgcolor='lightgray',
                width='7%', align='center')] + list_ratio)
        my_file.write(str(my_table))
        my_file.write(legend())
        my_file.write('<p>')
        my_file_all.write(str(my_table))
        my_file_all.write(legend())
        my_file_all.write('<p>')

if __name__ == '__main__':
    main()

# vim:set sr et tw=80 ts=4 sw=4 st=4 ft=python syn=python fenc=utf-8:

