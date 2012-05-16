use strict;
use warnings;
package Tapper;
# ABSTRACT: A flexible and open test infrastructure

1;

=head1 ABOUT

Tapper is a modular, flexible and open test infrastructure.

It's only primary assumption is the ubiquitous use of the B<Test
Anything Protocol> (TAP). Internally it is based on technology known
from the CPAN testing infrastructure, extending it with automation and
advanced querying.

It allows to setup a test infrastructure, consisting of

=over 4

=item a central TAP database

to where tests can send their results for storage and later
evaluation, using a L<DPath|Data::DPath> based query language over a
history of L<TAP-DOMs|TAP::DOM>.

=item extremely lightweight APIs

to allow QA in very low-level, toolchain constrained environments,
like OS testing or embedded platforms

=item support for "classic" userland, OS, and virtualization testing

=item an optional advanced automation layer

=back

Tapper originated in the AMD Operating System Research Center (OSRC),
where it is used for extreme continuous integration testing of
everything: from software toolchains over Linux to Xen and KVM.

It is also used in the Perl benchmarking infrastructure
L<Perl::Formance|http://perlformance.net>.

Most of Tapper is OS and platform independent (x86, ARM) to cover
broad range of test targets. Only the central automation layer (MCP)
is a bit Linux centric in its use of external dependencies.

=head1 MORE

=over 4

=item L<Tapper homepage on amd64.org|http://www.amd64.org/support/automated-test-infrastructure.html>

=item L<Tapper libs on github|https://github.com/amd>

=item L<Tapper wiki on github|https://github.com/amd/Tapper/wiki>

=back

=head1 GENERAL TAPPER SUPPORT

=head2 IRC

Via IRC you can contact us in channel

 #tapper

on

  irc.freenode.net

=head2 Mailing List

There is a mailing list
L<tapper@amd64.org|http://www.amd64.org/mailman/listinfo/tapper/>.

=cut
