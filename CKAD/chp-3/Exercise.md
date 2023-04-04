# Create a Cron Job that does ETL

## Objective

In this lab you will learn how to create a **CronJob** within a Kubernetes cluster.

The CronJob will automate an ETL (Extract, Transform and Load) operation on a schedule, which we'll build using *Python*.

The ETL process will *extract* data from a data source, perform some *transform*ation on it and *load* it into a destination.

## Prerequisites

Before starting this exercise, you should have:

- Docker Desktop installed on your machine
- Basic knowledge of Kubernetes and its components and resources
- A working installation of the **`kubectl`** CLI tool
- A Kubernetes cluster with at least one worker node.
  - Minikube or even built-in Docker Desktop Kubernetes (used while making this exercise) and other alternatives are suitable
- A command line HTTP client like **`curl`** or **`wget`** installed

## Steps

### 1. Create ETL app with Python

Pull or download the ETL script from our labs repository:
```bash
curl https://raw.githubusercontent.com/markdavidmc0/tech-battalion-labs/main/CKAD/chp-3/restcountries_etl.py -o restcountries_etl.py
```

You should now have a file named **`restcountries_etl.py`** containing our ETL process' code.

#### **Quick Explanation**

This program runs through the three steps of an ETL (Extract, Transform, Load) process in order, by calling aptly named functions.

- **Extract**: Do a **`GET`** request to the publicly available **`restcountries`** API, *extracting* a copy of all their data.
- **Transform**: The data includes a lot of information we don't need, so we *transform* it into a smaller, structured dataset including only the required information.
- **Load**: The **transformed** data is now saved to another location for further use. In this example, it simply writes to a **`JSON`** file in a subdirectory.

> **NB:** Typically, the destination would be a ***database*** or even ***another API endpoint***.

You will also need a file named **`requirements.txt`** with the following inside to run the code:

```txt
requests
```

Test the script to ensure it runs correctly:

> **NB:** It is *strongly recommended* to use virtual environments for Python applications.

```bash
python restcountries_ETL.py
```

You should see a message like "**`ETL process completed successfully.`**" printed in the terminal, as well as find a new **`data/`** directory with a **`.json`** file inside your project.

### 2. Create Docker image for the ETL application

Pull or download the ETL script from our labs repository:
```bash
curl https://raw.githubusercontent.com/markdavidmc0/tech-battalion-labs/main/CKAD/chp-3/Dockerfile -o Dockerfile
```

You should now have a file named **`Dockerfile`** which specifies what the ETL image should look like.

#### **Quick Explanation**

This specifies to use the latest *Python* version, on a slimmed-down version of *Debian* as the base Docker image, with the code and files copied into an **`/app`** directory.

It installs the Python script's required libraries, and then states the command to run when the image is started.

As a best practice, your **`Dockerfile`** can be supplemented with a **`.dockerignore`** file for cleaner images:

```.dockerignore
data/
Dockerfile
*.yml
```

This simply tells the Dockerfile to not include these files when copying contents into the built image.

### 3. Build and tag the Dockerfile

With **`docker`** installed and running on the system, run the following command in the terminal from your project directory to **build** and **tag** the ETL Dockerfile we created in the previous step:

```bash
docker build -t restcountries-etl:latest .
```

Run the following to confirm that it has been built correctly:

```bash
docker images restcountries-etl
```

You should see your image listed, with **`latest`** under the **`TAG`** column.

### 4. Create K8s CronJob that runs the ETL job on a schedule

Create a new file named **`etl_cronjob.yaml`** with the basic header structure for a Kubernetes **CronJob**:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: etl-cronjob
spec:
```

CronJobs require a **schedule**, to specify when, and how frequently it needs to create Jobs that execute your code.

Under **`spec:`** specify a **`schedule`** to run the Job *every 5 minutes*:

```yaml
  schedule: "*/5 * * * *"
```

When a CronJob is deployed, it will wait for the specified schedule time before running the first Job.

To make it run the first one soon after deployment, we can specify a low value for **`startingDeadlineSeconds`**:

```yaml
  startingDeadlineSeconds: 10
```

Next, we need to define the **`jobTemplate`**, which specifies what the *Jobs* and *Pods* it generates need to look like and execute:

```yaml
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: restcountries-etl
            image: restcountries-etl:latest
            imagePullPolicy: IfNotPresent
            command: ["python", "restcountries_ETL.py"]
          restartPolicy: OnFailure
```

Here we are specifying that the **CronJob** (and subsequently its *Jobs*) use the **`restcountries-etl:latest`** image that we built locally in the previous step, and add **`imagePullPolicy: IfNotPresent`** to force it to look for the image *locally* before pulling.

> **NB:** In practice, your **`image:`** specification would be pointing to an *online* container registry, like *Docker Hub* or even *GCR* (Google Container Registry).

### 5. Confirm kubectl and Kubernetes Cluster is correctly set up

In your terminal, run the following command:

```bash
kubectl cluster-info
```

You should be able to see that your **Kubernetes Cluster** is *running* and *accessible*.

To confirm that the **Nodes** are *ready*, you can also run:

```bash
kubectl get nodes
```

### 6. Deploy the CronJob to Kubernetes Cluster & Verify Success

To create your **CronJob** on the Kubernetes Cluster, we need to ***apply*** the configuration file we created previously:

```bash
kubectl apply -f etl_cronjob.yaml
```

Run the following to confirm that the CronJob was *"deployed"* correctly:

```bash
kubectl get cronjobs
```

To see if it has been run yet, look at the **`LAST SCHEDULE`** column.

If the CronJob has been run before, there will be a time difference since the last run listed, otherwise, you'll see **`<none>`** to show it has not been executed yet.

To get a more detailed look at the applied CronJob, use the command:

```bash
kubectl describe cronjob etl-cronjob
```

This should output a nicely formatted list describing the CronJob, in an almost similar format to the **`YAML`** file we defined.

This view can be very useful to better identify any issues, like if there were errors with pulling the image, for instance.

You can also take a closer look at the *resources* the CronJob has created, by running the following to inspect Jobs:

```bash
kubectl get jobs
```

If the CronJob has been run, you will see up to the last 3 *(by default)* **Jobs** listed here, with their ***Completions***, ***Duration*** and ***Age***.

To look at the Pods created by the Jobs, use the following command:

```bash
kubectl get pods
```

Similarly to the previous command, this will list up to the last 3 *(by default)* **Pods** if any Jobs have been run, also usefully showing the ***Status*** of each of the runs.

Noting down the *name* of one of these **Pods**, we can use that to get the logs for a run:

```bash
kubectl logs <pod-name>
```

If the ETL app executed successfully, you should see the same output as for **Step 1**.

## Recap

You should now have learned how to *configure* a Kubernetes CronJob to run a *specified image* on a *required schedule*, as well as how to *deploy* and *investigate* it on a Kubernetes Cluster.

This will have given you a better understanding of what Kubernetes CronJobs are, some example use cases thereof, and the ability to apply this knowledge to real-world applications.
