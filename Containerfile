# podman login registry.redhat.io
# podman build -t localhost/graid:dev -f Containerfile

#FROM registry.redhat.io/openshift4/driver-toolkit-rhel8:v4.12 as builder
#FROM registry.redhat.io/openshift4/driver-toolkit-rhel9:v4.15 as builder
FROM registry.redhat.io/openshift4/driver-toolkit-rhel9:v4.15
ARG KERNEL_VERSION=5.14.0-284.64.1.el9_2.x86_64
ARG NVIDIA_VERSION=550.67
ARG SUPREMERAID_CARD=000
ARG SUPREMERAID_VERSION=1.5.0
ARG SUPREMERAID_UPDATE=703
ARG SUPREMERAID_UPDATE_MINOR=132
ARG SUPREMERAID_PREINSTALLER_VERS=xyz

WORKDIR /build/

#RUN curl -o nvidia-${NVIDIA_VERSION}.run https://us.download.nvidia.com/XFree86/Linux-x86_64/550.67/NVIDIA-Linux-x86_64-550.67.run
RUN curl -o graid-pre-installer.run      https://download.graidtech.com/driver/pre-install/graid-sr-pre-installer-1.5.0-107-x86_64.run
RUN curl -o graid-installer.run          https://download.graidtech.com/driver/sr/linux/1.5.0/release/graid-sr-installer-1.5.0-000-703-132.run

RUN chmod -v a+x *.run

# dialog, ipmitool, & mdadm require RHEL repos
RUN dnf -y install automake dialog gcc ipmitool make mdadm mokutil pciutils tar vim wget sg3_utils sqlite-libs gcc-c++ gcc kernel-devel kernel-headers

# dkms requires EPEL (DKMS appears to be for NVIDIA only)

#RUN dnf -y install https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/e/epel-release-9-7.el9.noarch.rpm
#RUN dnf --enablerepo=epel -y install dkms

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/d/dkms-3.0.13-1.el9.noarch.rpm
RUN dnf clean all

# cat /etc/modprobe.d/graid-blacklist.conf
# blacklist nouveau
# options nouveau modeset=0

# grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub
# "... iommu=pt  nvme_core.multipath=Y ..."
# The iommu=pt option only enables IOMMU for devices used in passthrough and will provide better host performance.
# However, the iommu=pt option may not be supported on all hardware.
# Revert to intel_iommu=on or amd_iommu=on if the iommu=pt option doesn't work for your host.



#RUN ./graid-pre-installer.run --yes
#RUN ./graid-installer.run --accept-license
RUN echo Please install manually
USER 0

##FROM registry.access.redhat.com/ubi8/ubi:latest
#FROM registry.access.redhat.com/ubi9/ubi:latest
# ARG KERNEL_VERSION=4.18.0-372.36.1.el8_6.x86_64
# ARG LUSTRE_VERSION=2.12.8

# COPY --from=builder /root/rpmbuild/RPMS/x86_64/kmod-lustre-client-${LUSTRE_VERSION}*.el8.x86_64.rpm /root
# COPY --from=builder /root/rpmbuild/RPMS/x86_64/lustre-client-${LUSTRE_VERSION}*.el8.x86_64.rpm /root

# RUN dnf install -y kmod /root/kmod-lustre-client-${LUSTRE_VERSION}*.rpm /root/lustre-client-${LUSTRE_VERSION}*.rpm

# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/fid.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/fid.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/fld.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/fld.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lmv.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lmv.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lov.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lov.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lustre.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/lustre.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/mdc.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/mdc.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/mgc.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/mgc.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/obdclass.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/obdclass.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/obdecho.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/obdecho.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/osc.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/osc.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/ptlrpc.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/fs/ptlrpc.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/ko2iblnd.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/ko2iblnd.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/ksocklnd.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/ksocklnd.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/libcfs.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/libcfs.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/lnet.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/lnet.ko
# COPY --from=builder /lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/lnet_selftest.ko /opt/lib/modules/${KERNEL_VERSION}/extra/lustre-client/net/lnet_selftest.ko

# RUN depmod -b /opt
#RUN echo "This is UBI"
