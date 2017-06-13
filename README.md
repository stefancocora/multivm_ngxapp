# docs

Features of this setup:
- multi-OS setup, with support for centos, fedora, debian, ubuntu. The OS is toggle-able by passing `OSTYPE=<os_type> make <some_target>` before make.
- the provisioner makes sure that python2 is installed on box creation (dependency for ansible). This is because some vagrant boxes are being built without python2 installed
- type `make` to get a helpful list of make targets
- the `ngxapp` application stub container is being pulled from the quay.io docker registry. Make sure your firewall allows HTTPS connections to quay.io
- when iterating and building versions of the `ngxapp` application new versions can be injected into the pipeline by prepending the make target with the newly wanted version `CONT_VER=v0.12.3 make cont_app`. This will build a docker container and tag it with version `v0.12.3`


## Getting started guide

### Environment
- make sure you have installed on the laptop/workstation where you're running this repo the following dependencies: `ansible`, `make`, `vagrant`, `virtualbox`
- download your external ansible galaxy dependencies with `make dep`
- start vagrant VM with `make envup`. See additional make targets (`make help`) for environment manipulation.
- converge the VM configuration with `make converge` to install the docker runtime and the `ngxapp` stub application
- use `curl` or your browser to check the webpage of the stub application at `http://192.168.100.20:18080/`

### Application
- use `make cont_app` to iterate and create new versions of the `ngxapp` application locally on your workstation/laptop.
- pushing to quay.io is secured and disabled for anonymous users. Anonymous image pulling is enabled, this means anyone can pull new versions of the `ngxapp` container but only the allowed people or CI systems can push new changes.
