FROM alpine:latest
MAINTAINER me codar nl

ENV ES_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.0.tar.gz"
ENV LS_URL="https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.tar.gz"
ENV  K_URL="https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz"
#ENV BEATSDASHBOARD_URL="https://artifacts.elastic.co/downloads/beats/beats-dashboards/beats-dashboards-5.0.0.zip"
#ENV GEOAS_URL="http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz"
ENV GEOCITY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz"

WORKDIR	/tmp

# add files, this also creates the layout for the filesystem
COPY files/root/ /

# todo remove bash
RUN apk add --update --no-cache s6 ca-certificates openjdk8-jre-base wget unzip git tar bash nodejs

# fixups and permissions
RUN	   mkdir /opt /opt/logstash /opt/elasticsearch /opt/kibana /opt/logstash/patterns /opt/logstash/databases \
	&& adduser -D -h /opt/elasticsearch elasticsearch \
	&& adduser -D -h /opt/logstash logstash \
	&& adduser -D -h /opt/kibana kibana \
	&& wget -q $ES_URL -O elasticsearch.tar.gz \
	&& wget -q $LS_URL -O logstash.tar.gz \
	&& wget -q  $K_URL -O kibana.tar.gz \
	# && wget -q $BEATSDASHBOARD_URL -O dashboards.zip \
	# && wget -q $GEOAS_URL -O geoip.gz \
	&& wget -q $GEOCITY_URL -O geocity.gz \
	&& tar -zxf elasticsearch.tar.gz --strip-components=1 -C /opt/elasticsearch \
	&& tar -zxf logstash.tar.gz --strip-components=1 -C /opt/logstash \
	&& tar -zxf kibana.tar.gz --strip-components=1 -C /opt/kibana \
	&& gunzip -c geocity.gz > /opt/logstash/databases/GeoLiteCity.dat \
	&& git clone https://github.com/logstash-plugins/logstash-patterns-core.git \
	&& cp -a logstash-patterns-core/patterns/* /opt/logstash/patterns/

# fixups
RUN	   chmod +x /service/*/run \
	&& /opt/logstash/bin/logstash-plugin install logstash-input-beats \
	&& chown -R elasticsearch:elasticsearch /opt/elasticsearch \
	&& chown -R kibana:kibana /opt/kibana \
	&& chown -R logstash:logstash /opt/logstash \
	&& echo "network.host: 0.0.0.0" >> /opt/elasticsearch/config/elasticsearch.yml \
	&& echo "server.host: 0.0.0.0" >> /opt/kibana/config/kibana.yml \
	&& rm -rf /tmp/*

# ready to run, expose web and mqtt
EXPOSE 5601/tcp 9200/tcp 9300/tcp 5044/tcp

# manage with s6
ENTRYPOINT ["/bin/s6-svscan","/service"]
