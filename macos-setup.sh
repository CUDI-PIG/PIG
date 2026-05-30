#!/bin/bash

set -e

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Instalando herramientas de linea de comandos de Xcode..."
  xcode-select --install
  echo "Vuelva a correr este script cuando termine la instalacion de Xcode Command Line Tools."
  exit 1
fi

# ddavila 2026-03-18:
# Max supported kubectl version is 1.31.1
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm64/arm64/')"
curl -LO "https://dl.k8s.io/release/v1.31.1/bin/darwin/$ARCH/kubectl"

if command -v kubectl >/dev/null 2>&1; then
  KUBECTL_INSTALL_PATH="$(command -v kubectl)"
else
  KUBECTL_INSTALL_PATH="/usr/local/bin/kubectl"
fi

sudo mkdir -p "$(dirname "$KUBECTL_INSTALL_PATH")"
sudo install -o root -g wheel -m 0755 kubectl "$KUBECTL_INSTALL_PATH"
rm kubectl

# install krew

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm64/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

kubectl krew install oidc-login
