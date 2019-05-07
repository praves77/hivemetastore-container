FROM centos:centos7.5.1804 as builder

ENV HADOOP_VER 3.1.1
ENV HIVE_VER 3.1.1

WORKDIR /opt

# Get Hive and Hadoop.
RUN curl http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz | tar -zx && \
    curl http://apache.claz.org/hive/hive-${HIVE_VER}/apache-hive-${HIVE_VER}-bin.tar.gz | tar -zx && \
    ln -s hadoop-${HADOOP_VER} hadoop && \
    ln -s apache-hive-${HIVE_VER}-bin hive

FROM centos:centos7.5.1804

RUN yum -y install java-1.8.0-openjdk which

ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
ENV HIVE_HOME /opt/hive
ENV HADOOP_HOME /opt/hadoop

COPY --from=builder ${HIVE_HOME} ${HIVE_HOME}/
COPY --from=builder ${HADOOP_HOME} ${HADOOP_HOME}/

# ADD jars/hadoop-aws-2.8.5.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-core-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-kms-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-s3-1.11.414.jar /opt/hive/lib/
# ADD jars/*.jar /opt/hive/lib/

ENTRYPOINT [ "/opt/hive/bin/hive" ]
CMD [ "--service", "metastore" ]