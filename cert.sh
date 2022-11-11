docker exec rancher kubectl get secret k3s-serving -n kube-system  -o jsonpath="{.data.tls\.crt}" | base64 -di >> cert.crt
openssl x509 -enddate -noout -in cert.crt
rm cert.crt
