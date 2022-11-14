bold=$(tput bold)
normal=$(tput sgr0)

customer=$(hostname)
##### check cert before #####
certbefore=$(docker exec rancher kubectl get secret k3s-serving -n kube-system  -o yaml | sed -n 3p | awk '{print $2}')
before=$(echo "$certbefore" |base64 -di |openssl x509 -enddate -noout)
echo ""
echo expired date Before: $before
echo ""
##### re cert #####
echo "Re cert..."
docker exec -i rancher sh -c "rm -rf /var/lib/rancher/k3s/server/tls/dynamic-cert.json"
docker exec -i rancher sh -c "k3s kubectl --insecure-skip-tls-verify  delete secrets -n kube-system k3s-serving"
docker exec -i rancher sh -c "k3s kubectl --insecure-skip-tls-verify  delete secrets -n cattle-system serving-cert"
echo "Restart rancher container"
docker restart rancher
echo ""
sleep 10s

##### check cert after #####
certafter=$(docker exec rancher kubectl get secret k3s-serving -n kube-system  -o yaml | sed -n 3p | awk '{print $2}')
after=$(echo $certafter |base64 -di |openssl x509 -enddate -noout)
echo expired date After: $after
echo ""
##### alert ms team #####
data=$(cat << EOM
<b>Customer</b>: <b><font color="blue">$customer</font></b> \n 
<b>expired date Before</b>: $before \n 
<b>expired date After</b>: $after
EOM
)

curl -H 'Content-Type: application/json' -d "{'text': '$data'}" https://ols814.webhook.office.com/webhookb2/b4db8132-5470-4a62-b55f-0a8c3b23b29a@df34c379-284d-4cfb-a68c-c9b22adbc90c/IncomingWebhook/6e38ce337c864dfc9e8a9de4cd36f632/5b168bd2-0720-4067-a287-dcf536fff8d3
