# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /bin/bash
# We don't need make's built-in rules.
MAKEFLAGS += --no-builtin-rules

# constants
VAGRANT_CMD=$(shell vagrant --version)
ANSIBLE_CMD=$(shell ansible --version)
OSTYPE ?= fedora
PROVIDER = virtualbox
COMMUNITY_ROLES_PATH = ansible/roles/community
CONT_NAME='quay.io/stefancocora/ngxapp'
CONT_VER='v0.0.1'


# Metadata for driving the build lives here.
META_DIR := .make

# define a catchall target
# default: build
default: help

.PHONY: help
help:
	@echo "---> Help menu:"
	@echo "supported make targets:"
	@echo ""
	@echo "Environment targets:"
	@echo "  make envup			# brings all VMs up without running any config management on them"
	@echo "  make envdel			# destroys all VMs"
	@echo "  make envhup			# destroys and re-creates all VMs"
	@echo ""
	@echo "Config management options:"
	@echo "  make converge                 # environment converges by running all the configured roles"
	@echo "  make dep			# installs ansible galaxy dependencies"
	@echo "  make cont_app			# builds the application container"
	@echo "  make envtests			# environment integration tests"
	@echo ""

.PHONY: check_prerequisite_env
check_prerequisite_env:
ifeq ($(VAGRANT_CMD),)
        $(error please install vagrant - https://vagrantup.com/)
endif

.PHONY: check_prerequisite_provisioner
check_prerequisite_provisioner:
ifeq ($(ANSIBLE_CMD),)
        $(error please install ansible - https://docs.ansible.com/)
endif

.PHONY: envup
envup: check_prerequisite_env
	OSTYPE=$(OSTYPE) vagrant up --provider=$(PROVIDER) --provision-with shell

.PHONY: envdel
envdel: check_prerequisite_env
	vagrant destroy -f

.PHONY: envhup
envhup: check_prerequisite_env
	vagrant destroy -f && OSTYPE=$(OSTYPE) vagrant up --provider=$(PROVIDER) --provision-with shell

.PHONY: dep
dep: check_prerequisite_provisioner
	ansible-galaxy --roles-path $(COMMUNITY_ROLES_PATH) install geerlingguy.docker

.PHONY: converge
converge: check_prerequisite_env
	vagrant provision --provision-with ansible

.PHONY: cont_app
cont_app:
	@echo "--> Building container image ..."
	timeout --preserve-status 120s     docker build --no-cache --force-rm -t $(CONT_NAME):$(CONT_VER) app/
