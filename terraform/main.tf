terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.20.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6"
    }
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "aks_rg" {
  name = "aksResourceGroup"
}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aksCluster"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  username               = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
  password               = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_deployment" "cliente" {
  metadata {
    name = "cliente"
    labels = {
      app = "cliente"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "cliente"
      }
    }
    template {
      metadata {
        labels = {
          app = "cliente"
        }
      }
      spec {
        container {
          image = "7brandon/cliente"
          name  = "cliente"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "productos" {
  metadata {
    name = "productos"
    labels = {
      app = "productos"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "productos"
      }
    }
    template {
      metadata {
        labels = {
          app = "productos"
        }
      }
      spec {
        container {
          image = "7brandon/productos"
          name  = "productos"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          image = "7brandon/frontend"
          name  = "frontend"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
  }
  spec {
    selector = {
      app = "frontend"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_service" "cliente" {
  metadata {
    name = "cliente"
  }
  spec {
    selector = {
      app = "cliente"
    }
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_service" "productos" {
  metadata {
    name = "productos"
  }
  spec {
    selector = {
      app = "productos"
    }
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 3000
    }
  }
}