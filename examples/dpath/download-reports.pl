#!/usr/bin/env perl

use common::sense;
use IO::Socket::INET;

die "Too few arguments.
Usage: $0 suite_name file_name\n" unless @ARGV > 1;
my $file = $ARGV[1];

my $search = q(#! mason debug=1 <<EOTEMPLATE
% my @results  = reportdata "{suite_name => ');
$search .= $ARGV[0];
$search .= q('} :: /";
% use Data::Dumper;
% foreach my $result (@results) {
<% $result->{report}->{id} %>
% }
EOTEMPLATE
);

my $sock = IO::Socket::INET->new(PeerAddr => 'tapper',
                                 PeerPort => '7358',
                                 Proto    => 'tcp') or die "Can not open socket: $!\n";
$sock->print($search);

my @reports;
while (my $line = <$sock>){
        push @reports,int($line); 
}
close $sock;

foreach my $report ( @reports ) {
        $sock = IO::Socket::INET->new(PeerAddr => 'localhost',
                                      PeerPort => '7358',
                                      Proto    => 'tcp') or die "Can not open socket: $!\n";
        $sock->print("#! download $report $file\n");
        open my $fh, ">", "$file-$report" or die "Can't open ./$file-$report: $!" ;
        while (my $line = <$sock>) {
                print $fh $line;
        }
        close $sock;
        close $fh;
        say STDERR "Wrote ./$file-$report";
}
