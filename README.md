# docs

Features of this setup:
- minimal dependencies on the laptop/workstation where the provisioner is being ran from
- multi-OS setup, with support for centos, fedora, debian, ubuntu. The OS is toggle-able by passing `OSTYPE=<os_type> make <some_target>` before make.
- the provisioner makes sure that python2 is installed on box creation (dependency for ansible). This is because some vagrant boxes are being built without python2 installed
- type `make` to get a helpful list of make targets
- the `ngxapp` application stub container and the `inspec` infra testing tool containers are being pulled from the https://quay.io/ docker registry. Make sure your firewall allows HTTPS connections to quay.io
- when iterating and building versions of the `ngxapp` application new versions can be injected into the pipeline by prepending the make target with the newly wanted version `CONT_VER=v0.12.3 make cont_app` without modifying the automation source code. This will build a docker container and tag it with version `v0.12.3`
- containerized infrastructure tests with using the chef.io `inspec` test harness - https://www.inspec.io/
- containerized infrastructure tests running from within the provisioned VM without any ruby required dependencies being installed either on the running hosts ( host where ansible is running ) or the tested host ( vmhost virtualbox VM )

Developed and tested with:
```
ansible 2.3.1.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = Default w/o overrides
  python version = 2.7.13 (default, Feb 11 2017, 12:22:40) [GCC 6.3.1 20170109]

GNU Make 4.2.1

Vagrant 1.9.5

virtualbox 5.1.22-2

converged and tested vagrant environments/OS:
  - fedora 25
  - centos 7
  - debian 8
```


## Getting started guide

### Environment
- **Dependencies:** make sure you have installed on the laptop/workstation where you're running this repo the following dependencies: `ansible`, `make`, `vagrant`, `virtualbox` (virtualbox is the most widely spread and virtualisation platform and the platform that has been battle-tested with vagrant)
- download the external ansible galaxy dependencies with `make dep`
- start the vagrant environment with `make envup`. See additional make targets (`make help`) for environment manipulation.
- converge the vagrant environment apply configuration with `make converge`. This runs ansible against the vagrant environment.
- use `curl` or your browser to check the webpage of the stub application at http://192.168.100.20:18080/

### Application
- use `make cont_app` to iterate and create new versions of the `ngxapp` application locally on your workstation/laptop.
- pushing to quay.io is secured and disabled for anonymous users. Anonymous image pulling is enabled, this means anyone can pull new versions of the `ngxapp` container but only the allowed people or CI systems can push new changes.

### Infrastructure testing
- run `make testinfra` to test the vagrant environment with the `inspec` tests.
