# HAZELCAST CASE STUDY

## Kubernetes

- The kubernetes cluster created locally via Kubespray using Vagrant and VirtualBox.

```bash
(⎈ |kubernetes-admin@cluster.local:default)➜  ~ kubectl version
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.2", GitCommit:"5835544ca568b757a8ecae5c153f317e5736700e", GitTreeState:"clean", BuildDate:"2022-09-21T14:33:49Z", GoVersion:"go1.19.1", Compiler:"gc", Platform:"darwin/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.6", GitCommit:"b39bf148cd654599a52e867485c02c4f9d28b312", GitTreeState:"clean", BuildDate:"2022-09-21T13:12:04Z", GoVersion:"go1.18.6", Compiler:"gc", Platform:"linux/amd64"}
(⎈ |kubernetes-admin@cluster.local:default)➜  ~ kubectl get no -owide
NAME    STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
k8s-1   Ready    control-plane   4d23h   v1.24.6   10.0.20.101   <none>        Ubuntu 20.04.5 LTS   5.4.0-132-generic   containerd://1.6.8
k8s-2   Ready    control-plane   4d23h   v1.24.6   10.0.20.102   <none>        Ubuntu 20.04.5 LTS   5.4.0-132-generic   containerd://1.6.8
k8s-3   Ready    <none>          4d23h   v1.24.6   10.0.20.103   <none>        Ubuntu 20.04.5 LTS   5.4.0-132-generic   containerd://1.6.8
(⎈ |kubernetes-admin@cluster.local:default)➜  ~
```

## Vault

- On kubernetes node `k8s-2` `/data/vault` directory is created manually in order to use local storage for `PersistentVolume`.
- The manifests in `vault/manifests` are applied manually to create `PersistentVolume` and `StorageClass` resources. 
- Vault is deployed using helm chart with Terraform helm provider. The helm values related ingress and storageclass are set accordingly.
- A secret-engine with type kv-v2 is created from UI.

## External Secrets Operator

- External Secrets Operator is deployed using helm chart with Terraform helm provider. 

## Ingress Controller

- Ingress Controller is deployed using helm chart with Terraform helm provider. The service type is set to `NodePort` since there exist no external Load Balancer on local machine.

## Prometheus Operator

-  On kubernetes node `k8s-3` `/data/prometheus-operator` directory is created manually in order to use local storage for `PersistentVolume`.
- The manifests in `prometheus-operator/manifests` are applied manually to create `PersistentVolume` and `StorageClass` resources. 
- Prometheus, alertmanager, grafana and kube-state-metrics are deployed using prometheus-operator. Prometheus-operator is deployed using `kube-prometheus-stack` helm chart with Terraform helm provider.
- The ingresses are deployed using Terroform kubernetes provider with basic auhentication.
- `vault-token` secret is created manually in `monitoring` namespace.
- Using manifests in `external-secrets/manifests` SecretStore and ExternalSecrets are applied. The secrets created by ExternalSecrets named `aletmanager-auth` and `prometheus-auth`is used for basic authentication.
- The alert rule is created with Terraform kubernetes provider using `monitoring.coreos.com/v1`.
- The alertmanager config that configure recievers and routes is supplied via `values.yml`. `webhook_config` used to notify a sample endpoint with POST method.

## GitHub Actions workflow

- A workflow is created to manage terraform steps such as format, init, validate, plan and apply.

- A self-hosted runner is deployed and registered to run jobs locally.

- GCS bucket is used as Terraform backend to store state files.