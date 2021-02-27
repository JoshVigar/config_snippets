alias d='docker'
alias dc='docker-compose'
alias dclogs='docker-compose logs -f --tail 10'
alias dclean='docker rmi $(docker images -a --filter=dangling=true -q) && docker rm $(docker ps -- filter=status=exited --filter=status=created -q)'

# Reset any container matching the term
dreset () {
  docker restart $(docker ps | grep "$1" -m   1 | awk '{print $1}')
}

export RED='\033[0;31m'
export NOCOLOR='\033[0m'
export GREEN='\033[0;32m'

# Attach to the first container matching the pattern provided in any
# docker-compose file in ~/src.
dattach() {
  if [ $# -eq 0 ]; then
    # Find first line idented by 2 spaces, assign as variable.
    container_search=$(grep -m 1 "  " docker-compose.yml | head -1)
    container_search_no_lead="$(echo -e "${container_search//:}" | sed -e 's/^[[:space:]]*//')"
    container_name=$(docker ps | grep -o "\w*${container_search_no_lead}\w*")
    # Strip out the colon (it's YAML!)
    container_name=$(echo "${container_name//:}")
    echo -e ${GREEN}"Starting container: $container_name in ."${NOCOLOR}
    docker attach $container_name        
  fi 
}

# Exec into the first container matching the pattern provided in any
# docker-compose file in ~/src.
# e.g. dcexec accounts.student
# Or supply no argument and bash into the first container matched in .
dcexec() {
  if [ $# -eq 0 ]; then
    # Find first line idented by 2 spaces, assign as variable.
    container_name=$(grep -m 1 "  " docker-compose.yml | head -1)
    # Strip out the colon (it's YAML!)
    container_name=$(echo "${container_name//:}")
    echo -e ${GREEN}"Starting container: $container_name in ."${NOCOLOR}
    docker-compose exec $container_name bash        
  else 
    # Find all path/to/docker-compose.yaml within $HOME/src excluding
    # node_modules folders.
    for FILE in `find $HOME/src/ -name docker-compose.yml ! -path "*/node_modules/*" 2>/dev/null`; do
      # Find first line idented by only 2 spaces, that contains anything
      # then the arg, then assign as variable. 
      container_name=$(grep -m 1 "^  [^ ]*$1" $FILE | head -1)
      # Next file if no container found.
      if ! [ -z "$container_name" ]; then
        # Strip out the colon (it's YAML!)
        container_name=$(echo "${container_name//:}")
        dir=$(dirname "${FILE}")
        echo -e ${GREEN}"Starting container: $container_name in $dir"${NOCOLOR}
        # navigate to the dir containing the docker-compose.yaml
        cd $dir
        sb start .
        wait 1
        docker-compose exec $container_name bash
        break
      fi
    done
    # Tell user if not found.
    if [ -z "$container_name" ]; then
      echo -e ${RED}"No container defined in a docker-compose.yml found matching $1"${NOCOLOR}
    fi
  fi 
}

