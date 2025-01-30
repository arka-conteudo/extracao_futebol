# Usa a imagem oficial do Python
FROM python:3.12-slim

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Instala dependências do sistema, incluindo Git e bibliotecas necessárias para o Playwright
RUN apt-get update && apt-get install -y \
    git libpq-dev gcc curl unzip && \
    rm -rf /var/lib/apt/lists/*


RUN apt update && apt install -y \
    libnss3 \
    libatk-bridge2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libasound2 \
    xvfb

    
# Atualiza pip, setuptools e wheel antes da instalação
RUN pip install --upgrade pip setuptools wheel

# Copia o arquivo de dependências antes para aproveitar cache
COPY ./requirements.txt /app/ 

# Instala as dependências do projeto
RUN pip install --no-cache-dir -r requirements.txt

# Instala Playwright e baixa os navegadores necessários
RUN pip install playwright
RUN playwright install --with-deps

# Copia todo o código do projeto
COPY . .

# Expõe a porta 8000 para o Django
EXPOSE 8000

# Comando padrão para rodar a aplicação
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "futebol.wsgi:application"]
