resource "kubernetes_manifest" "prometheusrule_monitoring_custom_k8s_rules" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "labels" = {
        "app" = "prometheus-operator"
      }
      "name"      = "custom-k8s-rules"
      "namespace" = "monitoring"
    }
    "spec" = {
      "groups" = [
        {
          "name" = "custom-kubernetes-apps"
          "rules" = [
            {
              "alert" = "KubePodMemory"
              "annotations" = {
                "description" = "Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container}}) is using {{ printf \"%.2f percent\" $value }}."
                "summary"     = "Pod is using memory > %10."
              }
              "expr" = "100 * sum(container_memory_working_set_bytes) by (pod, container, namespace) / sum(kube_pod_container_resource_limits{resource=\"memory\"}) by (pod, container, namespace) > 10"
              "for"  = "5m"
              "labels" = {
                "severity" = "critical"
                "app"      = "prometheus-operator"
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [
    helm_release.prometheus-operator
  ]
}