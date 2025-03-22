print("Enabling Ingress and MetalLB addons...")
local("minikube addons enable ingress")
local("minikube addons enable metallb")

print("Configuring MetalLB...")
minikube_ip = str(local("minikube ip")).strip()
print("Minikube IP: " + minikube_ip)

# Extract network base from IP to create a network range
minikube_network_prefix = ".".join(minikube_ip.split(".")[:3])
minikube_network_range = minikube_ip + "-{0}.255".format(minikube_network_prefix)

print(minikube_network_range)

#Construct the MetalLB ConfigMap content directly in the shell command
metallb_config = """
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - {network_range}
""".format(network_range=minikube_network_range)

# Using a shell command to write config and apply it directly
local('echo "{content}" | kubectl apply -f -'.format(content=metallb_config))



# ISTIO
# install istio default profile and enable
local("istioctl install --set profile=minimal -y")
local("kubectl label namespace default istio-injection=enabled")

# Application
local("kubectl apply -k ./kustomize/")

k8s_resource('jaeger', port_forwards=16686)
k8s_resource('prometheus', port_forwards=9090)
