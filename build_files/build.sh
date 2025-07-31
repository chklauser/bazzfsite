#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## ZFS (originally derived from https://github.com/shymega/shyBazzite-zfs-test/blob/main/build_files/build.sh)

RELEASE="$(rpm -E %fedora)"

# as per https://openzfs.github.io/openzfs-docs/Getting%20Started/Fedora/index.html
# "zfs-fuse is unmaintained and should not be used under any circumstance"
rpm -e --nodeps zfs-fuse
dnf install -y https://zfsonlinux.org/fedora/zfs-release-2-8$(rpm --eval "%{dist}").noarch.rpm
dnf install -y kernel-devel-"$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
dnf install -y zfs

# Auto-load ZFS module
depmod -a "$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
echo "zfs" > /etc/modules-load.d/zfs.conf && \
# we don't want any files on /var
rm -rf /var/lib/pcp
## Just in case, according to https://openzfs.github.io/openzfs-docs/Getting%20Started/Fedora/index.html#installation
echo 'zfs' > /etc/dnf/protected.d/zfs.conf

# this installs a package from fedora repos
# dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
# systemctl enable podman.socket
