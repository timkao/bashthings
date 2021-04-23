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
  if cd ${dirname:?"missing directory name"}
  then
    DIR_STACK="$dirname ${DIR_STACK:-$PWD }"
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

  if [ -n "$DIR_NAME" ]
  then
    DIR_STACK=${DIR_NAME#* }
    cd ${DIR_NAME%% *}
    echo "$PWD"
  else
    echo "Stack empty, still in $PWD"
}
