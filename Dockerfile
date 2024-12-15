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
RUN pip install \
    apache-airflow-providers-apache-spark \
    orjson \
    delta-spark==3.2.1 \
    gcloud==0.18.3 \
    gcsfs==2024.9.0.post1 \
    google-api-core==2.21.0 \
    google-api-python-client==2.149.0 \
    google-auth==2.35.0 \
    google-auth-httplib2==0.2.0 \
    google-auth-oauthlib==1.2.1 \
    google-cloud-bigquery==3.26.0 \
    google-cloud-core==2.4.1 \
    google-cloud-storage==2.18.2 \
    google-crc32c==1.6.0 \
    google-re2==1.1.20240702 \
    google-resumable-media==2.7.2 \
    googleapis-common-protos==1.65.0 \
    requests-toolbelt==1.0.0



