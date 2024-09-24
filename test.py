from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

# Định nghĩa hàm Python mà task sẽ thực hiện
def hello_airflow():
    print("Hello, Airflow!")
#ABJDSDJ
# Định nghĩa DAG
with DAG(
    'simple_hello_airflow_dag',   # Tên DAG
    default_args={
        'owner': 'airflow',
        'start_date': datetime(2024, 9, 24),  # Thời gian bắt đầu
        'retries': 1,  # Số lần retry nếu task fail
    },
    schedule='@daily',   # Lịch chạy hàng ngày
    catchup=False,                # Không thực hiện các task trong quá khứ
) as dag:

    # Định nghĩa task
    hello_task = PythonOperator(
        task_id='hello_task',       # Tên của task
        python_callable=hello_airflow,  # Hàm Python sẽ chạy
    )

# Chạy DAG
hello_task
