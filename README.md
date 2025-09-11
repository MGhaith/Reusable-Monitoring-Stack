# Reusable Monitoring Stack

## Overview

This repository contains a reusable monitoring stack featuring Prometheus, Grafana, and Alertmanager. It's designed to be deployed locally or in the cloud.

---

## Deployment

### Local Deployment (Docker Environment)

#### 🖼️ Architecture Diagram

<img width="1283" height="780" alt="ReusableMonitoringStack" src="https://github.com/user-attachments/assets/6eb18ea1-4496-4810-8d75-e84410a2d4eb" />

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

### Cloud Deployment (AWS)

#### 🖼️ Architecture Diagram

[Architecture diagram to be added]

#### Prerequisites

1. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
2. [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+) installed
3. AWS account with appropriate permissions

#### Infrastructure Components

- **VPC**: Isolated network with public and private subnets
- **ECS Cluster**: For running containerized services
- **Application Load Balancer**: For routing traffic to services
- **EFS**: For persistent storage of monitoring data
- **IAM Roles**: For proper service permissions

#### Setup Steps

1. Configure AWS credentials:
   ```bash
   aws configure
   ```

2. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan -out=tfplan
   ```

4. Apply the configuration:
   ```bash
   terraform apply tfplan
   ```

5. After successful deployment, Terraform will output the ALB DNS name.

#### Access

* Prometheus: http://[ALB-DNS-NAME]/prometheus
* Alertmanager: http://[ALB-DNS-NAME]/alertmanager
* Grafana: http://[ALB-DNS-NAME]/grafana (Username: ```admin```, Password: ```admin```)

#### Cleanup

To destroy all created resources:

```bash
terraform destroy
```

**Note**: This will remove all resources including persistent data stored in EFS.

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

## Troubleshooting

### Common Issues

#### Local Deployment

- **Port Conflicts**: If services fail to start, check if ports 9090, 9093, or 3000 are already in use.
- **Container Startup Failures**: Check logs with `docker-compose logs [service_name]`.
- **Permission Issues**: Ensure proper permissions on mounted volumes.

#### Cloud Deployment

- **Health Check Failures**: Verify ALB target group settings and container health check endpoints.
- **ECS Task Failures**: Check CloudWatch Logs for container startup issues.
- **Networking Issues**: Verify security group rules allow necessary traffic.

## 🎯 Stretch Goals

- **Integrate with GitHub Actions**: Monitor CI/CD pipelines and visualize metrics.
- **Add Loki for Log Aggregation**: Enhance observability by aggregating logs.
- **Add Terraform for Infrastructure as Code**: Use Terraform to provision and manage AWS resources.

## License
MIT

---

*Feel free to clone this repository and customize it as needed. If you have any questions or need further assistance, don't hesitate to ask!*
