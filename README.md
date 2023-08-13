# ELK集群部署
> 8.2.2版本

## 环境要求

* 所有机器使用Centos7 mini 5.15内核纯净环境
* es所有节点必须单独挂载/app/data目录,或者准备一块未使用的磁盘,脚本会自动挂载,盘符通过[hosts](./hosts)文件配置
* 如果已经部署了es集群, 后期接入本脚本,需要手动写入`elastic`用户密码到 `./data/elastic.pass`文件中
* 如果已经部署了es集群, 后期接入本脚本,需要手动拷贝es集群内部通信tls证书文件`/etc/elasticsearch/elastic-certificates.p12`为`./data/elastic-certificates.p12`

## Feature

- [x] Elasticsearch冷热节点分离集群部署及维护, 多client节点 + keepalived 提供高可用集群入口
- [x] ES集群默认安装`analysis-ik`分词插件
- [x] Logstash多节点多pipline部署及配置, 动态配置pipline应对不同负载情况, haproxy代理多个pipline后端,实现负载均衡
- [x] Kibana多节点部署, keepalived 高可用
- [x] metricbeat多节点部署
- [x] 支持初始化机器全新部署
- [x] 支持已部署集群接入后期维护配置

## TODO
- [ ] 支持初始化ES Cluster配置
- [ ] 接管日志索引生命周期配置
- [ ] 接管elasticsearch exporter安装与配置

## 使用

1. 初始化
```bash
ansible-playbook -i hosts roles/init.yaml
```

2. es集群更新/部署
```bash
ansible-playbook -i hosts roles/es.yaml
```

新部署集群会生产elastic及kibana_system用户随机密码,分别保存为:
> ./data/elastic.pass
>
> ./data/kibana_system.pass


3. logstash集群更新/部署
```bash
ansible-playbook -i hosts roles/logstash.yaml
```

4. metricbeat集群更新/部署
```bash
ansible-playbook -i hosts roles/metricbeat.yaml
```

5. kibana更新/部署
```bash
ansible-playbook -i hosts roles/kibana.yaml
```

6. 集群高可用更新/部署
```bash
ansible-playbook -i hosts roles/lb.yaml
```

## 集群验证
```bash
ESVIP="192.168.1.200"
ESPASS=$(cat ./data/elastic.pass)
curl -u elastic:${ESPASS} http://${ESVIP}:9200/_cat/nodes
curl -u elastic:${ESPASS} http://${ESVIP}:9200/_cluster/health
```
