#!/bin/bash
BACKUP_PATH='/mysql_backup'
LOG_FILE='mysqldump.log'
cd $BACKUP_PATH
DATE_YYYYMMDDHHMMSS=`date '+%Y%m%d%H%M%S'`
dumpsql=$DATE_YYYYMMDDHHMMSS'_dump.sql'
password='PSWD'
DBNAME='DBNM'

echo $DATE_YYYYMMDDHHMMSS ": mysql dump start.." >>  $LOG_FILE
/mysql/giga/instance/bin/mysqldump -uroot -p$password --single-transaction $DBNAME > ./$dumpsql
echo $DATE_YYYYMMDDHHMMSS ': dumpfile : '$dumpsql >>  $LOG_FILE
tar cvzf ./$dumpsql'.tar.gz' ./$dumpsql
rm ./$dumpsql
echo $DATE_YYYYMMDDHHMMSS ': compression file : './$dumpsql'.tar.gz' >>  $LOG_FILE
echo $DATE_YYYYMMDDHHMMSS ": mysql dump stop.." >>  $LOG_FILE

DATE_TODAY=`date '+%s'`
FILES=`find $BACKUP_PATH -maxdepth 1 -type f`

for file in $FILES
do
    FILE_DATE=`date -r $file '+%s'`
    DIFF_DATE=`echo "($DATE_TODAY - $FILE_DATE) / 86400" | bc`
    echo $file " : " $DIFF_DATE
    if [ ${DIFF_DATE} -gt 7]; then
        echo $DATE_YYYYMMDDHHMMSS ": " $file "is deleted." >> $LOG_FILE
        rm -f $file
    fi
done
