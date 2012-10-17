scenario_type: interdep
description:
- requested_hosts:
  - johnconnor
  preconditions:
  - arch: linux64
    image: suse/sles11_sp1_x86-64_baseimage.tar.gz
    mount: /
    partition: sda2
    precondition_type: image
  - precondition_type: copyfile
    name: /data/tapper/live/repository/testprograms/uname_tap/uname_tap.sh
    dest: /bin/
    protocol: local
  - precondition_type: copyfile
    name: /data/tapper/live/repository/packages/tapperutils/kernel/gen_initrd.sh
    dest: /bin/
    protocol: local
  - precondition_type: package
    filename: kernel/sles11/x86_64/linux-3.1.tgz
  - precondition_type: exec
    filename: /bin/gen_initrd.sh
    options:
      - 2.6.31-rc6
  - precondition_type: testprogram
    program: /opt/tapper/bin/tapper-testsuite-netperf-server
    timeout: 1000
- requested_hosts:
  - sarahconnor
  preconditions:
  - arch: linux64
    image: suse/sles11_sp1_x86-64_baseimage.tar.gz
    mount: /
    partition: sda2
    precondition_type: image
  - precondition_type: copyfile
    name: /data/tapper/live/repository/testprograms/uname_tap/uname_tap.sh
    dest: /bin/
    protocol: local
  - precondition_type: copyfile
    name: /data/tapper/live/repository/packages/tapperutils/kernel/gen_initrd.sh
    dest: /bin/
    protocol: local
  - precondition_type: package
    filename: kernel/sles11/x86_64/linux-3.1_64.tgz
  - precondition_type: exec
    filename: /bin/gen_initrd.sh
    options:
      - 2.6.31-rc6
  - precondition_type: testprogram
    program: /opt/tapper/bin/tapper-testsuite-netperf-client
    timeout: 1000
