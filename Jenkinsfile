// Jenkinsfile (en la raíz de tu repositorio)
pipeline {
    agent any

    environment {
        // Variables que Jenkins cargará como variables de entorno
        // Estas son las que Terraform buscará automáticamente (TF_VAR_*)

        // TF_VAR_api_url para el parámetro 'api_url' de tu main.tf
        TF_VAR_api_url = "https://192.168.0.176:8006/api2/json" // ¡AJUSTA A LA IP REAL DE TU PROXMOX!

        // TF_VAR_token_id para el parámetro 'token_id' de tu main.tf
        TF_VAR_token_id = credentials('PROXMOX_API_TOKEN_ID') // Nombre de la credencial de Jenkins

        // TF_VAR_token_secret para el parámetro 'token_secret' de tu main.tf
        TF_VAR_token_secret = credentials('PROXMOX_API_TOKEN_SECRET') // Nombre de la credencial de Jenkins

        // PM_USER es una variable de entorno que el proveedor de Proxmox puede usar
        // si no especificas un usuario en tu token. Si tu token es 'root@pam!tokenid',
        // 'root@pam' ya está implícito en el token.
        // Si tu token es solo 'tokenid' y necesita 'root@pam' como usuario, mantén esta.
        PM_USER = "root@pam" // Usuario de Proxmox (ej. root@pam, usuario@pve)
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Este primer checkout es el que Jenkins hace al inicio del job
                // para obtener el Jenkinsfile. Generalmente no necesita ser re-declarado.
                // Sin embargo, si lo mantienes, asegúrate de que el credentialsId sea correcto.
                git branch: 'main',
                    credentialsId: 'githubSSH', // El ID de tu credencial SSH de GitHub en Jenkins
                    url: 'git@github.com:josperlaz2/proxmox.git'
            }
        }

        stage('Init Terraform') {
            steps {
                dir('terraform') { // Cambia al directorio donde están tus archivos .tf
                    script {
                        sh """
                        # Exporta variables de entorno específicas del proveedor de Proxmox
                        # PM_TLS_INSECURE es para evitar errores de certificado autofirmado en desarrollo.
                        export PM_TLS_INSECURE=true
                        # export PM_USER=${PM_USER} # Se puede omitir si el token ID ya incluye el usuario (ej. root@pam!tokenid)

                        # Ejecuta la inicialización de Terraform.
                        # Terraform buscará automáticamente TF_VAR_api_url, TF_VAR_token_id, TF_VAR_token_secret
                        # que Jenkins ya exportó del bloque 'environment'.
                        terraform init
                        """
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    script {
                        sh """
                        export PM_TLS_INSECURE=true
                        # export PM_USER=${PM_USER}

                        terraform plan
                        """
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    script {
                        sh """
                        export PM_TLS_INSECURE=true
                        # export PM_USER=${PM_USER}

                        terraform apply --auto-approve
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Limpia el workspace del agente de Jenkins
        }
        failure {
            echo "Pipeline falló. Revisa los logs para depurar."
        }
        success {
            echo "Pipeline completado con éxito. Recursos desplegados."
        }
    }
}
