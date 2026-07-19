pipeline {

    agent any

    parameters {

    string(
        name: 'CLIENT_NAME',
        defaultValue: 'demo',
        description: 'Enter client name'
    )

    choice(
        name: 'ENVIRONMENT',
        choices: ['dev', 'qa', 'prod'],
        description: 'Select environment'
    )

    string(
        name: 'INSTANCE_COUNT',
        defaultValue: '2',
        description: 'Number of EC2 instances'
    )

    choice(
        name: 'INSTANCE_TYPE',
        choices: ['t3.micro', 't3.small', 't3.medium'],
        description: 'EC2 Instance Type'
    )

}

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }
         stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Manual Approval') {
            steps {
                input message: 'Do you want to apply the Terraform changes?', ok: 'Apply'
             }
        }
        stage('Terraform Apply') {
            steps {
                sh """
                terraform apply -auto-approve\
                -var="client_name=${params.CLIENT_NAME}" \  
                -var="environment=${params.ENVIRONMENT}" \
                -var="instance_count=${params.INSTANCE_COUNT}" \
                -var="instance_type=${params.INSTANCE_TYPE}"
                """
            }
        }
    post {
        always {
             echo "Pipeline execution completed."
            }

          success {
             echo "Infrastructure deployed successfully."
            }

         failure {
            echo "Pipeline failed. Please check the console output."
            }

          }
    }

}
