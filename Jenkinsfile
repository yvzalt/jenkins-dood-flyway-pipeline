pipeline{

    agent{

        docker{
            image 'flyway/flyway:latest-alpine'

            //args '-v /opt/flyway-sql:/flyway/sql'
            // if you want to run scripts from path instead of git
        }

    }

    environment{
        DB_URL = ''

        DB_CREDENTIALS = credentials('db-credentials-for-flyway')
        // Prerequisite: Go to Manage Jenkins -> Credentials, create a 'Username with password' credential and set its ID to 'db-credentials-for-flyway'.
    }

    stages{

        stage('Checkout'){

            steps{
                git url: '', branch:'main'
            }
        }

        stage('Flyway Info'){
            
            steps{

                sh 'flyway -url=$DB_URL -user=$DB_CREDENTIALS_USR -password=$DB_CREDENTIALS_PSW -schemas=app_schema -locations=filesystem:sql info' 

            }
        }

        stage('Flyway Migrate'){

            steps{

                sh 'flyway -url=$DB_URL -user=$DB_CREDENTIALS_USR -password=$DB_CREDENTIALS_PSW -schemas=app_schema -locations=filesystem:sql migrate'
                //Adding -executeInTransaction="false" parameter executes ALL SQL migrations non-transactionally.
            }
        }


    }
}