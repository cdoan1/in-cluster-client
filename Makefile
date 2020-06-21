DOCKER_NAMESPACE?=cdoan0
IMAGE_NAME?=in-cluster
TAG?=latest
DOCKER_REGISTRY?=quay.io

NAMESPACE:=in-cluster
KUBECTL?=oc

# service-name:
#   SERVICE?=$(shell $(KUBECTL) get route -n $(NAMESPACE) -o jsonpath="{@.items[0].spec.host}")

build:
	GOOS=linux go build -o ./app .
	@docker build -t ${DOCKER_NAMESPACE}/${IMAGE_NAME}:${TAG} .

push:
	@if [ -z ${DOCKER_USERNAME} ] || [ -z ${DOCKER_TOKEN} ]; then echo "repo credentials required ..."; exit 1; fi
	@docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_TOKEN}" ${DOCKER_REGISTRY}
	@docker tag ${DOCKER_NAMESPACE}/${IMAGE_NAME}:${TAG} ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/${IMAGE_NAME}:${TAG}
	@docker push ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/${IMAGE_NAME}:${TAG}

deploy:
	kubectl run --rm -i in-cluster -n in-cluster --image=quay.io/cdoan0/in-cluster

rollout:
	@oc rollout restart deployment/$(NAMESPACE)
	@oc get pods -o yaml -n $(NAMESPACE) | grep 'imageID'