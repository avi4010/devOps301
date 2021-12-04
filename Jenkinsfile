node {
    try {
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
        
         stage('SonarQubeScan') {
           withSonarQubeEnv('Sonar'){
             sh 'mvn sonar:sonar'
           }
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
   } catch (all) {
       currentBuild.result = 'FAILURE'
   } finally {
       stage('Send email with status') {
            emailext attachLog: true, body: '''Hi 

            Below is the status and build log attached

            $PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:

            Check console output at $BUILD_URL to view the results.''', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'avinash.seelam2@mindtree.com'
       }
    }
}