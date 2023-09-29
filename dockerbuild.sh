docker build -t buildroot .
docker run -it -v $SSH_AUTH_SOCK:/ssh-agent:Z -e SSH_AUTH_SOCK=/ssh-agent -v ~/.polysat_fsw.auth:/root/.polysat_fsw.auth:Z -v $PWD/..:$PWD/..:Z buildroot make -C $PWD V=1
