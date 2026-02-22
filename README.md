# jenkins-dood-flyway-pipeline

Run this to set up the lab environment. It prepares Jenkins and Postgresql server.
```shell
vagrant up
```

Connect to the ci-server and get the Jenkins Administrator Password from the /var/jenkins_home/secrets/initialAdminPassword path:
```shell
vagrant ssh ci-server
```

Go to http://192.168.56.10:8080/ in your browser to access the local Jenkins environment and log in using the initial admin password.

Go to New Item -> Pipeline and select Pipeline script from SCM to use the Jenkinsfile from this GitHub repository.

Go to Manage Jenkins -> Credentials and add a new Username with password credential. Set the ID to db-credentials-for-flyway (Use your PostgreSQL username and password).

Install the Docker Pipeline plugin.

Any SQL scripts you want to run can be added to the /sql directory in the repository. After pushing your changes, you can trigger the pipeline on Jenkins whenever you want.

