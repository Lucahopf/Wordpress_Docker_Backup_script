#!/bin/bash
# OS: Windows
# Backup-Ordner definieren
backup_dir="/c/Documents/Docker_Backup"

# Stoppen der Docker-Container
docker stop downloads-wordpress-1
docker stop downloads-db-1

# Erstellen des Backup-Ordners, falls er nicht existiert
mkdir -p "$backup_dir/wordpress"
mkdir -p "$backup_dir/database"

# Datum im Format JahrMonat erhalten (z. B. 202403)
date_stamp=$(date +"%Y%m")

# Exportieren der Docker-Volumes und Komprimieren in ZIP-Dateien
docker run --rm \
  -v downloads_wordpress_data:/www/html \
  -v downloads_db_data:/var/lib/mysql \
  -v "$backup_dir/wordpress/$date_stamp":/backup/wordpress \
  -v "$backup_dir/database/$date_stamp":/backup/database \
  alpine \
  sh -c 'cd /backup/wordpress && zip -r docker_volume_backup_$(date +"%Y%m%d").zip /www/html'
docker run --rm \
  -v downloads_wordpress_data:/www/html \
  -v downloads_db_data:/var/lib/mysql \
  -v "$backup_dir/wordpress/$date_stamp":/backup/wordpress \
  -v "$backup_dir/database/$date_stamp":/backup/database \
  alpine \
  sh -c 'cd /backup/database && zip -r docker_volume_backup_$(date +"%Y%m%d").zip /var/lib/mysql'

# Löschen von alten Backups, die älter als 2 Jahre sind
find "$backup_dir/wordpress" -type f -name "*.zip" -mtime +730 -exec rm -f {} \;
find "$backup_dir/database" -type f -name "*.zip" -mtime +730 -exec rm -f {} \;