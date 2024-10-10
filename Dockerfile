FROM apache/airflow:2.10.2

USER root

# Cài đặt Java và curl
RUN apt-get update && \
    apt-get install -y default-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Sử dụng Spark từ Bitnami
COPY --from=bitnami/spark:3.5.3 /opt/bitnami/spark /opt/spark

# Thiết lập biến môi trường
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin

# Chuyển về user airflow để cài đặt Python packages
USER airflow

# Cài đặt Spark provider
RUN pip install apache-airflow-providers-apache-spark
