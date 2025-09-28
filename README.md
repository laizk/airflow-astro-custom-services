# airflow-astro-custom-services

Project tree:
```sh
.
├── README.md
└── airflow
    ├── Dockerfile
    ├── README.md
    ├── airflow_settings.yaml
    ├── dags
    │   ├── __pycache__
    │   │   └── exampledag.cpython-312.pyc
    │   └── exampledag.py
    ├── docker-compose.override.yml
    ├── include
    ├── packages.txt
    ├── plugins
    ├── postgres
    │   ├── Dockerfile
    │   └── sql
    │       └── init_db.sql
    ├── requirements.txt
    └── tests
        └── dags
            └── test_dag_example.py
```

Scenario:
1. I am using astro cli to setup airflow. 
2. I wanted to spin up airflow and a separate postgres DB. 
3. For the postgres DB, I wanted to initialize it with a table already created.
4. Initializing a table in postgres when deployed needs a mechanism to run SQL DDL statements which are in a separate Dockerfile. 

Problem:
1. The override file `./airflow/docker-compose.override.yml` doesn't use the custom Dockerfile (`./postgres/Dockerfile`). I've already  properly referenced the Dockerfile through the build context I defined in the docker-compose file.
2. Am I doing it wrongly?
3. Is it even possible to do this using Astro CLI?

Current solution:
1. The only solution I have now is not using the Dockerfile. But rather defining the volume mapping the directory with the SQL statements to the docker entrypoint as defined below.
2. But I still do wanted to know if it is possible and how I can customize images for other services using astro CLI.

```yaml
services:
 
  # Set up another postgres db as per business requirement
  db:
    build:
      context: ../postgres
      dockerfile: Dockerfile
    # image: postgres
    restart: always
    shm_size: 128mb
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: postgres

    # Alternative to using Dockerfile for postgres
     volumes:
       - ../postgres/sql:/docker-entrypoint-initdb.d
    
    ports:
      - "5433:5432"   # expose externally if needed (avoid clashing with Astro's metadata db)

  adminer:
    image: adminer
    restart: always
    ports:
      - "8083:8080"
```
