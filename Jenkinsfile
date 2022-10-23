pipeline {
    agent any
    
    environment {
        ORGANIZATION_NAME = "red-acre-ltd"
        DOCKERHUB_USERNAME = "frankisinfotech"
        API_NAME           = "react-api"
        CLIENT_NAME        = "react-client"
        V                  = "latest"
        REPOSITORY_API_TAG = "${DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${API_NAME}:${V}"
        REPOSITORY_CLIENT_TAG = "${DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${CLIENT_NAME}:${V}"
    }
    
    stages {
        
        stage ("terraform init") {
            steps {
                sh ('terraform init') 
            }
        }
        
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }

        stage ('Build and Push Image') {
            steps {
                 withDockerRegistry([credentialsId: 'DOCKERHUB_USERNAME', url: ""]) {
                   sh 'docker-compose build'
                   sh 'docker push ${REPOSITORY_API_TAG}'          
                   sh 'docker push ${REPOSITORY_CLIENT_TAG}'          
            }
          }
       }
        stage("Install kubectl"){
            steps {
                sh """
                    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
                    chmod +x ./kubectl
                    ./kubectl version --client
                """
            }
        }
        
        stage ('Deploy to Cluster') {
            steps {
                sh "aws eks update-kubeconfig --region eu-west-2 --name eksclusterdemo"
                sh " envsubst < ${WORKSPACE}/deploy.yaml | ./kubectl apply -f - "
            }
        }
    }
}
