# Usa a imagem do Python
FROM python:3.12-slim

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    git libpq-dev gcc curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Instala as dependências do Python
COPY ./requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Instala o Gunicorn
RUN pip install gunicorn

# Copia o código do projeto
COPY . .

# Coleta arquivos estáticos
RUN python manage.py collectstatic --noinput

# Expõe a porta 8000
EXPOSE 8000

# Inicia o servidor Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "futebol.wsgi:application"]
