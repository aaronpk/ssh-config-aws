# Source this from your .bash_profile

_ssh_servers()
{
  local search CDIR
  if [[ $2 == "" ]]; then
    # Return all Host entries when no partial argument specified for "ssh"
    search="\w"
  else
    # Grep for matching entries based on whatever partial argument is entered
    search=$2
  fi
  CDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  COMPREPLY=( $(grep -h "^Host $search" $CDIR/ssh/*.sshconfig | cut -d " " -f 2) )
}

complete -F _ssh_servers ssh
