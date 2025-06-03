pipeline {
    agent any
    environment {
        PVE_URL = 'https://192.168.5.38:8006/api2/json' // Asegúrate de que esta sea la URL correcta de tu Proxmox
        TF_VAR_api_id = credentials('proxmox-token-id') // ID de la credencial de Jenkins para el Token ID de Proxmox
        TF_VAR_token_secret = credentials('proxmox-token-secret') // ID de la credencial de Jenkins para el Token Secret de Proxmox
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-ssh-key', // ID de la credencial de Jenkins para la clave SSH de GitHub
                    url: 'git@github.com:PPS11148274/proxmox-terraform-jenkins.git' // URL de tu repositorio de GitHub
            }
        }
        stage('Init Terraform') {
            steps {
                dir('terraform') { // Asegúrate de que tus archivos .tf estén en una carpeta llamada 'terraform'
                    sh 'terraform init'
                }
            }
        }
        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }
        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
