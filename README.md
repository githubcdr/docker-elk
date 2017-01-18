# Elasticsearch, Logstash and Kibana 5.1.2

This is a small container at only 300Mb compressed, running a full functional ELK 5.0 stack.

## Features

* filebeat support
* cisco syslog support, with grok filter
* updated upstream grok patterns
* yum.log input via filebeat
* running on Alpine Linux with s6, small, clean and efficient
* Maxmind geo data enabled
* Each process runs as own user

## Instructions

Start the container

```
docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 -v /var/lib/elasticsearch:/var/lib/elasticsearch --name elk cdrocker/elk5:latest
```

Check progress with

```
docker logs -f elk
```

You can now open kibana

http://elasticsearchhost:5601

There will probably be no index patterns, you'll have to import them manually. For beats you can use the new import_dashboards script which automate this process. (Install filebeat for this functionality.)

```
/usr/share/filebeat/scripts/import_dashboards -es http://<elasticsearch>:9200
/usr/share/metricbeat/scripts/import_dashboards -es http://<elasticsearch>:9200
/usr/share/packetbeat/scripts/import_dashboards -es http://<elasticsearch>:9200
```

## Todo

* Add java environment options
* autoupdate GEO data
* logging
* curator install
* auto cleanup of old indices
* proxy with authentication
* elasticsearch plugins
