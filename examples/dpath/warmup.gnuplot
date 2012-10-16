#! mason debug=1 <<EOTEMPLATE
# -*- mode: cperl -*-
#! /usr/bin/env gnuplot

% my $SUITE = "CTCS";
# ----------------------------------------------------------------------
# F=warmup ; netcat tapper 7358 < $F.gnuplot | gnuplot && eog $F.png
# ----------------------------------------------------------------------

% my @time  = reportdata '{ id => 22265 } :: /';

% foreach my $t (@time) {
        <% Dumper($t) %>
% }
EOTEMPLATE
