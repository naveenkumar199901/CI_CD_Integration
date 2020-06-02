def mvnHome
node('master'){
   stage('git checkout'){
      try {
      git credentialsId: 'Git', url: 'https://github.com/naveenkumar199901/CI_CD_Integration.git'
      } catch(err) {
         sh "echo error in checkout"
      }
   }
  
   stage('maven test'){
      try {
      mvnHome=tool 'M2_HOME'
      sh "${mvnHome}/bin/mvn --version"
      sh "${mvnHome}/bin/mvn clean test surefire-report:report"
      } catch(err) {
         sh "echo error in defining maven"
      }
   }
   
   stage('test case and report'){
      try {
         echo "executing test cases"
         junit allowEmptyResults: true, testResults: 'addressbook_main/target/surefire-reports/*.xml'
         publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'addressbook_main/target/site', reportFiles: 'surefire-report.html', reportName: 'SureFireReportHTML', reportTitles: ''])
      } catch(err) {
         throw err
      }
   }
   
      stage('package and artifacts'){
      try {
         sh "${mvnHome}/bin/mvn clean package install"
         archiveArtifacts allowEmptyArchive: true, artifacts: 'addressbook_main/target/**/*.war'
      } catch(err) {
         sh "echo error in generating artifacts"
      }
   }

   stage ('docker build and push'){
      try {
       sh "docker version"
       sh "docker build -t naveenkumar199901/archiveartifacts:newtag -f Dockerfile ."
       sh "docker run -p 8085:8080 -d naveenkumar199901/archiveartifacts:newtag"
       withDockerRegistry(credentialsId: 'Docker-hub') {
       sh "docker push naveenkumar199901/archiveartifacts:newtag"
        }
      } catch(err) {
         sh "echo error in docker build and pushing to docker hub"
      }
   }
  stage('deployment of an application'){
      try {
         sshagent(['Naveen-Kumar']) {
            sh "scp -o StrictHostKeyChecking=no tomcat.sh ec2-user@172.31.19.72:/tmp"
            sh "scp -o StrictHostKeyChecking=no symlink_target.sh ec2-user@172.31.19.72:/tmp"
            sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.19.72 /tmp/tomcat.sh"
            sh "scp -o StrictHostKeyChecking=no addressbook_main/target/addressbook.war ec2-user@172.31.19.72:/tmp"
            sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.19.72 /tmp/symlink_target.sh"
         }
      } catch(err){
         echo "error in deployment of an application"
      }
   }
   stage('artifacts to s3') {
      try {
      // you need cloudbees aws credentials
      withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'S3UploadCredentitals', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
         sh "aws s3 ls"
         sh "aws s3  cp addressbook_main/target/addressbook.war s3://s2-artifact-naveem/"
         }
      } catch(err) {
         sh "echo error in sending artifacts to s3"
      }
   }
}
