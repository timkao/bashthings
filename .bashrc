export HISTCONTROL=erasedups:ignorespace
export HISTTIMEFORMAT="%y%m%d %T  "

DIR_STACK=""
export DIR_STACK

function alic {
  echo "alice: $@"
  echo "alice: $2 $3 $1"
  echo "$# arguments"
}

function pushe {
  dirname=$1
  if [ -n "$dirname" ] && [ \( -d "$dirname" \) -a  \( -x "$dirname" \) ]; then
    cd $dirname
    DIR_NAME="$dirname ${DIR_STACK:-$PWD' '}"
    echo $DIR_STACK
  else
    echo "still in $PWD"
  fi
}


function cd {
  builtin cd "$@"
  endStatus=$?
  echo "$OLDPWD -> $PWD"
  return $endStatus
}

function pope {
  if [ -n "$DIR_STACK" ]; then
    DIR_STACK=${DIR_STACK#* }
    cd ${DIR_STACK%% *}
    echo "$PWD"
  else
    echo "Stack empty, still in $PWD"
  fi
}

function fileInfo {
  if [ ! -e "$1" ]; then
    echo "file $1 does not exist"
  else
    echo "file $1 exists"
  fi
}
