#!/bin/bash
export LANG=C;
cd /opt;
tar zxvf elasticsearch-1.5.2.tar.gz;
cd elasticsearch-1.5.2; /opt/elasticsearch-1.5.2/bin/elasticsearch;
sleep 10;
curl 'http://localhost:9200/?pretty';
curl -XPOST 'http://localhost:9200/_shutdown';
####
ElasticConf='/opt/elasticsearch-1.5.2/config/elasticsearch.yml';
sed -i '41 inode.name: "ELK"' ${ElasticConf};
sed -i '169 ipath.logs: /var/log/elasticsearch' ${ElasticConf};
sed -i '170 ipath.data: /var/data/elasticsearch' ${ElasticConf};
/opt/elasticsearch-1.5.2/bin/plugin -install lmenezes/elasticsearch-kopf
/opt/elasticsearch-1.5.2/bin/elasticsearch;
###
cd /opt;
tar zxvf logstash-1.5.0.tar.gz;
ln -s logstash-1.5.0 logstash;
/opt/logstash/bin/logstash -e 'input { stdin { } } output { stdout {} }';
/opt/logstash/bin/logstash -e 'input { stdin { } } output { stdout { codec => rubydebug } }';

### 
cd /opt;
tar -zxvf kibana-4.0.2-linux-x64.tar.gz;
ln -s kibana-4.0.2-linux-x64 kibana;
KibanaConf='/opt/kibana/config/kibana.yml';
sed -i '5 chost: "192.168.1.110"' ${KibanaConf};
sed -i '8 celasticsearch_url: "http://192.168.1.110:9200"' ${KibanaConf};
/opt/kibana/bin/kibana;
