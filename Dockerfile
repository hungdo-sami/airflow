# Sử dụng image chính thức của Airflow
FROM apache/airflow:2.10.5

# Cài đặt Java và curl (nếu cần thiết cho Spark hoặc ứng dụng khác)
USER root
RUN apt-get update && \
    apt-get install -y default-jdk curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Thiết lập biến môi trường cho Java (nếu bạn sử dụng Spark hoặc cần Java)
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Tạo thư mục /home/airflow/.ivy2 và cấp quyền truy cập 777
RUN mkdir -p /home/airflow/.ivy2 && \
    chmod -R 777 /home/airflow/.ivy2

# Chuyển về user airflow để cài đặt Python packages
USER airflow

# Copy danh sách thư viện trước khi cài đặt để tận dụng cache
COPY requirements.txt /tmp/requirements.txt

# Cài đặt các thư viện cần thiết
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r /tmp/requirements.txt
