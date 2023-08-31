sudo sed -i 's@/swap.img@#/swap.img@' -i /etc/fstab

KUBERNETES_VERSION="1.24.6-00"
ARCH=$(dpkg --print-architecture)

sudo cp /vagrant/host_configs/sources.list.$ARCH /etc/apt/sources.list
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl wget software-properties-common

sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's@registry.k8s.io/pause:3.8@registry.aliyuncs.com/google_containers/pause:3.8@g' /etc/containerd/config.toml
sudo sed -i 's@SystemdCgroup = false@SystemdCgroup = true@g' /etc/containerd/config.toml
sudo mkdir -p /etc/containerd/certs.d/docker.io
cat <<EOF | sudo tee /etc/containerd/certs.d/docker.io/hosts.toml
server = "docker.io"
[host."https://docker.m.daocloud.io"]
  capabilities = ["pull", "resolve"]
EOF
sudo perl -i -0pe 's/registry\]\n\s+config_path = ""/registry\]\n\      config_path = "\/etc\/containerd\/certs\.d"/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd

sudo install -m 755 /vagrant/host_configs/runc-v1.1.2.$ARCH /usr/local/sbin/runc
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin /vagrant/host_configs/cni-plugins-linux-$ARCH-v1.1.1.tgz

## 关闭 swap 分区
swapoff -a
## 加载 br_netfilter
sudo modprobe br_netfilter
## 配置网络
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

curl -s https://repo.huaweicloud.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubenetes.list
deb https://repo.huaweicloud.com/kubernetes/apt/ kubernetes-xenial main
EOF
sudo apt-get update -y
sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION
sudo apt-mark hold kubelet kubeadm kubectl # 不自动更新

cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF

sudo systemctl start kubelet
sudo systemctl enable kubelet
