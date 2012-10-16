#! mason debug=1 <<EOTEMPLATE
% use DateTime;
% use DateTime::Event::Recurrence;
% my $weekly = DateTime::Event::Recurrence->weekly;
% my $dt_start = DateTime->new( year => 2009, month => 1, day => 1 );
% my $dt_end = $dt_start->clone()->add( years => 1 );
% my @days = $weekly->as_list( start => $dt_start, end => $dt_end );
% my $week = 1;
% my @result;
% foreach my $date (@days){
%   my $suite_search = "suite_name => { 'like', [ 'Topic-%' ] }";
%   my $next = $weekly->next($date)->clone();
%   my $duration_search = "created_at => { '-between' => [ '$date' , '$next' ] }";
%   my @collected_data = reportdata "{ $suite_search, $duration_search } :: //report/id/";
%   if (scalar @collected_data > 0){
%     push @result, scalar @collected_data;
%   } else {
%     push @result, 0;
%   }
% $week++;
% }
%# gnuplot section
set print 'data.tmp'
print "Week   Testruns"
% foreach (1..$week){
%   my $w = $_ - 1;
print "<% $_ %> <% $result[$w] %>"
%   }
unset print
set title "TAPPER: Performed tests per Week\nPeriod: <% $dt_start->ymd %> - <% $dt_end->ymd %>\nCreated: `date +%F`"
set terminal postscript eps enhanced
set term png size 1024, 768
set key autotitle columnhead
set boxwidth 0.8
set xrange [ 0 : <% $week + 1 %> ]
set xlabel "Week"
set ylabel "Testruns"
set xtics 5
set ytics 25

set print "stringvar.tmp"
print "Incidents"
print "Week 05: Tapper goes live"
print "Week 12: misc"
print "Week 18/19: LAB-Net"
print "Week 34: MCP"
print "Week 39: PXE-boot"
unset print
set label 1 system("cat stringvar.tmp") at graph 0.05, graph 0.95

set output "`echo $NFS_DIR`/Misc/Tests_per_week/`date +%F`_test_overview.png"
plot 'data.tmp' using 1:2 ti col w boxes fs solid 1 ls 2

EOTEMPLATE
# vim:set ft=mason et ts=2 sw=2 sts=2 sta ai si tw=100:
