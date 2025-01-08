# Docker MySQL automated cronjob daily backup tool

Note: this tool will only backup from running containers.

## How to use

First, make sure your docker-volume-backup.sh file is executable :

```bash
chmod +x docker-volume-backup.sh
```

Then add an entry to your user's cron :

```bash
crontab -e
```

This will run the script every day at 10AM.

```
0 10 * * * /Users/[CHANGE-ME]/docker-mysql-backups/docker-volume-backup.sh >> /Users/[CHANGE-ME]/docker-mysql-backups/backup.log 2>&1
```