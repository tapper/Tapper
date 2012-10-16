#! mason DEBUG=1 <<EOTEMPLATE
% # define variables for the search
% use DateTime;
% my $topics = "Topic-%', 'CTCS', 'LMBench', 'LTP', 'KernBench', 'AIMbench', 'LLCbench', 'oprofile', 'ReAIMbench', 'Phoronix%', 'EDAC', 'CPUFreq', 'C-states%', 'Topology";
% my $duration = 1;
% my $dt1 = DateTime->today()->subtract( months => $duration );
% my $dt2 = DateTime->today()->add( days => 1 );
% # define the searches
% my $suite_search = "suite_name => { 'like', [ '$topics' ] }";
% my $duration_search = "created_at => { '-between' => [ '$dt1' , '$dt2' ] }";
% my @collected_data = reportdata "{ $suite_search, $duration_search } :: /report";
% my %results;
% # collect the data and put into structure
% foreach my $run_temp (@collected_data){
%   my $ratio     = $run_temp ~~ dpath "//success_ratio/";
%   my $title     = $run_temp ~~ dpath "//suite_name/";
%   $title->[0] =~ s/Topic-//;
%   $title->[0] =~ s/-(32|64|default|mix)$//;
%   push @{$results{$title->[0]}}, $ratio->[0];
% }
% # gnuplot area
% while ((my $key, my $value) = each(%results)) {
set print 'data.tmp'
%   my $counter = 1;
%   my $average = 0;
%   my $temp_add = 0;
%   foreach my $data (@$value){
%     $temp_add += $data;
%     $average = $temp_add/$counter;
print "<% $counter %> <% $data %> <% $average %>"
%     $counter++;
%   }
unset print
set title "<% $key %>: Success Ratio\nTimeframe: <% $dt1->ymd %> - <% $dt2->ymd %>\nCreated: `date +%F`"
set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
set terminal postscript eps enhanced
set term png size 1024, 768
set output "<% $key %>_`date +%F`_success_ratio_<% $key %>.png"
plot 'data.tmp' using 1:2 title "Success Ratio" with imp ls 2, \
     'data.tmp' using 1:2 smooth bezier title "normalized (bezier)" with lines ls 1, \
     'data.tmp' using 1:3 title "Average" with lines ls 3
% }

%#<% Dump(\@collected_data) %>
%#<% Dump($title->[0]) %>

EOTEMPLATE
# vim:set ft=mason et ts=2 sw=2 sts=2 sta ai si tw=100:
