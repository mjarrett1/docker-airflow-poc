from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
import os
from datetime import datetime, timedelta

DAG_NAME = "msj_bash_run_python_script"
PYTHON_SCRIPTS_FOLDER = "/opt/bitnami/airflow/dags/scripts"
PYTHON_SCRIPT_NAME = "hello_world.py"

with DAG(
    dag_id=DAG_NAME,
    schedule="0 0 * * *",
    start_date=datetime.now(),
    catchup=False,
    dagrun_timeout=timedelta(minutes=60),
    tags=[DAG_NAME],
    params={"example_key": "example_value"}
) as dag:
    run_python_task = BashOperator(
    task_id='run_python_script',
    bash_command=f"python3 {os.path.join(PYTHON_SCRIPTS_FOLDER,PYTHON_SCRIPT_NAME)}",
    dag=dag)

run_python_task