# Homework №1 in the course "Industrial Software Development"

## Run

    chmod +x deploy.sh
    ./deploy.sh

## Test API

    kubectl port-forward -n logging-hw svc/custom-app-service 8080:80

In another terminal:

    curl http://127.0.0.1:8080/
    curl http://127.0.0.1:8080/status
    curl -X POST http://127.0.0.1:8080/log -H 'Content-Type: application/json' -d '{"message":"test log"}'
    curl http://127.0.0.1:8080/logs