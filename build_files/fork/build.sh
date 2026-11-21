#!/usr/bin/env bash
#
# Customizations for this fork, kept in one place so upstream rebases only
# touch the single line that calls this script from build_files/build.sh.
#
set -xeuo pipefail

echo "::group::Fork customizations"
trap 'echo "::endgroup::"' EXIT

# -- Helium browser --
# The copr is only enabled for this install so it never ships enabled.
echo "==> Installing Helium..."
dnf5 -y copr enable imput/helium
mkdir -p "$(realpath -m /opt)"
dnf5 -y install helium-bin
dnf5 -y copr disable imput/helium

# /opt points at /var/opt on the booted system, which is not part of the image.
# Keep Helium in /usr/lib/opt and link it back at boot via tmpfiles.d.
mkdir -p /usr/lib/opt
mv "$(realpath /opt/helium)" /usr/lib/opt/helium

# -- ZSH as the default shell for new users --
echo "==> Installing ZSH..."
dnf5 -y install zsh
sed -i 's|^SHELL=.*|SHELL=/usr/bin/zsh|' /etc/default/useradd

# -- Ghostty terminal --
# Terra is still enabled at this point in the build (finalize.sh disables it).
echo "==> Installing Ghostty..."
dnf5 -y install ghostty
