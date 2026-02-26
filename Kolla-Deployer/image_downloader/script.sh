#!/bin/bash
while IFS= read -r line; do
    newrepo="kolla-deployer-01.tcs.cloud:5000"
    originalimage=$line
    retaggedimage=$(echo "$line" | sed "s/quay.io/$newrepo/")
    echo "Pulling Docker Image $originalimage"
    docker pull $originalimage
    echo "Tagging Docker Image $originalimage to $retaggedimage"
    docker tag $originalimage $retaggedimage
    echo "Pushing Docker Image $retaggedimage"
    docker push $retaggedimage
    echo "Removing Docker Image $originalimage"
    # docker rmi $originalimage
done < "$1"