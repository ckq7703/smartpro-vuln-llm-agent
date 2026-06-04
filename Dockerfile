FROM python:3.12-slim

WORKDIR /app

ENV PYTHONPATH=/app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install python-dotenv

COPY . /app/
RUN pip3 install -r requirements.txt

COPY config/config.toml /root/.streamlit/config.toml

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "app/main.py", "--server.port=8501", "--server.address=0.0.0.0"]