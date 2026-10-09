# Дипломный проект: Автоматизация развертывания и CI/CD в Yandex Cloud

## 1. Краткое описание
Данный проект демонстрирует полный цикл DevOps-инженера: от написания конфигурации инфраструктуры через **Terraform** до настройки конвейера автоматизации **CI/CD** и мониторинга приложения в **Kubernetes**.

**Стек технологий:**
*   **Cloud:** Yandex Cloud (VPC, Managed Kubernetes, Container Registry, Object Storage).
*   **IaC:** Terraform.
*   **CI/CD:** GitHub Actions (альтернатива Atlantis/Terraform Cloud).
*   **Containerization:** Docker.
*   **Orchestration:** Kubernetes (Manifests, Helm).
*   **Monitoring:** Prometheus, Grafana.

---

## 2. Инфраструктура (Terraform)

### Как запустить (С нуля)
Инфраструктура разделена на два этапа для обеспечения безопасного хранения состояния (State).

1.  **Создание бэкенда (S3 Bucket):**
    ```bash
    cd infra_bootstrap
    terraform init
    terraform apply -auto-approve
    ```
2.  **Создание облачной инфраструктуры:**
    ```bash
    cd ../main_infrastructure
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```

### Результат
*   Сетевая инфраструктура (VPC, подсети в 3 зонах).
*   Managed Kubernetes кластер (региональный мастер).
*   Container Registry (YCR).
*   State-файл хранится в Yandex Object Storage.

---

## 3. CI/CD и Автоматизация

В соответствии с ТЗ, так как не использовался Terraform Cloud, настройка автоматизации выполнена с помощью **GitHub Actions** (CI/CD system).

### Настройка
В настройках GitHub Secrets (`Settings` -> `Secrets`) прописаны креды сервисного аккаунта для доступа к Yandex Cloud.

### Конвейер (.github/workflows/ci-cd.yml)
Пайплайн выполняет следующие действия при коммите в ветку `main`:
1.  **Build:** Сборка Docker-образа тестового приложения.
2.  **Push:** Публикация образа в Yandex Container Registry.
3.  **Deploy:** Обновление Deployment в Kubernetes с новым тегом образа (через подмену `sed` в манифестах).


---

## 4. Тестовое приложение и Docker

### Приложение
*   **Стек:** Nginx (статический сайт).
*   **Контейнеризация:** Файл `Dockerfile` в папке `test-app/`.
*   **Реестр образов:** [Ссылка на ваш Yandex Container Registry]

### Деплой
Деплой осуществляется через манифесты Kubernetes в `test-app/k8s-manifests/`.
Тип сервиса `Service`: `LoadBalancer` (для доступа из внешнего интернета).

---

## 5. Мониторинг (Prometheus & Grafana)

Установка системы мониторинга выполнена в Kubernetes.
*   **Инструменты:** kube-prometheus-stack (Prometheus, Grafana, Alertmanager, Node Exporter).

### Доступ к Grafana
*   **Ссылка:** `http://<IP-GRAFANA>/`
*   **Логин:** `admin`
*   **Пароль:** `admin` (или пароль, указанный при установке).

> **Скриншоты дашбордов:**
> 1. График загрузки CPU кластера.
> 2. График работы приложения (Nginx requests).

---

## 6. Ссылки на доступы (Пункты ТЗ)

1.  **Тестовое приложение:**
    *   URL: `http://<IP-APP>/`
    *   Статус: Работает, обновляется через CI/CD.
2.  **Grafana:**
    *   URL: `http://<IP-GRAFANA>/`
    *   Логин/Пароль: `admin` / `prom-operator` .

---

## 7. Инструкция по воспроизведению (Reproduce Guide)

1.  Склонировать репозиторий: `git clone <URL>`
2.  Установить переменные окружения:
    ```bash
    export YC_CLOUD_ID=<ID>
    export YC_FOLDER_ID=<ID>
    export YC_SA_KEY=./sa_key.json
    ```
3.  Запустить `terraform apply` в `infra_bootstrap`.
4.  Запустить `terraform apply` в `main_infrastructure`.
5.  Выполнить установку мониторинга:
    ```bash
    bash main_infrastructure/scripts/deploy_monitoring.sh
    ```
6.  Запустить сборку приложения (или сделать push в main для авто-триггера CI).

---