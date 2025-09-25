# Simple dev helpers for local Kubernetes on Minikube
# Usage: `make <target>`
# Requires: Docker Desktop (WSL2), Minikube, kubectl

K8S_DIR := k8s
APP := hello-web
SVC := hello-web-svc

.PHONY: start stop status deploy url logs watch scale update rollback delete clean

start:
	@echo "Starting Minikube with Docker driver..."
	minikube start --driver=docker --cpus=2 --memory=4096

stop:
	minikube stop

status:
	minikube status
	kubectl get nodes

deploy:
	@echo "Applying Kubernetes manifests..."
	kubectl apply -f $(K8S_DIR)/deployment.yaml
	kubectl apply -f $(K8S_DIR)/service.yaml
	kubectl rollout status deploy/$(APP)

url:
	minikube service $(SVC) --url

logs:
	kubectl logs -f deploy/$(APP)

watch:
	kubectl get pods -w

scale:
	@echo "Example: make scale REPLICAS=3"
	@[ -n "$(REPLICAS)" ] || (echo "Set REPLICAS=<n>"; exit 1)
	kubectl scale deploy/$(APP) --replicas=$(REPLICAS)
	kubectl get pods -l app=$(APP) -o wide

# Example rolling update to nginx:alpine
update:
	kubectl set image deploy/$(APP) nginx=nginx:alpine
	kubectl rollout status deploy/$(APP)

rollback:
	kubectl rollout undo deploy/$(APP)

delete:
	- kubectl delete -f $(K8S_DIR)/service.yaml
	- kubectl delete -f $(K8S_DIR)/deployment.yaml

clean: stop
	@echo "Cluster stopped. To fully remove, run: minikube delete"
