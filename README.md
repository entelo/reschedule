<h1><img src="docs/logo.png?raw=true" width="27" /> Reschedule</h1>

Automatic, configurable Kubernetes rescheduling

Overview
--------

Reschedule lets you configure periodic and/or conditions-based rescheduling of Kubernetes pods. For example, you could configure Reschedule to:

* Check the memory usage of each node every 30 minutes. If the memory usage of a node is above 80%, reschedule the node's pods to more evenly distribute memory usage across the cluster.
* Restart all of a specific replication controller's pods every 24 hours as a stopgap for slow memory leaks.

Usage
-----

Reschedule runs as a pod on your Kubernetes cluster:

1. Clone this repo
1. Create `Dockerfile` and `reschedule.yml` using the `.example` files as references (see [Configuration](#configuration))
1. Build and run the Docker image on your Kubernetes cluster

Configuration
-------------

### reschedule.yml

A rescheduler is a periodic task that reschedules pods based on conditions. You can define as many reschedulers as you like in `reschedule.yml`.

For example, the following `reschedule.yml` will:
* Every 12 hours, reschedule all pods of replication controllers with names matching the regex `/aggregation\-(fast|slow)/`
* Every 30 minutes, reschedule all pods in the namespace `mynamespace` on nodes with >80% memory usage

```yaml
reschedulers:
  -
    type: All
    every: 12h
    options:
      replication_controller_name_match: aggregation\-(fast|slow)
  -
    type: MemoryThreshold
    every: 30m
    options:
      memory_threshold: 0.8
      namespace: mynamespace
```

### Rescheduler types

#### All

Reschedules all pods.

Options:

* `namespace` - The namespace of the pods
* `replication_controller_name_match` - Only pods of replication controllers with names that match this regex will be rescheduled.

#### MemoryThreshold

Reschedules all pods on nodes with memory usage greater than the threshold.

Options:

* `namespace` - The namespace of the pods
* `memory_threshold` - The memory threshold (0.8 == 80%)

### Dockerfile

See `Dockerfile.example` for an example.

#### Authentication

To authenticate to the Kubernetes API, you have a couple of options:

```bash
# Authentication option 1: HTTP basic auth
ENV KUBERNETES_API_USERNAME myusername
ENV KUBERNETES_API_PASSWORD mypassword

# Authentication option 2: client certificate
ENV KUBERNETES_API_CLIENT_KEY myclientkey
ENV KUBERNETES_API_CLIENT_CERT myclientcert
ENV KUBERNETES_API_CA_FILE path/to/my/ca/file
```

#### Dry run

You can put Reschedule in dry run mode with:

```bash
ENV RESCHEDULE_DRY_RUN 1
```

In this mode, Reschedule won't perform any rescheduling, but it will log the rescheduling that it would do.

License
-------

Reschedule is released under the MIT License. Please see the MIT-LICENSE file for details.
