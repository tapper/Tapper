### Welcome to Tapper

#### Tapper is...

* a test *infrastructure*.
* designed to allow an easy start.
* designed to extend to complex test labs
* able to unify lots of different use-cases under a common umbrella
* generic enough to compete with the future
* mature

#### Tapper originated...

at AMD's [Operating System Research Center](http://amd64.org) where it
serves as umbrella for all QA. It integrates 10+ years of QA know-how
and Linux testing expertise since 2008. It is now also the
infrastructure behind the Perl benchmarking infrastructure
[Perl::Formance](http://perlformance.net).

#### Tapper provides...

* extreme continuous integration through setting up complete machines
  from scratch, either image-based or via kickstart/autoyast/preseed.
* alternative easy ssh-based test invocation
* test facilities for the Linux kernel, virtualization based on Xen
  and KVM, and running in simulators (like simnow)
* support for lots of other scenarios, like suspend/resume or distributed
  network tests
* benchmark tracking facilities
* powerful, advanced query language for test result evaluation and
  forensics
* a powerful scheduler to maximize utilization of a machine pool with
  different use-cases organized in bandwidth-driven queues

#### Tapper APIs...

* are easy, without requiring dependencies to talk to them
* allow integration of your existing infrastructure with nothing more
  like shell scripts using "echo" and "netcat"

#### Tapper encourages...

the use of language diversity for writing tests by building upon TAP,
the mature "Test Anything Protocol", supported in about 20 programming
languages.

#### Tapper co-operates...

with

* autotest
* Codespeed
* TaskJuggler
* any TAP emitters

#### Related material

* [Overview](http://www.amd64.org/fileadmin/user_upload/pub/linuxcon_eu_2011_linux_and_virtualization_testing_with_tapper.pdf)
  presentation at Linuxcon Europe 2011
* [TAP Juggling](http://amd64.org/fileadmin/user_upload/pub/yapc_eu_2011_tapjuggling.pdf)
  at YAPC::EU 2011
* [Query API](http://www.amd64.org/fileadmin/user_upload/pub/yapc_eu_2009_cinderella_tap.pdf)
  at YAPC::EU 2009
* [Tapper on github](http://github.com/amd)
