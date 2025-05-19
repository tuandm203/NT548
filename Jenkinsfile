node {
    stage('Clone code') {
        cleanWs()
        sh 'git clone https://github.com/tuandm203/NT548.git'
    }
    stage('Check AWS Credentials') {
        // Dùng credentials ID 'nhom13' đã cấu hình trong Jenkins
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'nhom13'
        ]]) {    
            // tiep 
            dir('NT548/DoAn/Jenkins/demo-app/') {
                // Kiểm tra thư mục
                sh 'ls -la'
                // Kiểm tra AWS identity (nếu AWS CLI đã được cài)
                sh 'aws --no-cli-pager sts get-caller-identity'
                sh 'helm version'
                // Gọi kubectl với kubeconfig chỉ định
                //sh 'kubectl --kubeconfig=config-k8s get nodes'
                
                sh 'docker ps'

            }
        }
    }
    
    stage('Build Image') {
            dir('NT548/DoAn/Jenkins/demo-app/') {
                // Kiểm tra thư mục
                sh 'docker build -t tuan1102003/demo-app:latest .'
                

            }
    }
    
    
     stage('Push Image') {
            dir('NT548/DoAn/Jenkins/demo-app/') {
                sh 'docker push tuan1102003/demo-app:latest '
                

            }
    }
    
     stage('Deployment kustomize k8s') {
        // Dùng credentials ID 'nhom13' đã cấu hình trong Jenkins
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'nhom13'
        ]]) {    
            // tiep 
            dir('NT548/DoAn/Jenkins/demo-app/') {
                // Kiểm tra thư mục
                sh 'kubectl --kubeconfig=config-k8s apply -k Kustomize/base/'
            }
        }
    }
    
}
