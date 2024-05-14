## Acknowledgements:
This repo was cloned from Jason Kincl's excellent ["Lustre on OpenShift" GitHub repo](https://github.com/kincl/lustre-kmod-container)

# Graid Technology's SupremeRAID for OpenShift

GOAL: Enable Graid Technology's SupremeRAID high performance storage for OpenShift workloads

Tasks:

- Install any NVIDIA dependencies (NVIDIA Operator?)
- Build the kernel modules using the Kubernetes Kernel Module Management operator
and OpenShift's Driver Toolkit image

## Building SupremeRAID kernel modules for Red Hat CoreOS

Red Hat CoreOS is based on RHEL but uses an extended update kernel and in order to make
it easier to build kernel modules we have the [Driver Toolkit](https://docs.openshift.com/container-platform/4.12/hardware_enablement/he-driver-toolkit.html) available which contains
all of the kernel development headers for a particular release of OpenShift.

In the past we developed an operator to help manage specialized resources on OpenShift
(Special Resource Operator) but we are migrating to a collaborative effort upstream to
manage kernel modules for Kubernetes called the Kernel Module Management operator.

* Upstream: [github](https://github.com/kubernetes-sigs/kernel-module-management) and [docs](https://kmm.sigs.k8s.io/)
* Midstream: [github](https://github.com/rh-ecosystem-edge/kernel-module-management) and [docs](https://openshift-kmm.netlify.app/)
* Downstream: [OpenShift docs](https://docs.openshift.com/container-platform/4.15/hardware_enablement/kmm-kernel-module-management.html)

### Deploying the Kernel Module Management operator

Kernel Module Management operator (pulling from midstream until deployed into catalogs) [installation documentation](https://github.com/rh-ecosystem-edge/kernel-module-management/blob/main/docs/mkdocs/documentation/install.md)

```
$ oc apply -k https://github.com/rh-ecosystem-edge/kernel-module-management/config/default
```

### Create Module Custom Resources

In the root of this git repository we are using kustomize which will deploy our Module custom resources (in kmm.yaml)

We are lazily labeling all nodes with `feature.kmm.lustre=true` to enable the KMM operator but we really only
need the worker nodes.

```
$ git clone ...

$ oc new-project graid
$ oc apply -k .
$ oc get nodes -o name | xargs -I{} oc label {} feature.kmm.graid=true
```

### Building the Lustre kernel module container image

The KMM operator will kick off a OpenShift Build using the Dockerfile in this repository. Currently this build pulls
the source RPMs from the AWS FSx RPM repositories and rebuilds them for the Red Hat CoreOS kernel. Once the build
completes it will create DaemonSets to insert the kernel modules on the nodes with the `feature.kmm.graid=true` label.

### Creating GRAID storage

TODO: Create PD, VG, VDs...

### Seeing the GRAID storage

TODO: lsblk

### Consume the storage using LVMStorage

TODO: Is LVMStorage the right tool? What about RWX volumes?

## Testing

TODO: Create a VM - observe StorageClass `bindingMode: WaitForFirstConsumer`