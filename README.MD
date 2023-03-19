# Deploying Istio with ArgoCD

Parking until dependency management is resolved in argo: https://github.com/argoproj/argo-cd/issues/7437

This is a small repo is demo deploying Istio with ArgoCD.  Using sync waves to coordinate.

## Requirements
* just
* kind
* kubectl
* argocd

## Build
In the root just run `just cluster` & a cluster with locally cached images will be built.