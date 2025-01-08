#!/bin/bash

# Backup directory
BACKUP_DIR=/Users/thetoine/Sites/docker-mysql-backups/mysql_backups
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# echo current date
echo "============================="
echo "Starting backup at $DATE"
echo "============================="

# Iterate over all Docker volumes
/usr/local/bin/docker volume ls --format "{{.Name}}" | while read -r volume; do
    # Check if volume name ends with '_db'
    if [[ $volume == *_db ]]; then
        # Find the container using this volume
        CONTAINER_NAME=$(/usr/local/bin/docker ps --filter volume=$volume --format "{{.Names}}")

        if [ -z "$CONTAINER_NAME" ]; then
            echo "No running container found for volume $volume, skipping..."
            continue
        fi

        # # Set MySQL credentials (replace with your defaults)
        DB_NAME="wordpress"
        DB_USER="root"
        DB_PASSWORD="root"

        # # Perform the backup
        echo "Backing up database: $DB_NAME from container: $CONTAINER_NAME"
        /usr/local/bin/docker exec $CONTAINER_NAME /usr/bin/mariadb-dump -u $DB_USER --password=$DB_PASSWORD $DB_NAME > $BACKUP_DIR/${CONTAINER_NAME}_backup_$DATE.sql

        if [ $? -eq 0 ]; then
            echo "Backup for $DB_NAME completed successfully."
        else
            echo "Backup for $DB_NAME failed!"
        fi
    fi
done

# Optional: Remove backups older than 7 days
# find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;

echo "All backups completed and stored in $BACKUP_DIR."