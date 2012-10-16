#! mason debug=1 <<EOTEMPLATE
# -*- mode: cperl -*-
#! /usr/bin/env gnuplot

% my $SUITE = "CTCS";
# ----------------------------------------------------------------------
# F=warmup1 ; netcat tapper 7358 < $F.gnuplot
# ----------------------------------------------------------------------

# Ziel: das hier ist gnuplot-Template, nachdem vom Server ausgefüllt

%# % perl-Zeile
%# <% perl-wert %>

%# <% Dumper($t) %>  für Datenstrukturen-Ansicht
%# Eigentliches Ziel: <% $t->{created_at_ymd_hms} %>

%# Teilziel: verstehe große Datenstruktur unter "/"
%# /report   ... Report-Basisdaten
%# /results  ... Testresultate
%#               Array, jede Zeile ist eine Section: KVM-Metainfo, guest1_rh, guest2_sles, host

%# Beispielpfad:
%# /results/*/section/"t/00-tapper-meta"/...
%# in "results", irgendeine Zeile, darin key "section", darin key "t/00-tapper-meta"

%# /results[0]/section/"t/00-tapper-meta"/...
%# in "results", erste Zeile, darin key "section", darin key "t/00-tapper-meta"

%# /results//section/"t/00-tapper-meta"/...
%# in "results", irgendwelche Zwischenschritte, dann key "section", darin key "t/00-tapper-meta"

%# "//" ist Killerfeature (leider langsam)

%# //tap
%# /results//tap/tests_run

%# Wichtige Pfade:
%# //tap/lines ... darin wieder Array aller TAP-Zeilen
%# //tap/lines/*/is_test[value == 1] ... TAP-Zeilen, die echte Test-Zeilen sind

%# Typen von TAP-Zeilen: is_version, is_plan, is_test, is_diag, is_yaml
%# //tap/lines/*/raw    ... originale TAP-Zeile


%# YAML-Blöcke erscheinen wie eine Zeile, also nur ein Element in _children

%# _children:
%#      enthält diag/yaml-Folgezeilen
%# 
%# Bsp-TAP: embedded YAML
%# 
%#     ok 1 - hot stuff
%#      ---
%#      benchmark_results:
%#          graphics: 12.1231
%#          math: 32.12
%#      ...
%#
%# //tap//description[value eq "- hot stuff"]/../_children/*/data/benchmark_results/graphics
%# //tap//description[value eq "- hot stuff"]/../_children/*/data/benchmark_results/math
%#
%# Alternativ, weiter oben liefern lassen
%# my @result = reportdata '{ ... } :: //tap//description[value eq "- hot stuff"]/..'
%#
%#  <% $result[0]->{_children}[0]{data}{benchmark_results}{graphics} %>
%#  <% $result[0]->{_children}[0]{data}{benchmark_results}{math} %>
%#
%#
%#
%# Alternative 2: auch *im* Template rohes Data::DPath nutzen:
%#
%# % use Data::DPath 'dpath';
%#
%#  <% $result[0] ~~ '/_children/*/data/benchmark_results/math' %>
%#  <% $result[0] ~~ '/_children/*/data/benchmark_results/graphics' %>
%#
%#
%#
%#
%#
%#
%#


%# auf YAML im TAP zugreifen:
%# //tap//description[value eq "- hot stuff"]/../_children/*/data/mainboard/socket_type

%# interessante Reports und Pfade finden:
%# suite_name => "CTCS"
%# section => "rhel5.4_rc1"     ... Hinweis auf interessante image
%# 


% my @time  = reportdata '{ id => "13985" } :: /';
% foreach my $t (@time) {
        <% Dumper($t) %>
        <% $t->{created_at_ymd_hms} %>
% }
EOTEMPLATE
