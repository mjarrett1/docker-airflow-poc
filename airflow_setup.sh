#!/bin/sh

# Author : Mason Jarrett
# Script follows here:

# Install Airflow using the constraints file
AIRFLOW_VERSION=2.5.0
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip3 install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Switch to the postgres system account and create the airflow db, user.
service postgresql start

su - postgres <<EOF
psql -c "CREATE DATABASE airflow;"
psql -c "CREATE USER airflow WITH PASSWORD 'airflow';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;"
EOF

# Do the initial airflow DB setup.
# Need to change the airflow.cfg file to point to the postgres DB. sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@localhost:5432/airflow
airflow db init

# Create the admin user to initially log in to airflow.
airflow users create \
          --username airflow \
          --password airflow \
          --firstname Airflow \
          --lastname Admin \
          --role Admin \
          --email admin@example.org

# Start the postgresql service, airflow webserver and scheduler.
# service postgresql start
# airflow webserver -D
# airflow scheduler -D