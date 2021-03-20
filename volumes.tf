resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
    labels = {
      role = "efs-pv"
    }
  }
  storage_provisioner = "efs.csi.aws.com"
}

resource "kubernetes_persistent_volume" "media_efs_pv" {
  metadata {
    name = "media-efs" 
    labels = {
      role = "efs-pv"
    }
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "efs-sc"
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle =  var.media_efs_id
      }
    }
  }
}

resource "kubernetes_persistent_volume" "static_efs_pv" {
  metadata {
    name = "static-efs" 
    labels = {
      role = "efs-pv"
    }
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "efs-sc"
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle =  var.static_efs_id
      }
    }
  }
}