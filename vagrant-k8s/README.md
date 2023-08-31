# vagrant-k8s

本项目旨在快速搭建完整的K8S环境，避免在网络、程序版本上浪费时间。同时，由于底层是虚拟机，功能完整性会更高，特别适合问题分析、调研学习。目前支持 arm64（苹果芯片M1、M2为代表）、amd64 等架构。

## amd64 架构安装
使用步骤：
1. 安装 Vagrant，[Install Vagrant](https://developer.hashicorp.com/vagrant/downloads)；
2. 安装 VirtualBox，[Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)，推荐使用；
3. 克隆当前仓库，然后执行 `cd vagrant-k8s && vagrant up` 命令进行启动；

已经通过测试的环境：
1. Ubuntu22.04（Intel芯片）+ VirtualBox7.0.10；

## arm64 架构安装（M1、M2适用）
使用步骤：
1. 安装 VMware Fusion Player 13（可以免费申请license用于非商业用途）；
2. 安装 Vagrant，[Install Vagrant](https://developer.hashicorp.com/vagrant/downloads)；
3. 按照 Vagrant [VMware Installation](https://developer.hashicorp.com/vagrant/docs/providers/vmware/installation) 中的提示安装 Vagrant VMware Utility、vagrant-vmware-desktop；
4. 克隆当前仓库，然后执行 `cd vagrant-k8s && vagrant up` 命令进行启动；

已通过测试的环境：
1. M2芯片 + macOS Ventura；

## 参考链接
+ https://gist.github.com/y0ngb1n/7e8f16af3242c7815e7ca2f0833d3ea6
+ https://gitee.com/bambrow/vagrant-k8s-cluster-cn
