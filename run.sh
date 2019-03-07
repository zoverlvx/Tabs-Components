if [ ! -f server.log ]; then
  touch server.log
fi

if [ ! -f compiler.log ]; then
  touch compiler.log
fi

if [ -f .pids ]; then
  SERVER_PID=$(cat .pids | awk -F '=' '{print $2}'| head -1);
  COMPILER_PID=$(cat .pids | awk -F '=' '{print $2}' | tail -1);
  kill -15 $SERVER_PID
  kill -15 $COMPILER_PID
fi

if [ ! -f .pids ]; then
  touch .pids
fi
 
http-server website/ > server.log 2>&1 &
SERVER_PID=$(ps -eo pid,command | grep "http-server website" | grep -v grep | awk '{print $1}')
less-watch-compiler less/ website/css/ index.less > compiler.log 2>&1 &
COMPILER_PID=$(ps -eo pid,command | grep "less-watch-compiler" | grep -v grep | awk '{print $1}')
echo -e "server=$SERVER_PID\ncompiler=$COMPILER_PID" > .pids
