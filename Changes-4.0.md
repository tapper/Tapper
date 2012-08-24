* She's mad at everybody. She's even mad at the ice cream man.
  "Why does the ice cream truck have to come just before lunch
  or just before dinner, spoil the children's appetite?"
  I have to listen to that. I hear that 3 time a week, you know
  that's 12 times a month.

  Columbo, "The Most Crucial Game" (1972)

## Tapper release 4.0 codename "Columbo" 2012-05-16

### Automation

* better linux32 chroot/exec support
* persistent automation layer, based on event-queues
  (Tapper::MCP, Tapper::MCP::MessageReceiver)
* introduce SSH-connect to test without complete machine setup
* support suspend/resume testing;
  via abstract central 'actions' to be called from remote clients
  (Tapper::Action)
* conditionally trigger notifications on incoming results
  (Tapper::Notification)
* keep-alive mechanics for broken hosts
* much better scriptability everywhere to support strangest
  requirements
* reworked TaskJuggler/Testplan bridge
  (Tapper::Testplan)

### Testsuites

* Tapper-autotest wrapper:
* now send+upload virtually all result details+files
* allow use snapshots to not suffer from upstream changes
* Tapper-autoreport: better virtualization support (probably the
  world's current best Xen/KVM host/guest detection heuristics,
  really)
* better Perl::Formance benchmarking integration

### Reports database

* store attachments bzip2 compressed (optionally compress already
  existing attachments)

### Reports API

* allow passthrough of incoming results to 3rd party applications
  (e.g. extract benchmark results and pass them along them to external
  graph rendering - aka. "level 2 receivers")
* more robust TAP::Archive support

### Query API

* easier attachment downloading
* QueryAPI now available in testplan template to allows generate
  testruns based on older results (think of "use last successful
  aka. known-good Xen changeset for another complicated test")

### Web GUI

* user authentication (via PAM)
* reworked filter framework
* better show current scheduling state
* configurable site customizations for non-OSRC instances

### CLI

* new frontend tool 'tapper'
* more subcommands for user/notification/testplan handling
* testplan development support

### misc

* better configurable control over grub entry writing
* utils to fake/test the automation layer (Tapper::Fake)

### Hacking on Tapper

* we now use Dist::Zilla to author Perl libs
* plugins:
  * Dist::Zilla::PluginBundle::AMD
  * PodWeaver::PluginBundle::AMD
  * Task::BeLike::AMD

