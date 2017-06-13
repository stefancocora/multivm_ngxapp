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
CONT_VER ?= 'v0.0.1'
CONT_INSPEC_NAME=quay.io/stefancocora/inspec
CONT_INSPEC_VER ?= v1.27.0-2


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
	@echo "  make testinfra			# environment integration tests"
	@echo ""
	@echo "Application options:"
	@echo "  make cont_app			# builds the application container"
	@echo "  make cont_inter		# test container locally, interactively"
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
	CONT_NAME=$(CONT_NAME) CONT_VER=$(CONT_VER) CONT_INSPEC_NAME=$(CONT_INSPEC_NAME) CONT_INSPEC_VER=$(CONT_INSPEC_VER) vagrant provision --provision-with ansible

.PHONY: cont_app
cont_app:
	@echo "--> Building container image ..."
	timeout --preserve-status 120s docker build --no-cache --force-rm -t $(CONT_NAME):$(CONT_VER) app/

.PHONY: cont_inter
cont_inter:
	@echo "---> Running interactively ..."
	docker run --rm -p 18080:80 --name ngxapp -v ${PWD}/app/nginx.conf:/etc/nginx/conf/simplenginx.conf -e NGINX_CONFIG_FILE=/etc/nginx/conf/simplenginx.conf $(CONT_NAME):$(CONT_VER)

.PHONY: testinfra
testinfra:
	@echo "---> Running infra tests ..."
	ansible all -m shell --become-user root -a "docker run --rm --privileged --name inspec --net=host --ipc=host -v/tmp/inspec:/home/inspec -v /var/run/docker.sock:/var/run/docker.sock -e CONT_NAME=$(CONT_NAME) -e CONT_VER=$(CONT_VER) -e CONT_RUN_NAME=ngxapp $(CONT_INSPEC_NAME):$(CONT_INSPEC_VER)"
