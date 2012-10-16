#! mason debug=1 <<EOTEMPLATE
#! /usr/bin/env gnuplot
# -*- mode: gnuplot -*-

# ----------------------------------------------------------------------
# F=Tapper_ratio ; netcat tapper 7358 < $F.gnuplot | gnuplot && eog $F.png
# ----------------------------------------------------------------------

TITLE = "KernBench success ratio"
set title TITLE offset char 0, char -1
set style data linespoints

set size 0.5, 0.5
set term png size 600, 400
set output "Tapper_ratio.png"

plot '-' using 0:1 with lines lt 1 lw 1
% my @res = reportdata '{ "suite.name" => "Tapper-Reports-API" } :: //success_ratio'; #stats-proc-interrupts-before/';
% foreach (@res) {
<% $_ %>
% }

EOTEMPLATE
