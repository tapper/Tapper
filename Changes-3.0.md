## Tapper release 3.0 2011-03-02 (first public release)

Tapper is an infrastructure for all aspects of testing inclusive
Operating Systems and Virtualization.

## Tapper contains

* Automation
* Machine Scheduling
* Command line utils
* Web Frontend application
* Support for writing tests
* Powerful result evaluation API
* Testplan support with TaskJuggler
* Many use-cases from tracking test results to benchmarking to full OS testing including virtualization

## Feature overview

### Automation

* Network boot (PXE + TFTP + NFS)
* Machine self-setup driven by abstract specfiles
* Image-based or kickstart/autoyast based installation
* Lightweight status API to easily plug in foreign installers
* Support for virtualization setups (Xen and KVM)
* Inject packages, programs, files into hosts/guests
* Control execution of test scripts in hosts/guests
* Interdependent setup and sync of co-operating machines
* Complex timeout handling for complete test cycle, inclusive virtualizated guest
* Reboot handling
* Console logging
* Hardware reset

### Scheduling

* Optimize utilization of pools with "not enough" machines for "too many use-cases"
* Multiplex queues of freely definable use-cases (e.g., Xen, KVM, baremetal kernels, ad-hoc tests, benchmarks) with different bandwidths
* Pluggable core scheduling algorithm (default "Weighted Fair Queuing")
* Feature driven host matching (by memory, cores, vendor, etc. or complex combinations)
* Dynamic queue and host management (add, delete, de/activate)
* Host/queue binding for dedicated scheduling
* Auto re-queuing for continuous testing
* Multi-host scenarios

### Web Application

* Frontend to 2 databases: testruns and reports
* Providing a "management view" and high-level test result evaluation
* Overview lists and detailed zoom-in, GREEN/YELLOW/RED coloring
* Filters over time, testsuites, machines, success status
* RSS feeds on such filters
* Visualize groups of connected results (virtualized neighbour guests)
* Control start of testruns

### Result Evaluation

* Programmable complement to the web frontend
* Allow complex queries on the test result database
* No client side toolchain neccessary
* Easy API to send and get back queries embedded in templates
* API allows SQL and XPath like queries in an abstract way
* Presentation about the query interface at the YAPC::Europe 2009

### Testplan Support

* Testplans combine many Tapper features into concise points of interest
* Manage testplan hierarchy allowing specfile reuse for complex testplan matrix
* Interoperation with TaskJuggler on dedicated QA tasks for automatic scheduling and reporting
* Consequently a complete focused QA life cycle of planning, execution and reporting

### Support for writing tests

* Format test results based on standard Test Anything Protocol (TAP)
* Existing standard TAP toolchains available for about 20 programming languages
* Dedicated Tapper support for Shell, Perl, Python available

### Many use-cases

* Kernel testing (stress, function, reboot)
* Virtualization Testing (Xen, KVM)
* Test matrix of host/guest combinations
* Distribution testing (like OS or compilers)
* Multi-machine scenarios
* Complex result evaluation

### Technology

* Test Anything Protocol (TAP)
* Core system written in Perl and CPAN
* DB independent via OR mapper, developed on MySQL and SQLite
* HTML/CSS, cautious Javascript
* Language agnostic testing (e.g, Perl/Python/Shell test suites)
* PXE, GRUB, TFTP, NFS boot automation
* Strong decoupling of functional layers (webgui, testsuites, automation) to allow you amalgamate own infrastructures

## Correlation to autotest.kernel.org

The main focus of autotest.kernel.org project is on testing the Linux
kernel. It provides a broad coverage of kernel functionality testing
and wrappers of many existing test suites.

Tapper provides many complex scenarios, like virtualization (Xen/KVM),
distribution testing (RHEL, SLES, Debian), SimNow testing and
benchmarking. Tapper can schedule them all multiplexed with according
bandwidths over large or small machine pools. The autotest.kernel.org
client can be used in a Tapper infrastructure via a thin wrapper that
utilizes the TAP export we provided to the autotest project. Tapper
then complements it with Testplan support, a result database and a
homogeneous result evaluation API.  More information about Tapper:
Downloading Tapper

* https://github.com/amd
* search.cpan.org/~amd

## Tapper Support

* IRC: #tapper (irc.freenode.net)
* Mailing List: tapper@amd64.org
