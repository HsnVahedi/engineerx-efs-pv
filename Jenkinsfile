pipeline {
    agent {
        docker {
            image 'hsndocker/aws-cli:latest'
            args '-u root:root'
        }
    }
    parameters {
        string(name: 'ACTION', defaultValue: 'apply')
        string(name: 'MEDIA_EFS_ID')
        string(name: 'STATIC_EFS_ID')
    }
    environment {
        ACCESS_KEY_ID = credentials('aws-access-key-id')
        SECRET_KEY = credentials('aws-secret-key')
        ACTION = "${params.ACTION}"
        REGION = "us-east-2"
        CLUSTER_NAME = "engineerx"
        MEDIA_EFS_ID = "${params.MEDIA_EFS_ID}"
        STATIC_EFS_ID = "${params.STATIC_EFS_ID}"
        // DOCKERHUB_CRED = credentials('dockerhub-repo')  
    }
    stages {
        stage('Providing Access Keys') {
            steps {
                sh('aws configure set aws_access_key_id $ACCESS_KEY_ID')
                sh('aws configure set aws_secret_access_key $SECRET_KEY')
                sh('aws configure set default.region $REGION')
            }
        }
        stage('Setting kubeconfig') {
            steps {
                sh('aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME')
            }
        }
        stage('Terraform Initialization') {
            steps {
                sh('terraform init')
            }
        }
        stage('Apply Changes') {
            steps {
                script {
                    if (env.ACTION == 'destroy') {
                        sh('terraform refresh --var static_efs_id=$STATIC_EFS_ID --var media_efs_id=$MEDIA_EFS_ID')
                        sh('terraform destroy --var static_efs_id=$STATIC_EFS_ID --var media_efs_id=$MEDIA_EFS_ID --auto-approve')
                    }
                    if (env.ACTION == 'apply') {
                        sh('terraform refresh --var static_efs_id=$STATIC_EFS_ID --var media_efs_id=$MEDIA_EFS_ID')
                        sh('terraform apply --var static_efs_id=$STATIC_EFS_ID --var media_efs_id=$MEDIA_EFS_ID --auto-approve')
                    }
                    if (env.ACTION == 'create') {
                        sh('terraform apply --var static_efs_id=$STATIC_EFS_ID --var media_efs_id=$MEDIA_EFS_ID --auto-approve')
                    }
                }
            }
        }
    }
}