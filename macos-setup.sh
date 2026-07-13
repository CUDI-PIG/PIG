#!/bin/bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew no está instalado."
  echo "Instálelo siguiendo las instrucciones de https://brew.sh/es/ y vuelva a correr este script."
  exit 1
fi

brew install kubernetes-cli kubelogin

echo "kubectl y oidc-login se instalaron correctamente."
kubectl version --client=true
kubectl oidc-login --version
