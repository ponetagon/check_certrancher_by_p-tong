docker exec -it rancher sh -c "rm -rf /var/lib/rancher/k3s/server/tls/dynamic-cert.json"
docker exec -it rancher sh -c "k3s kubectl --insecure-skip-tls-verify  delete secrets -n kube-system k3s-serving"
docker exec -it rancher sh -c "k3s kubectl --insecure-skip-tls-verify  delete secrets -n cattle-system serving-cert"
docker restart rancher
