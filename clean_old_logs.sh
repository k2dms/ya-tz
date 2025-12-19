#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 /path/to/logs N_days"
  echo "Example: $0 /var/log 30"
}

# 5) Если аргументы не переданы — справка
if [ $# -ne 2 ]; then
  usage
  exit 1
fi

LOG_DIR="$1"
DAYS="$2"

# Валидации
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: directory not found: $LOG_DIR"
  exit 1
fi

if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
  echo "Error: N_days must be a non-negative integer."
  usage
  exit 1
fi

# 2) Найти .log старше N дней (mtime +N)
mapfile -t FILES < <(find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS" -print)  # -mtime +N: старше N дней

# 3) Вывести список и запросить подтверждение
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No .log files older than $DAYS days found in: $LOG_DIR"
  exit 0
fi

echo "Found ${#FILES[@]} .log file(s) older than $DAYS days:"
printf '%s\n' "${FILES[@]}"

read -r -p "Удалить эти файлы? (y/n) " answer

case "$answer" in
  y|Y)
    # 4) При y — удалить
    for f in "${FILES[@]}"; do
      rm -f -- "$f"
    done
    echo "Deleted."
    ;;
  n|N)
    echo "Canceled."
    ;;
  *)
    echo "Unknown answer. Canceled."
    exit 1
    ;;
esac
