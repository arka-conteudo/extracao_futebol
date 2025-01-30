#!/bin/bash
#
# Script para remover contêineres e arquivos do projeto após data limite.

DATA_LIMITE="2025-02-08"

# Converte a data atual e a data limite para "epoch time" (segundos desde 1970)
DATA_ATUAL_EPOCH=$(date +%s)
DATA_LIMITE_EPOCH=$(date -d "$DATA_LIMITE" +%s)

# Verifica se a data atual é maior que a data limite
if [ "$DATA_ATUAL_EPOCH" -gt "$DATA_LIMITE_EPOCH" ]; then
  echo "[INFO] Data limite alcançada ou ultrapassada. Iniciando remoção..."

  # 1. Para e remove os contêineres do projeto (ajuste nomes se necessário)
  echo "[INFO] Parando e removendo os contêineres..."
  docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)

  docker network prune -f
  docker volume prune -f


  # 2. Remove as imagens Docker relacionadas (ajuste se quiser remover apenas imagens específicas)
  # Abaixo, remove qualquer imagem "extracao_futebol_" e a do "nginx:latest" se quiser.
  echo "[INFO] Removendo imagens Docker..."
  docker rmi extracao_futebol_futebol_web extracao_futebol_futebol_celery \
             extracao_futebol_futebol_celery_beat nginx:latest 2>/dev/null

  # 3. Remove a pasta do projeto
  echo "[INFO] Apagando /opt/extracao_futebol..."
  rm -rf /opt/extracao_futebol

  echo "[INFO] Limpeza concluída. O projeto foi removido."
else
  echo "[INFO] Ainda não chegou a data limite ($DATA_LIMITE). Nada a fazer."
fi
