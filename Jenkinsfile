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