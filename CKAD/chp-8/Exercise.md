# Migrate a CronJob to a New API Version

## Objective

In this lab, you will learn how to migrate an existing **CronJob** deployed in a Kubernetes Cluster to a newer API Version.

In a *previous lesson*, we built and deployed a CronJob automating an ETL process to our Kubernetes Cluster.

> **NB:** The *actual* CronJob resource is currently at V1 stable/Generally Available level, and as of writing is the ***recommended*** version. This is purely an example for educational purposes.

Now, Kubernetes has announced that a newer version of the CronJob resource has been released, touting multiple improvements and benefits, and you want to *"upgrade"* your resource to use this.

## Prerequisites

Before starting this exercise, you should have:

- Docker Desktop installed on your machine
- Basic knowledge of Kubernetes and its components and resources
- A working installation of the **`kubectl`** CLI tool
- A Kubernetes cluster with at least one worker node.
  - Minikube or even built-in Docker Desktop Kubernetes (used while making this exercise) and other alternatives are suitable

## Steps

### 1. Check Kubernetes for the Latest API Versions

You can request the latest known and supported resource API Versions from your Kubernetes Cluster:

```bash
kubectl api-versions | grep batch
```
This should return something like **`batch/v1`**.

For the sake of this lesson, we'll *assume* it also returned **`batch/v2alpha1`**, which is what we'll be *"migrating"* to.

### 2. Update CronJob Manifest to Use New API Version

In your previously created *(and applied)* **`etl_cronjob.yaml`** file, change the **`apiVersion: batch/v1`** line to reflect the API Version the cluster gave you:

```yaml
apiVersion: batch/v2alpha1
kind: CronJob
...
```

### 3. Apply the Updated CronJob Manifest to Kubernetes

For your deployed CronJob to be updated, we need to re-apply the manifest to the Kubernetes Cluster:

```bash
kubectl apply -f etl_cronjob.yaml
```

Run the following to confirm that the CronJob was *"deployed"* correctly:

### 4. Verify the CronJob was Updated on the Kubernetes Cluster

To confirm that the *"migration"* has succeeded, we need to inspect the CronJob on the cluster:

```bash
kubectl describe cronjob etl-cronjob
```

This should, again, output a nicely formatted list describing the CronJob, in an almost similar format to the **`YAML`** file we defined.

Here, you can inspect and confirm that the CronJob's API Version has been updated to the latest one.

Any Jobs spawned by the CronJob in the future should also now use the specified API Version.

> **NB:** Note that at this point there might be configuration files, scripts or other resources that interact with the CronJob that might not be compatible with the new API Version.

## Recap

You should now have learned how to *migrate* a Kubernetes CronJob from one API Version to a newer one, as well as how to *investigate* and confirm the upgrade on a Kubernetes Cluster.

This will have given you a better understanding of how Kubernetes Resource API Versions work, some example use cases for why migrations might be needed, and the ability to apply this knowledge to real-world applications.
