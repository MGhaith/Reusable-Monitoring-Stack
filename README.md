# Reusable Monitoring Stack

## Overview

This repository contains a reusable monitoring stack featuring Prometheus, Grafana, and Alertmanager. It's designed to be deployed locally or in the cloud with a single command.

---

## 🖼️ Architecture Diagram

![Architecture Diagram](architecture-diagram.png)

---


## Deployment

### Local Deployment

```bash
docker-compose up -d
```

### Cloud Deployment

```bash
terraform init
terraform apply
```

## Access
Prometheus: http://localhost:9090

Grafana: http://localhost:3000 (Username: ```admin```, Password: ```admin```)

## Alerts

Alerts are configured to notify via email/Slack when certain thresholds are met.

## License

MIT

## 🎯 Stretch Goals

- **Integrate with GitHub Actions**: Monitor CI/CD pipelines and visualize metrics.
- **Add Loki for Log Aggregation**: Enhance observability by aggregating logs.
- **Implement Auto-Scaling**: Use AWS Auto Scaling to adjust resources based on load.

---

*Feel free to clone this repository and customize it as needed. If you have any questions or need further assistance, don't hesitate to ask!*