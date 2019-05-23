ARG BASE_IMAGE
FROM ${BASE_IMAGE} as builder

ARG HADOOP_VER
ARG HIVE_VER

ARG HADOOP="http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz"
ARG HIVE="https://archive.apache.org/dist/hive/hive-${HIVE_VER}/apache-hive-${HIVE_VER}-bin.tar.gz"

WORKDIR /opt

# Get Hive and Hadoop.
RUN curl ${HADOOP} | tar -zx && \
    curl ${HIVE} | tar -zx && \
    ln -s hadoop-${HADOOP_VER} hadoop && \
    ln -s apache-hive-${HIVE_VER}-bin hive

FROM ${BASE_IMAGE}

# RUN yum -y install java-1.8.0-openjdk which

# ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
ENV HIVE_HOME /opt/hive
ENV HADOOP_HOME /opt/hadoop

COPY --from=builder ${HIVE_HOME} ${HIVE_HOME}/
COPY --from=builder ${HADOOP_HOME} ${HADOOP_HOME}/

# ADD jars/hadoop-aws-2.8.5.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-core-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-kms-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-s3-1.11.414.jar /opt/hive/lib/
ADD jars/*.jar /opt/hive/lib/

ENTRYPOINT [ "/opt/hive/bin/hive" ]
CMD [ "--service", "metastore" ]