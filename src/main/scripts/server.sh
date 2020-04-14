#!/bin/sh

cd $(dirname $0)
cd ..

PROJECT_NAME=study-nginx
JAR_NAME=study-nginx-1.0.jar

DEPLOY_HOME=$(pwd)
LIB_DIR=$DEPLOY_HOME/lib
LOG_DIR=/app/logs/$PROJECT_NAME

STDOUT_FILE=$LOG_DIR/stdout.%Y-%m-%d.log

#获取pid
get_pid() {
  pid=$(ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}')
  echo "$pid"
}
#启动
start() {
  echo "Starting server ..."
  pid=$(get_pid)
  if [ -n "$pid" ]; then
    echo "ERROR: Server running on $pid"
    exit 0
  fi
  nohup java -jar $LIB_DIR/$JAR_NAME >/dev/null 2>&1 &
  sleep 1
  pid=$(get_pid)
  if [ $? -eq 0 ]; then
    echo "STARTED PID: $pid"
  else
    echo "ERROR: Start failure![code: $?]"
  fi
  exit 0
}
#停止
stop() {
  echo "Stopping server ... "
  pid=$(get_pid)
  if [ -z "$pid" ]; then
    echo "ERROR: No server to stop!"
    return 0
  fi
  #sudo kill $pid
  /usr/bin/sudo kill -9 $pid
  if [ $? -eq 0 ]; then
    echo "STOPPED PID: $pid"
  else
    echo "ERROR: Stop failure![code: $?]"
    exit 0
  fi
}
#查看状态
status() {
  pid=$(get_pid)
  if [ -z "$pid" ]; then
    echo "No server running"
  else
    echo "Running on $pid"
  fi
  exit 0
}

####################
#（★）入口
####################
case $1 in
start)
  start
  ;;
stop)
  stop
  ;;
status)
  status
  ;;
restart)
  pid=$(get_pid)
  if [ -n "$pid" ]; then
    stop

  fi
  start
  ;;
*)
  echo "Usage: $0 {start|stop|restart|status}"
  exit 0
  ;;
esac
