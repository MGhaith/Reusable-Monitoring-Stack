# Reusable Monitoring Stack (WIP)

## Overview

This repository contains a reusable monitoring stack featuring Prometheus, Grafana, and Alertmanager. It's designed to be deployed locally or in the cloud.

---

## 🖼️ Architecture Diagram

<img width="1283" height="780" alt="ReusableMonitoringStack" src="https://github.com/user-attachments/assets/6eb18ea1-4496-4810-8d75-e84410a2d4eb" />

## Deployment

### Local Deployment (Docker Environment)

#### Prerequisites
1. Install [Docker Desktop](https://docs.docker.com/get-started/get-docker/)
2. Make sure Docker is running on your machine

#### Setup Steps
1. Copy the environment file:
   ```bash
   cp .env.example .env
   ```
2. Edit the `.env` file
3. To get alerts using Alert Manager: Edit `prometheus/alertmanager.yml` file to add your **Slack** and/or **Gmail** credentials.
4. Start the stack:
   ```bash
   docker-compose up -d
   ```

#### Alerts

Alerts are configured to notify via email/Slack when certain thresholds are met. The following alerts are currently configured in `prometheus/alerts.yml`:

- **High CPU Usage**: Triggers when CPU usage exceeds 80% for 5 minutes.
- **High Memory Usage**: Alerts when memory usage is above 85% for 5 minutes.
- **Instance Down**: Fires when a monitored instance is unreachable for 2 minutes.
- **Disk Space Running Low**: Alerts when disk usage reaches 90% capacity.

To view and manage these alerts, you can access them through the **Prometheus UI** or directly modify the `prometheus/alerts.yml` file.

#### Access
* Prometheus: http://localhost:9090
* Alertmanager: http://localhost:9093
* Grafana: http://localhost:3000 (Username: ```admin```, Password: ```"your Grafana password"```)

### Cloud Deployment (Coming Soon)

## CI/CD Workflow

This project uses GitHub Actions for continuous integration. The workflow includes:

1. **Validation**:
   - Validates Docker Compose configuration
   - Validates Prometheus configuration using promtool
   - Validates Alertmanager configuration using amtool

2. **Smoke Testing**:
   - Builds and starts the complete monitoring stack
   - Waits for services to initialize
   - Verifies container health status
   - Performs cleanup by tearing down the stack

The workflow runs automatically on:
- Push events to the main branch
- Pull request events targeting the main branch

This ensures that all configuration files are valid and the stack can be successfully deployed before changes are merged.

## 🎯 Stretch Goals

- **Integrate with GitHub Actions**: Monitor CI/CD pipelines and visualize metrics.
- **Add Loki for Log Aggregation**: Enhance observability by aggregating logs.
- **Add Terraform for Infrastructure as Code**: Use Terraform to provision and manage AWS resources.

## License
MIT

---

*Feel free to clone this repository and customize it as needed. If you have any questions or need further assistance, don't hesitate to ask!*
