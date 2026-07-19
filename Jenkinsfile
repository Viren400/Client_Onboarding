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

        choice(
            name: 'AWS_REGION',
            choices: ['us-east-1', 'us-east-2'],
            description: 'Select AWS Region'
        )

        string(
            name: 'INSTANCE_COUNT',
            defaultValue: '2',
            description: 'Number of EC2 instances'
        )

        choice(
            name: 'INSTANCE_TYPE',
            choices: ['t3.micro', 't3.small', 't3.medium'],
            description: 'Select EC2 Instance Type'
        )

        booleanParam(
            name: 'CREATE_ALB',
            defaultValue: true,
            description: 'Create Application Load Balancer'
        )

        booleanParam(
            name: 'CREATE_RDS',
            defaultValue: true,
            description: 'Create RDS Database'
        )

        booleanParam(
            name: 'CREATE_EFS',
            defaultValue: false,
            description: 'Create EFS File System'
        )

        booleanParam(
            name: 'MULTI_AZ',
            defaultValue: false,
            description: 'Enable Multi-AZ RDS'
        )

        string(
            name: 'BACKUP_RETENTION',
            defaultValue: '7',
            description: 'RDS Backup Retention Days'
        )
        string(
            name: 'CLIENT_INDEX',
            defaultValue: '5',
            description: 'Unique Client Number'
        )

        string(
            name: 'KEY_NAME',
            defaultValue: 'viren-key',
            description: 'EC2 Key Pair Name'
        )

        string(
            name: 'DB_USERNAME',
            defaultValue: 'admin',
            description: 'Database Username'
        )

        password(
            name: 'DB_PASSWORD',
            defaultValue: 'Admin12345',
            description: 'Database Password'
        )

        choice(
            name: 'DB_INSTANCE_CLASS',
            choices: ['db.t3.micro', 'db.t3.small'],
            description: 'RDS Instance Class'
        )

        string(
            name: 'DB_ALLOCATED_STORAGE',
            defaultValue: '20',
            description: 'Allocated Storage (GB)'
        )

        choice(
            name: 'DB_ENGINE',
            choices: ['mysql', 'postgres'],
            description: 'Database Engine'
        )

        choice(
            name: 'DB_ENGINE_VERSION',
            choices: ['8.0', '8.4'],
            description: 'Database Engine Version'
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
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]
                ]) {

                    sh """
                    terraform plan \
                    -var="client_name=${params.CLIENT_NAME}" \
                    -var="environment=${params.ENVIRONMENT}" \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="instance_count=${params.INSTANCE_COUNT}" \
                    -var="instance_type=${params.INSTANCE_TYPE}" \
                    -var="create_alb=${params.CREATE_ALB}" \
                    -var="create_rds=${params.CREATE_RDS}" \
                    -var="create_efs=${params.CREATE_EFS}" \
                    -var="multi_az=${params.MULTI_AZ}" \
                    -var="backup_retention_period=${params.BACKUP_RETENTION}"
                    -var="client_index=${params.CLIENT_INDEX}" \
                    -var="key_name=${params.KEY_NAME}" \
                    -var="db_username=${params.DB_USERNAME}" \
                    -var="db_password=${params.DB_PASSWORD}" \
                    -var="db_instance_class=${params.DB_INSTANCE_CLASS}" \
                    -var="db_allocated_storage=${params.DB_ALLOCATED_STORAGE}" \
                    -var="db_engine=${params.DB_ENGINE}" \
                    -var="db_engine_version=${params.DB_ENGINE_VERSION}" \
                    """
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Do you want to apply the Terraform changes?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]
                ]) {

                    sh """
                    terraform apply -auto-approve \
                    -var="client_name=${params.CLIENT_NAME}" \
                    -var="environment=${params.ENVIRONMENT}" \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="instance_count=${params.INSTANCE_COUNT}" \
                    -var="instance_type=${params.INSTANCE_TYPE}" \
                    -var="create_alb=${params.CREATE_ALB}" \
                    -var="create_rds=${params.CREATE_RDS}" \
                    -var="create_efs=${params.CREATE_EFS}" \
                    -var="multi_az=${params.MULTI_AZ}" \
                    -var="backup_retention_period=${params.BACKUP_RETENTION}"
                    """
                }
            }
        }
        stage('Smoke Test') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]
                ]) {

                    sh '''
                    echo "Checking EC2 instances..."

                    aws ec2 describe-instances \
                    --filters Name=instance-state-name,Values=running \
                    --query "Reservations[*].Instances[*].[InstanceId,State.Name]" \
                    --output table
                    '''
                }
            }
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