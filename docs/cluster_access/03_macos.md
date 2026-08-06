# Usando macOS

## Instalación y configuración

Para instalar las herramientas necesarias usaremos [Homebrew](https://brew.sh/es/), un administrador de paquetes ligero para macOS. Si aún no lo tiene instalado, ejecute el instalador oficial:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Al terminar, siga las instrucciones que muestra el instalador para agregar `brew` al `PATH` de su terminal.

!!! info "Importante"
    Homebrew puede solicitar la instalación de las herramientas de línea de comandos de Xcode como requisito de macOS, pero no necesita instalar la aplicación completa de Xcode.

Instalamos `git` con Homebrew:

```bash
brew install git
```

Después clonamos el repositorio de *GitHub* y entramos al directorio descargado:

```bash
git clone https://github.com/CUDI-PIG/PIG.git
cd PIG
```

Ahora instalamos `kubectl` y el complemento `oidc-login` ejecutando el archivo `macos-setup.sh`:

```bash
chmod +x macos-setup.sh
./macos-setup.sh
```

Con el primer comando hacemos ejecutable el archivo. El segundo instala ambas herramientas mediante Homebrew.

Después configuramos *Kubernetes* ejecutando el archivo `k8s-setup.sh`:

```bash
chmod +x k8s-setup.sh
./k8s-setup.sh
```

Se nos pedirá una llave que nos dará el administrador del clúster, como se ve en la siguiente imagen

![Set secret key](../assets/images/pig_access/secret_key.png){ style="display: block; margin: 0 auto; width: 1000px;"}

!!! info "Importante"
    Para obtener la llave, favor de contactar al administrador del sistema de PIG.

Para verificar que la instalación y configuración fue exitosa, usaremos el siguiente comando

```bash
kubectl get pods
```

Al ejecutar el comando se abrirá una página nueva en su navegador predeterminado como la siguiente

![Keycloak connection](../assets/images/pig_access/keycloak.png){ style="display: block; margin: 0 auto; width: 1000px;"}

Donde deberá ingresar las credenciales de su cuenta en PIG proporcionadas por el administrador. Si al momento de correr un comando de Kubernetes no abre la página de Keycloak, como se ve en la imagen, puede agregar la bandera `--skip-open-browser` al archivo `k8s-setup.sh` para que imprima en la terminal la URI de autenticación. El comando de `kubectl` quedaría de la siguiente manera:

```bash
kubectl config set-credentials oidc --exec-command=kubectl \
    --exec-api-version=client.authentication.k8s.io/v1beta1 \
    --exec-arg="oidc-login" \
    --exec-arg="get-token" \
    --exec-arg="--oidc-issuer-url=https://sso.lamod.unam.mx/auth/realms/cudi" \
    --exec-arg="--oidc-client-id=k8s" \
    --exec-arg="--oidc-client-secret=$client_secret" \
    --exec-arg="--skip-open-browser" \
    --kubeconfig=$KUBECONFIG
```

Debe correr el archivo de nuevo para que se apliquen los cambios.

!!! warning "Importante"
    Por defecto se redirige a `localhost:8000` y, si no está libre, a `localhost:18000`. Si tiene ocupados ambos puertos deberá liberar uno para realizar la autenticación.

Si la conexión fue exitosa, en la terminal obtendrá el resultado del comando de *kubernetes*

![Success connection](../assets/images/pig_access/success_con.png){ style="display: block; margin: 0 auto; width: 1000px;"}

Este comando nos muestra los pods actuales en PIG.

!!! Success "Éxito"
    Si obtiene un resultado similar al de la imagen ¡¡Felicidades ya puede usar el clúster de PIG!!
