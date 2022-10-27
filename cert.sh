cert=$(docker exec -t rancher kubectl get secret k3s-serving -n kube-system  -o yaml | sed -n 3p | awk '{print $2}')
echo $cert |base64 -di >> cert.crt 
openssl x509 -enddate -noout -in cert.crt
rm cert.crt
