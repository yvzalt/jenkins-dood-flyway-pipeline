pipeline{

    agent any

    parameters{
        choice(name: 'executeInTransaction', choices: ['true', 'false'], description: 'Execute all SQL migrations in a transaction block? (Select false for CONCURRENTLY index or VACUUM)')
        choice(name: 'baselineOnMigrate', choices: ['true', 'false'], description: 'Automatically baseline non-empty databases during migration. If enabled, Flyway creates a baseline marker (default baselineVersion: 1) to skip older scripts. Ideal for introducing Flyway to existing databases.')
        booleanParam(name: 'runMigrations', defaultValue: true, description: 'Whether to run the Flyway migrations or not.')
    }

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

                    // Jenkins will reuse the same workspace and files from the previous stage
                    reuseNode true

                    args '--entrypoint=""'
                    //Jenkins wants to use own entrypoint. 
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
                    
                    // Jenkins will reuse the same workspace and files from the previous stage
                    reuseNode true
        
                    args '--entrypoint=""' 
                    //Jenkins wants to use own entrypoint. 
                }
            }
            steps{

                script {
                    if (params.runMigrations) {
                        def executeInTransactionFlag = params.executeInTransaction.toBoolean() ? '' : '-executeInTransaction=false'
                        def baselineOnMigrateFlag = params.baselineOnMigrate.toBoolean() ? '-baselineOnMigrate=true' : ''

                        sh "flyway -url=\$DB_URL -user=\$DB_CREDENTIALS_USR -password=\$DB_CREDENTIALS_PSW -schemas=app_schema -locations=filesystem:sql ${executeInTransactionFlag} ${baselineOnMigrateFlag} migrate"
                        //Adding -executeInTransaction="false" parameter executes ALL SQL migrations non-transactionally.

                        // Note: If you set -baselineVersion=2, V2 becomes the baseline (the default is V1). Flyway will then skip older scripts and start executing from V3 onwards. Even if you remove this parameter later, Flyway will remember the baseline state thanks to the flyway_schema_history table, ensuring V1 is never executed.
                        
                    } else {
                        echo 'Skipping Flyway migrations as runMigrations parameter is set to false.'
                    }
                }

                
            }
        }
    }

}
