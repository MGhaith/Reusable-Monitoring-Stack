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

# Single Access Point for all monitoring services
resource "aws_efs_access_point" "monitoring" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/monitoring"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0755"
    }
  }
}