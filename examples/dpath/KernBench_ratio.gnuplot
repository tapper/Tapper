#! mason debug=1 <<EOTEMPLATE
# -*- mode: gnuplot -*-
#! /usr/bin/env gnuplot

% my $SUITE = "KernBench";
# ----------------------------------------------------------------------
# F=KernBench_ratio ; netcat tapper 7358 < $F.gnuplot | gnuplot && eog $F.png
# ----------------------------------------------------------------------

TITLE = "success ratio: <% $SUITE %>"
set title TITLE offset char 0, char -1
set style data linespoints
set tics rotate by 45
set xtics out offset 0,-1.0
set term png size 1200, 800
set output "<% $SUITE %>_ratio.png"
set yrange [0:110]

plot '-' using 0:2 with steps lt 3 lw 1 title "ratio"

% my @time  = reportdata '{ "suite_name" => "KernBench" } :: /report/created_at_ymd_hms';
% my @ratio = reportdata '{ "suite_name" => "KernBench" } :: //success_ratio';
% use Data::Dumper;
% foreach (0..scalar @ratio) {
%   if (my $t=$time[$_] and my $r=$ratio[$_]) {
%      my ($x, $y) = $t =~ m/\d{4}-(\d+)-(\d+)/g;
       "<% $t %>" <% $r  %>
%   }
% }

EOTEMPLATE
