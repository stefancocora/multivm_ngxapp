# docs

Features of this setup:
- multi-OS setup, with support for centos, fedora, debian, ubuntu. The OS is toggle-able by passing `OSTYPE=<os_type> make <some_target>` before make.


## Getting started guide
- make sure you have installed on the laptop/workstation where you're running this repo the following dependencies: `ansible`, `make`, `vagrant`, `virtualbox`
- download your external ansible galaxy dependencies with `make dep`
- start vagrant VM with `make envup`. See additional make targets (`make help`) for environment manipulation.
