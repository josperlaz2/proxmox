pipeline {
    agent any
    environment {
        PVE_URL = 'https://192.168.0.176:8006/api2/json' // Asegúrate de que esta sea la URL correcta de tu Proxmox
        TF_VAR_api_id = credentials('PROXMOX_API_TOKEN_ID') // ID de la credencial de Jenkins para el Token ID de Proxmox
        TF_VAR_token_secret = credentials('PROXMOX_API_TOKEN_SECRET') // ID de la credencial de Jenkins para el Token Secret de Proxmox

        // Variables directas de Jenkins
        PROXMOX_HOST_JENKINS = "192.168.0.176" // ¡Ajusta esta IP a la de tu Proxmox! La del main.tf era 192.168.10.10
        PROXMOX_USER_JENKINS = "root@pam"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'githubSSH', // ID de la credencial de Jenkins para la clave SSH de GitHub
                    url: 'git@github.com:josperlaz2/proxmox.git' // URL de tu repositorio de GitHub
            }
        }
        stage('Init Terraform') {
            steps {
                dir('terraform') { // Asegúrate de que tus archivos .tf estén en una carpeta llamada 'terraform'
                    script {
                        // Exportar las variables de entorno ANTES de ejecutar tofu
                        sh """
                        export PM_TLS_INSECURE=true
                        export PM_HOST=${PROXMOX_HOST_JENKINS}
                        export PM_API_TOKEN_ID=${TF_VAR_api_id}
                        export PM_API_TOKEN_SECRET=${TF_VAR_token_secret}
                        export PM_USER=${PROXMOX_USER_JENKINS}

                        tofu init
                        """
                    }
                }
            }
        }
        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    script {
                        // Exportar las variables de entorno ANTES de ejecutar tofu
                        sh """
                        export PM_TLS_INSECURE=true
                        export PM_HOST=${PROXMOX_HOST_JENKINS}
                        export PM_API_TOKEN_ID=${TF_VAR_api_id}
                        export PM_API_TOKEN_SECRET=${TF_VAR_token_secret}
                        export PM_USER=${PROXMOX_USER_JENKINS}

                        tofu plan
                        """
                    }
                }
            }
        }
        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    script {
                        // Exportar las variables de entorno ANTES de ejecutar tofu
                        sh """
                        export PM_TLS_INSECURE=true
                        export PM_HOST=${PROXMOX_HOST_JENKINS}
                        export PM_API_TOKEN_ID=${TF_VAR_api_id}
                        export PM_API_TOKEN_SECRET=${TF_VAR_token_secret}
                        export PM_USER=${PROXMOX_USER_JENKINS}

                        tofu apply --auto-approve
                        """
                    }
                }
            }
        }
    }
    // --- INICIO DE LA CORRECCIÓN ---
    post { // Este bloque es opcional, pero útil para notificaciones
        always {
            cleanWs() // Limpia el workspace de Jenkins después de la ejecución
        }
        failure {
            echo "Pipeline falló. Revisa los logs para depurar."
        }
        success {
            echo "Pipeline completado con éxito. Recursos desplegados."
        }
    }
} // Esta es la llave de cierre final del bloque 'pipeline'
// --- FIN DE LA CORRECCIÓN ---
