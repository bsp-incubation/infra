# infra
terraform 을 통한 인프라스트럭처를 구성하는 프로젝트 입니다.
Jenkins로 terraform 배포하기

# Infra CI/CD Jenkins 설정

# Java 설치

1. Java 8 설치

```bash
sudo yum install -y java-1.8.0-openjdk-devel.x86_64
```

2. Java version 변경

```bash
sudo /usr/sbin/alternatives --config java
2 + Enter
```

3. Java 7 삭제

```bash
sudo yum remove java-1.7.0-openjdk
```

4. Java 8 확인

```bash
java -version
```

# Jenkins 설치

1. yum update

```bash
sudo yum update
```

2. Jenkins 다운로드

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

3. Jenkins 저장소 키를 등록

```bash
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
```

4. Jenkins 설치

```bash
sudo yum install jenkins
```

5. Jenkins Password 코드를 설정

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

# Nginx 설치

1. Nginx 설치

```bash
sudo yum install nginx
```

2. proxy pass 설정

```bash
sudo vim /etc/nginx/nginx.conf
```

```bash
proxy_pass http://localhost:8080;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $http_host;
```

3.  Nginx 실행

```bash
sudo service nginx start
```

# Terraform 설치

```shell
sudo yum update						
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip 
unzip terraform_0.12.20_linux_amd64.zip	
sudo mv terraform /usr/bin/		
```

# Git 설치

```shell
sudo yum install git
which git		# /usr/bin/git 이면 ok
```

# Plugin 설치 목록

* [ AWS CodePipeline Plugin](https://plugins.jenkins.io/aws-codepipeline)
* [ Pipeline: AWS Steps](https://plugins.jenkins.io/pipeline-aws)
* [Blue Ocean](https://plugins.jenkins.io/blueocean)
* [GitHub Authentication plugin](https://plugins.jenkins.io/github-oauth)
* [Pipeline](https://plugins.jenkins.io/workflow-aggregator)
* [Terraform Plugin](https://plugins.jenkins.io/terraform)
* [Deploy to container Plugin](https://plugins.jenkins.io/deploy)

# Global Tool Configuration



# 계정 정보 설정

## aws 계정 정보 설정


# Blue ocean


# 계정 정보 설정

/var/lib/jenkins/workspace/ 에 다음과 같은 변수 값을 지닌 var.json파일을 미리 생성해 두어야 한다.

```json
{
        "aws_access_key" : "access key value",
        "aws_secret_key" : "secret key value",
        "db_password"    : "DB password",
        "db_username"    : "DB master user name"
}
```

# CICD 수행 과정

1. Git clone



2. terraform init


3. terraform 실행


   1. terraform plan


   2. terraform apply


4. 생성된 리소스 확인

   1. 생성된 리소스 결과값 받기
   2. Git에서 받아온 shell 파일 workspace로 이동
   3. shell 파일과 리소스 결과값으로 resource cli script 완성


   4. script 결과물

