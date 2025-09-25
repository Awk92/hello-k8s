Small learning project to get comfortable with Kubernetes on my own machine.  
Runs on Windows 11 using WSL2 (Ubuntu) + Docker Desktop + Minikube. The app is a plain Nginx served via a Deployment 
and exposed with a Service. I added health probes and resource requests/limits to keep it close to real-world setups.

## Why this exists
I wanted a concrete, reproducible setup that proves I can:
- bring up a local cluster (Minikube),
- deploy workloads cleanly (labels, selectors, probes, resources),
- expose them via a Service and verify the result.

## Stack
- OS: Windows 11 + WSL2 (Ubuntu 24.04)
- Runtime: Docker Desktop (WSL2 engine)
- Local cluster: Minikube (Docker driver)
- Kubernetes: v1.34.x
- App: Nginx “hello” page

## Run locally
```bash
make start        # one-time cluster startup
make deploy       # apply manifests
make url          # prints the URL to open in a browser

## Debug commands I used
kubectl get pods -w
kubectl describe pod <name>
kubectl logs -f deploy/hello-web
minikube logs
