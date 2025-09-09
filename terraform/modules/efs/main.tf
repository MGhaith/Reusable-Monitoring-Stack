############################################################
# EFS MODULE
############################################################

# Create the EFS filesystem
resource "aws_efs_file_system" "this" {
  creation_token = "${var.name}-efs"
  performance_mode = "generalPurpose"
  encrypted = true
  lifecycle_policy {
    # Automatically transition files to IA (infrequent access) after 30 days
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.name}-efs"
  }
}

# Create EFS mount targets for each private subnet
resource "aws_efs_mount_target" "this" {
  for_each = var.subnets

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = var.security_groups
}

# Access Point for Prometheus
resource "aws_efs_access_point" "prometheus" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1001
    gid = 1001
  }

  root_directory {
    path = "/prometheus"
    creation_info {
      owner_uid   = 1001
      owner_gid   = 1001
      permissions =  "0755"
    }
  }
}

# Access Point for Grafana
resource "aws_efs_access_point" "grafana" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1002
    gid = 1002
  }

  root_directory {
    path = "/grafana"
    creation_info {
      owner_uid   = 1002
      owner_gid   = 1002
      permissions =  "0755"
    }
  }
}

# Access Point for Alertmanager
resource "aws_efs_access_point" "alertmanager" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1003
    gid = 1003
  }

  root_directory {
    path = "/alertmanager"
    creation_info {
      owner_uid   = 1003
      owner_gid   = 1003
      permissions = "0755"
    }
  }
}
