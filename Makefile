.PHONY: clean
clean:
	rm -f _output/*

.PHONY: build
build:
	gcc uninterruptible.c -o _output/uninterruptible
	cp uninterruptible.sh _output/uninterruptible.sh
	chmod +x _output/uninterruptible.sh

.PHONY: build-container
build-container:
	podman build -t quay.io/akaris/fedora:uninterruptible .

.PHONY: push-container
push-container:
	podman push quay.io/akaris/fedora:uninterruptible

.PHONY: deploy-pod
deploy-pod:
	oc apply -f fedora.yaml

.PHONY: undeploy-pod
undeploy-pod:
	oc delete -f fedora.yaml
