# Un shiny server con doker
### (una prueba de concepto)

Quienes trabajan en `R` conocen muy bien o al menos han oído hablar del las
_shiny apps_. `R`, más allá de alguna muy básica rutina para ingreso de datos
por teclado, no pose una verdadera interfaz de usuario. Ocurre que en `R` no
existe una distinción entre el usuario y el programador, por que básicamente el
usuario es el programador. Sin embargo, en la práctica, en algunos casos existe
la necesidad de poder trasladar un análisis que además sea dinámico e
interactivo a terceros no programadores. Para esto es que existe `shiny` y el
concepto de las _shiny apps_, que básicamente son:

* Uno o más scripts de `R`, no cualquier código sino el particular de estas apps
* Eventualmente datos

Cuando en `Rstudio` hacemos click sobre el botón `Run App` o bien ejecutamos
`shiny::runApp('<mi_app.R>')`, se instancia un servidor web en el puerto `8080`
y se carga la app `<mi_app.R>`.



## Notas sobre docker

Iniciamos el servicio de `docker`:

    systemctl start docker

Compilamos la imagen:

    docker build -t shiny-server-sample .

Ejecutamos el contenedor:

    docker run --rm -i -p 8080:8080 shiny-server-sample

Temas
* Acceso a Internet desde dentro de docker
* Revisar logs


## Problemas con docker

    Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?buildargs=%7B%7D&cachefrom=%5B%5D&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=Dockerfile&labels=%7B%7D&memory=0&memswap=0&networkmode=default&rm=1&shmsize=0&t=shiny-server-sample&target=&ulimits=null&version=1: dial unix /var/run/docker.sock: connect: permission denied44

Probar que estemos en el grupo de docker:

    sudo groupadd docker                # Crea el grupo docker por si no existe
    sudo usermod -aG docker $USER       # Agrega el usuario al grupo docker
    chmod g+rwx /var/run/docker.sock    # Permisos de escritura en el socket
    systemctl restart docker            # Reinicia el servicio de docker
