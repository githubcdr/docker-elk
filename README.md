# Elasticsearch, Logstash and Kibana 5.5.1

This is a small container at only 300Mb compressed, running a full functional ELK 5 stack.

## Important

Make sure your docker hosts has the folowing sysctl setting, this is required for ELK

insert in /etc/sysctl.conf

```
vm.max_map_count = 262144
```

or run

```
sysctl -w vm.max_map_count=262144
```

## Features

* filebeat support
* cisco syslog support
* yum.log support via filebeat
* nginx accesslogs support
* updated upstream grok patterns
* running on Alpine Linux with s6, small, clean and efficient
* Maxmind geo data enabled
* Each process runs as own user
* multi input index is created based on type
* docker HEALTHCHECK for elasticsearch

## Instructions

Start the container

```
docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 \
  -v /var/lib/elasticsearch:/var/lib/elasticsearch \
  --name elk \
  cdrocker/elk5:latest
```

Check progress with

```
docker logs -f elk
```

You can now open kibana http://elasticsearchhost:5601

There will probably be no index patterns, you'll have to import them manually. For beats you can use the new import_dashboards script which automate this process. (Install filebeat for this functionality.)

```
/usr/share/filebeat/scripts/import_dashboards -es http://<elasticsearch>:9200
/usr/share/metricbeat/scripts/import_dashboards -es http://<elasticsearch>:9200
/usr/share/packetbeat/scripts/import_dashboards -es http://<elasticsearch>:9200
```

## Todo

* Add java environment options
* autoupdate GEO data
* curator install
* auto cleanup of old indices
* elasticsearch plugins
