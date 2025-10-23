FROM python:3.12-slim

WORKDIR /app

COPY app/ .

COPY prod_env/requirements.txt .

# Instalar curl para healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

# Crear usuario no root, solo tiene acceso a /app
RUN adduser --disabled-password newuser
RUN chown -R newuser:newuser /app
USER newuser

CMD ["flask", "run"]