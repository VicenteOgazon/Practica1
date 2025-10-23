FROM python:3.12-slim

WORKDIR /app

COPY dev_env/requirements.txt .

# Instalar curl (necesario para healthcheck)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

#USER default

CMD ["flask", "run"]