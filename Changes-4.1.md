* Lacey: Looks like a young Omar Sharif.
  Cagney: He's got crooked teeth.
  Lacey: You know, Christine, you're very critical. That's your trouble with men. You want them all to be perfect.
  Cagney: No, I just have a thing about teeth.

  Cagney & Lacey, "Let Them Eat Pretzels" (1983)

## Tapper release 4.1 codename "Cagney & Lacey" 2012-10-23

### Databases

* refactoring to also work with PostgreSQL

### Automation

* scheduler 10x speedup
* host blacklisting per queue
* beginning Cobbler support

### Tools

* CLI command harmonization

### Documentation

* migrated to POD for maintainability
* complex precondition and testplan examples

### Misc

* overall cleanup to sync with upstream technologies
  * autotest 0.14.x
  * Perl 5.16
  * Catalyst 5.9
    * throw away BindLex, NEXT
    * use other Mason view
