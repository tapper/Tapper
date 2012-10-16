#! mason debug=1 <<EOTEMPLATE
# -*- mode: cperl -*-
#! /usr/bin/env gnuplot

% my $SUITE = "CTCS";
# ----------------------------------------------------------------------
# F=CTCS_ratio ; netcat tapper 7358 < $F.gnuplot | gnuplot && eog $F.png
# ----------------------------------------------------------------------

TITLE = "success ratio: <% $SUITE %>"
set title TITLE offset char 0, char -1
set style data linespoints
set xtics rotate by 45
set xtics out offset 0,-2.0
set term png size 1200, 800
set output "<% $SUITE %>_ratio.png"
set yrange [0:110]

plot '-' using 1:2 with linespoints lt 3 lw 1 title "ratio"

% my @time  = reportdata '{ "suite_name" => "CTCS" } :: /report/id';
% my @ratio = reportdata '{ "suite_name" => "CTCS" } :: //success_ratio';
% use Data::Dumper;
% foreach (0..scalar @time) {
%   if (my $t=$time[$_] and my $r=$ratio[$_]) {
%      #my ($x, $y) = $t =~ m/\d{4}-(\d+)-(\d+)/g;
       <% $t %> <% $r  %>
%   }
% }

EOTEMPLATE
