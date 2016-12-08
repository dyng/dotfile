drib() {
    docker run -it $1 /bin/bash
}

deib() {
    docker exec -it $1 /bin/bash
}
