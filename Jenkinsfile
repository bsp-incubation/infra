pipeline {
  agent any
  stages {
    stage('Git cloning') {
      steps {
        git(url: 'https://github.com/bsp-incubation/infra.git', credentialsId: 'cjm95')
      }
    }

    stage('Init') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform init -lock=false /var/lib/jenkins/workspace/infra_master'''
      }
    }

    stage('Apply') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform plan -lock=false -var-file=var.json /var/lib/jenkins/workspace/infra_master
'''
        sh '''cd /var/lib/jenkins/workspace
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/infra_master'''
      }
    }

    stage('Check') {
      steps {

        sh '''cd /var/lib/jenkins/workspace/
terraform output > id.txt
sed \'s/ //g\' id.txt > newid.txt
terraform output -json | jq \'.CRBS_internal_dns_name\' > front.json
terraform output -json | jq \'.CRBS_rds_instance_address\' > back.json'''
        sh '''cd /var/lib/jenkins/workspace/infra_master
cp key.sh /var/lib/jenkins/workspace
cp cli.sh /var/lib/jenkins/workspace
'''
        sh '''cd /var/lib/jenkins/workspace
cat key.sh newid.txt > ids.sh
chmod +x ids.sh
cat ids.sh cli.sh > script.sh
chmod +x script.sh'''
        sh '''cd /var/lib/jenkins/workspace
cat ids.sh copy.sh > rds.sh
chmod +x rds.sh
./rds.sh'''
        withAWS(region: 'ap-northeast-2', credentials: 'hanju') {
          sh '''cd /var/lib/jenkins/workspace/
./script.sh'''
        }

      }
    }

  }
}
