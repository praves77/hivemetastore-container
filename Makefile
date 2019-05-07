all: hivemetastore
hivemetastore: build push clean
.PHONY: build push clean

IMAGE_NAME = hivemetastore
HIVE_VERSION= 3.1.1
IMAGE_TAG = hive-$(HIVE_VERSION)

REGISTRY = docker.io
REPO = praves77

DOCKER = docker

build:
	$(DOCKER) build -t $(REGISTRY)/$(REPO)/$(IMAGE_NAME) .
	$(DOCKER) tag $(REGISTRY)/$(REPO)/$(IMAGE_NAME) $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

push:
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME)
	$(DOCKER) push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	$(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(IMAGE_TAG) || :
	$(DOCKER) rmi $(REGISTRY)/$(REPO)/$(IMAGE_NAME) || :
