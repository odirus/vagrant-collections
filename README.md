# vagrant-collections

通过 vagrant 快速搭建集成环境；

Q：为什么选择 Vagrant ？  
A：某些场景下，使用Vagrant效果会更好，目前想到了以下方面内容：
1. Vagrant 是辅助我们管理虚拟机的工具，通过虚拟机可以模拟更加真实的环境；
2. 除Linux外，Windows、MacOS下Docker也是建立在虚拟机基础上的，从性能角度来说用Docker没有明显的收益；

Q：为什么要有这个项目？  
A：笔者在工作中需要调研K8S、Istio等技术细节，为了能够在本地启动，依次体验了Docker Desktop、Kind、K3S、minikube等，但或多或少都遇到了一些问题，有些是网络上、有些是功能完整性上，因此才决定基于“Vagrant+虚拟机”来搭建一套更加接近实战的环境。
