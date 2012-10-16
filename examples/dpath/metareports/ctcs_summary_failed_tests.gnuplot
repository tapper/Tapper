#! mason debug=1 <<EOTEMPLATE
% use Data::Dumper;
% my $SUITE = 'CTCS';
% my %statistic;
% my %fail;
%
%# collect all CTCS tests from the database
% foreach my $rep (reportdata "{ suite_name => '$SUITE',  } :: //CTCS-results/tap/lines/*/description/../"){
%       my $description = $rep ~~ dpath "//description";
%       foreach my $desc (@$description){
%           my $path = "//description[value eq '$desc']/../is_ok/";
%           my $result = $rep ~~ dpath $path;
%           $statistic{$desc}++;
%           if ( $result->[0] ){
%               $fail{$desc} += 0;
%           } else {
%               $fail{$desc}++;
%           }
%       }
% }
%# gnuplot area
set term postscript eps enhanced color
set title "<% $SUITE %>: performed vs. failed subtests\nCreated: `date +%F`"
set style histogram rows
set style fill solid .9 border -1
set term png size 1024, 768
set output "`echo $NFS_DIR`/Misc/CTCS/`date +%F`_<% $SUITE %>_tests_performed_vs_failed.png"
set xtic auto rotate by 90
set ytic auto
%# generate temp data file
set print "<% $SUITE %>_data.tmp"
% my $count = 1;
% foreach my $k (keys (%statistic)){
print "<% $count %> <% $k %> <% $statistic{$k} %> <% $fail{$k} %>"
% $count += 1;
%}
unset print
%# need some range adjustments to prevent cutoffs on the etches
% my $range = (scalar keys %statistic) + 1;
set xrange [-1:<% $range %>]

plot '<% $SUITE %>_data.tmp' using 4:xticlabels(3) w boxes lc rgb 'green' title "performed", \
     '' using 5 w boxes lc rgb 'red' title "failed"

EOTEMPLATE

# vim:set ft=mason et ts=2 sw=2 sts=2 sta ai si tw=100:
