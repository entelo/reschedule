Reschedule
==========

Automatic, configurable rescheduling of Kubernetes pods

Overview
--------

Reschedule lets you configure periodic, conditions-based rescheduling of Kubernetes pods. For example, if the memory usage of a node is too high, Reschedule can automatically detect that state and reschedule the pods on the node, evenly distributing the memory usage across the cluster.

Usage
-----

Reschedule runs as a container on your Kubernetes cluster:

1. Clone this repo
1. Create `Dockerfile` and `reschedule.yml` using the example files as references (see [Configuration](#configuration))
1. Build and run the Docker image on your Kubernetes cluster

### Configuration

#### reschedule.yml

A rescheduler is a periodic task that reschedules pods based on conditions. You can define as many reschedulers as you like in `reschedule.yml`.

For example, the following `reschedule.yml` will:
* Reschedule all pods every 12 hours
* Reschedule all pods in the namespace `mynamespace` on nodes with >80% memory usage every 30 minutes

```yaml
reschedulers:
  -
    type: All
    every: 12h
    options:
      replication_controller_name_match: my-rc-name
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

* `memory_threshold` - The memory threshold (0.8 == 80%)
* `namespace` - The namespace of the pods

License
-------

Reschedule is released under the MIT License. Please see the MIT-LICENSE file for details.
