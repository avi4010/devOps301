node {

 def server = Artifactory.server "01"
 def buildInfo = Artifactory.newBuildInfo()

 stage('Git ChechOut') {
  git branch: 'main', url: 'https://github.com/avi4010/devOps301.git' 
 }
 
 stage('Maven Clean') {
  sh 'mvn clean'
 }

 stage('Maven Compile') {
  sh 'mvn compile'
 }
 
 stage('Maven Test') {
    sh 'mvn test'
 }

 stage('Maven Package') {
  sh 'mvn package'
 }

 stage('Build Management') {
		def uploadSpec = """{ 
			"files": [
			{
			"pattern": "**/*.war",
			"target": "petclinic-repo"
			}
		]

	}"""
	server.upload spec: uploadSpec
 }

 stage('Publish Build Info'){
   server.publishBuildInfo buildInfo
 }

 stage('Archive Artifact') {
  archiveArtifacts artifacts: 'target/petclinic.war', followSymlinks: false
 }

 stage('Docker Deployment') {
  sh 'docker-compose up -d --build'
 }

 stage('Getting Ready For Ansible Deployment'){

     sh "cp -rf target/petclinic.war terraform-code/ansible-code/roles/petclinic/files/"

 }



 stage('Terraform Deployment'){

     sh "cd terraform-code; terraform init ; terraform apply --auto-approve"

 }
}