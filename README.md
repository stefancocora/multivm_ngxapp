# docs

Features of this setup:
- multi-OS setup, with support for centos, fedora, debian, ubuntu. The OS is toggle-able by passing `OSTYPE=<os_type> make <some_target>` before make.
- the provisioner makes sure that python2 is installed on box creation (dependency for ansible). This is because some vagrant boxes are being built without python2 installed
- type `make` to get a helpful list of make targets
- the `ngxapp` application stub container is being pulled from the quay.io docker registry. Make sure your firewall allows HTTPS connections to quay.io


## Getting started guide
- make sure you have installed on the laptop/workstation where you're running this repo the following dependencies: `ansible`, `make`, `vagrant`, `virtualbox`
- download your external ansible galaxy dependencies with `make dep`
- start vagrant VM with `make envup`. See additional make targets (`make help`) for environment manipulation.
- converge the VM configuration with `make converge` to install the docker runtime and the `ngxapp` stub application
- use `curl` or your browser to check the webpage of the stub application at `http://192.168.100.20:18080/`
