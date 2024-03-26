# OS: Windows
@echo on
REM OS: Windows (Batch Script)
REM Backup-Ordner definieren
set "backup_dir=C:\Docker_Backup"

REM Stoppen der Docker-Container
docker stop downloads-wordpress-1
docker stop downloads-db-1

REM Erstellen des Backup-Ordners, falls er nicht existiert
mkdir "%backup_dir%"
mkdir "%backup_dir%\wordpress"
mkdir "%backup_dir%\database"

REM Datum im Format JahrMonat erhalten (z. B. 202403)
for /f "tokens=1-3 delims=/" %%a in ('date /t') do (
    set "date_stamp=%%c%%b"
)

REM Exportieren der Docker-Volumes und Komprimieren in ZIP-Dateien
docker run --rm ^
  -v downloads_wordpress_data:/www/html ^
  -v downloads_db_data:/var/lib/mysql ^
  -v "%backup_dir%\wordpress\%date_stamp%":/backup/wordpress ^
  -v "%backup_dir%\database\%date_stamp%":/backup/database ^
  alpine ^
  sh -c "cd /backup/wordpress && zip -r docker_volume_backup_%date:~0,4%%date:~4,2%%date:~6,2%.zip /www/html"
docker run --rm ^
  -v downloads_wordpress_data:/www/html ^
  -v downloads_db_data:/var/lib/mysql ^
  -v "%backup_dir%\wordpress\%date_stamp%":/backup/wordpress ^
  -v "%backup_dir%\database\%date_stamp%":/backup/database ^
  alpine ^
  sh -c "cd /backup/database && zip -r docker_volume_backup_%date:~0,4%%date:~4,2%%date:~6,2%.zip /var/lib/mysql"

REM Löschen von alten Backups, die älter als 2 Jahre sind
forfiles /p "%backup_dir%\wordpress" /m *.zip /d -730 /c "cmd /c del @path"
forfiles /p "%backup_dir%\database" /m *.zip /d -730 /c "cmd /c del @path"