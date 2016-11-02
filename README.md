# Elasticsearch, Logstash and Kibana 5.0

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

## Todo

* Add java environment options
* autoupdate GEO data
* logging
* curator install
* auto cleanup of old indices
* proxy with authentication
