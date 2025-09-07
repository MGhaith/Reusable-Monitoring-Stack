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

## 🎯 Stretch Goals

- **Integrate with GitHub Actions**: Monitor CI/CD pipelines and visualize metrics.
- **Add Loki for Log Aggregation**: Enhance observability by aggregating logs.
- **Implement Auto-Scaling**: Use AWS Auto Scaling to adjust resources based on load.

## License
MIT

---

*Feel free to clone this repository and customize it as needed. If you have any questions or need further assistance, don't hesitate to ask!*
