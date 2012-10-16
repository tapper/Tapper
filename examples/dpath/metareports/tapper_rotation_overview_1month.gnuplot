#! mason debug=1 <<EOTEMPLATE
# -*- mode: cperl -*-
#! /usr/bin/env gnuplot

% use Data::DPath 'dpath';
% use Data::Dumper;
% use DateTime;
% my %summary =();
% my @test_suites = ("CTCS", "KernBench", "LTP", "Kernel-Boot", "LMBench");
% my $duration = 1;
% my $dt1 = DateTime->today();
% my $dt2 = DateTime->today()->subtract( months => $duration );
set print "data.tmp"
print "Testsuite failed passed"
% foreach my $suite (@test_suites){
%   my $rscore  = "{'suite_name'  => '$suite', 'created_at' => { -between => [ '$dt2' , '$dt1' ] } }";
%   my $counter = 0;
%   my $fail    = 0;
%   my @suite_score = reportdata "$rscore :: //success_ratio";
%   foreach my $score (@suite_score){
%     $counter += 1;
%     if ($score < 100){
%       $fail += 1;
%     }
%  }
%
%#  create summary in tmp file
%   $summary{ $suite } = [ $counter, $fail ];
print "<% $suite %> <% $fail %> <% $counter %>
% }
unset print
%
%# gnuplot section
set title "TAPPER Overview: performed vs. failed tests\nDuration: <% $dt1->ymd %> - <% $dt2-ymd %>\nCreated: `date +%F`"
set terminal postscript eps enhanced
set term png size 1024, 768
set bar 1.000000
set border 3 front linetype -1 linewidth 1.000
set boxwidth 0.75 absolute
set style fill  solid 1.00 border -1
set style rectangle back fc lt -3 fillstyle  solid 1.00 border -1
set grid nopolar
set grid noxtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   linetype 0 linewidth 1.000,  linetype 0 linewidth 1.000
set key outside right top vertical Left reverse enhanced autotitles columnhead nobox
set key invert samplen 4 spacing 1 width 0 height 0
set style histogram rowstacked title  offset character 0, 0, 0
set datafile missing '-'
set style data histograms
set xtics border in scale 1,0.5 nomirror offset character 0, 0, 0
set xtics norangelimit
set ytics auto
set rrange [ * : * ] noreverse nowriteback  # (currently [0.00000:10.0000] )
set trange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set urange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set vrange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set ylabel "% of total"
set ylabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by 90
set y2label  offset character 0, 0, 0 font "" textcolor lt -1 rotate by 90
set yrange [ 0.00000 : 100.000 ] noreverse nowriteback
set cblabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by 90
set output "`echo $NFS_DIR`/Rotation_overview/03_monthly/`date +%F`_tapper_overview_last_month.png"

set print "stringvar.tmp"
print "Results"
% foreach my $test (@test_suites){
print "<% $test %>: <% $summary{$test}->[1] %> of <% $summary{$test}->[0] %> failed"
% }
unset print
set label 1 system("cat stringvar.tmp") at graph 0.93, graph 0.76

plot 'data.tmp' using (100.*$2/$3):xtic(1) title column(2), '' using (100.*$3/$3) title column

EOTEMPLATE
