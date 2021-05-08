dssh() {
    cid=$(docker ps |grep "$1"|awk '{print $1}')
    echo "Try to access container $cid"
    docker exec -it $cid bash
}
