#!/bin/bash

# Cập nhật package list
sudo apt update

# Cài đặt các dependencies
sudo apt install -y python3-pip postgresql postgresql-contrib libpq-dev python3-dev

# Khởi động và enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Tạo user và database cho Airflow
sudo -u postgres psql -c "CREATE DATABASE airflow;"
sudo -u postgres psql -c "CREATE USER airflow WITH PASSWORD 'airflow';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;"

# Tạo virtual environment
sudo apt install -y python3-venv
mkdir ~/airflow
cd ~/airflow
python3 -m venv airflow-env
source airflow-env/bin/activate

# Cài đặt Airflow với các extras
pip install "apache-airflow[postgres,celery,redis]==2.7.1" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.7.1/constraints-3.8.txt"

# Thiết lập biến môi trường
export AIRFLOW_HOME=~/airflow

# Khởi tạo cấu hình Airflow
airflow config get-value core executor

# Khởi tạo database
airflow db init

# Tạo user admin
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin

# Tạo file service cho Airflow Webserver
sudo tee /etc/systemd/system/airflow-webserver.service <<EOF
[Unit]
Description=Airflow webserver daemon
After=network.target postgresql.service

[Service]
Environment="AIRFLOW_HOME=/home/$(whoami)/airflow"
Environment="PATH=/home/$(whoami)/airflow/airflow-env/bin:\$PATH"
User=$(whoami)
Group=$(whoami)
Type=simple
ExecStart=/home/$(whoami)/airflow/airflow-env/bin/airflow webserver
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Tạo file service cho Airflow Scheduler
sudo tee /etc/systemd/system/airflow-scheduler.service <<EOF
[Unit]
Description=Airflow scheduler daemon
After=network.target postgresql.service

[Service]
Environment="AIRFLOW_HOME=/home/$(whoami)/airflow"
Environment="PATH=/home/$(whoami)/airflow/airflow-env/bin:\$PATH"
User=$(whoami)
Group=$(whoami)
Type=simple
ExecStart=/home/$(whoami)/airflow/airflow-env/bin/airflow scheduler
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Start và enable các services
sudo systemctl start airflow-webserver
sudo systemctl enable airflow-webserver
sudo systemctl start airflow-scheduler
sudo systemctl enable airflow-scheduler
