pipeline{

    agent any

    environment{
        DB_URL = 'jdbc:postgresql://192.168.56.11:5432/app_db'

        DB_CREDENTIALS = credentials('db-credentials-for-flyway')
        // Prerequisite: Go to Manage Jenkins -> Credentials, create a 'Username with password' credential and set its ID to 'db-credentials-for-flyway'.
    }

    stages{

        stage('Checkout'){
            
            steps{
                git url: 'https://github.com/yvzalt/jenkins-dood-flyway-pipeline.git', branch:'main'
            }
        }

        stage('Flyway Info'){
            agent {
                docker {
                    image 'flyway/flyway:latest-alpine'
                    // 3. Çok Kritik: Ana makineye inen kodların (workspace) konteynere bağlanmasını sağlar
                    reuseNode true 
                }
            }
            steps{

                sh 'flyway -url=$DB_URL -user=$DB_CREDENTIALS_USR -password=$DB_CREDENTIALS_PSW -schemas=app_schema -locations=filesystem:sql info' 

            }
        }
        

        stage('Flyway Migrate'){
            agent {
                docker {
                    image 'flyway/flyway:latest-alpine'
                    // 3. Çok Kritik: Ana makineye inen kodların (workspace) konteynere bağlanmasını sağlar
                    reuseNode true 
                }
            }
            steps{

                sh 'flyway -url=$DB_URL -user=$DB_CREDENTIALS_USR -password=$DB_CREDENTIALS_PSW -schemas=app_schema -locations=filesystem:sql migrate'
                //Adding -executeInTransaction="false" parameter executes ALL SQL migrations non-transactionally.
            }
        }
    }

}
