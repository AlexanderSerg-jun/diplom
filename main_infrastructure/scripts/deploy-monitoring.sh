#!/bin/bash
set -e

# Проверяем, что мы подключены к кластеру
kubectl cluster-info || exit 1

echo "Установка системы мониторинга..."

# 1. Добавляем репозиторий
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2. Создаем Namespace
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# 3. Устанавливаем kube-prometheus-stack
# Используем минимальные ресурсы для экономии
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.resources.requests.cpu=100m \
  --set prometheus.prometheusSpec.resources.requests.memory=500Mi \
  --set grafana.adminPassword=admin123 \
  --set kubeEtcd.enabled=false \
  --set kubeScheduler.enabled=false \
  --wait --timeout 10m

# 4. Пробрасываем порты для теста (если нужно проверить сразу)
# kubectl port-forward svc/prometheus-grafana -n monitoring 8080:80 &
# sleep 5
# echo "Grafana доступна на http://localhost:8080 (admin/admin123)"