#! /usr/bin/env perl

use 5.010;
use strict;
use warnings;

use Data::Dumper;
use Data::DPath "dpath";

my @res;
print STDERR "Read data...\n";
eval qx!cat data.pl!;
print STDERR "Evaluate...\n";

sub match {
        my ($report, $dpath) = @_;

        # say "  $dpath";
        my $result = $report ~~ dpath $dpath;
        foreach (@$result) {
                $_->{_report_id} = $report->{report}{id} if ref $_ eq "HASH"
        }
        return $result;
}

sub res_match {
        my ($res, $benchmark_names, $language, $host, $version, $series) = @_;

        my $lazy_result;
        foreach my $benchmark (@$benchmark_names) {
                foreach my $report (@$res) {
                        my $_version  = $version;  $_version  =~ s/\./\\./g;
                        my $_host     = $host;     $_host     =~ s/\./\\./g;
                        my $dpath = qq'//data//language_series[ value eq "$series"]/../benchmark[ value eq "$benchmark"]/../language_binary[value =~ m!$_version/bin/$language!]/../hostname[value eq "$_host"]/..';
                        my $benchvalues = match($report, $dpath);
                        push @{$lazy_result->{$host}{$language}{$series}{$version}{$benchmark}}, $benchvalues;
                }
        }
        return $lazy_result;
}

my %benchmarks = map { $_ => 1 } @{ \@res ~~ dpath "//data//mean/../benchmark" };
my @benchmark_names = keys %benchmarks;
#@benchmark_names = qw(call_method_unknown call_simple);

my $super_result;
my $lazy_result;

my $language = "python";
foreach my $host (qw(elemente)) {
 foreach my $version (qw(2.4 2.5 2.6 2.7)) {
  foreach my $series (qw(o0 o1 o2 o3)) {
    $lazy_result = res_match(\@res, \@benchmark_names, $language, $host, $version, $series);
  }
 }
}

# reduce
$language = "python";
foreach my $host (qw(elemente)) {
 foreach my $version (qw(2.4 2.5 2.6 2.7)) { # that's the repetition cause... !?
  foreach my $series (qw(o0 o1 o2 o3) ) {
   foreach my $benchmark (@benchmark_names) {
    foreach (@{$lazy_result->{$host}{$language}{$series}{$version}{$benchmark}}) {
            push @{$super_result->{$host}{$language}{$series}{$version}{$benchmark}}, @$_ if @$_;
    }
   }
  }
 }
}

print Dumper($lazy_result);
print Dumper($super_result);
