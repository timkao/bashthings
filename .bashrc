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
    exit 1
  fi

  if [ -d "$1" ]; then
    echo -n "$1 is a directory that you may "
    if [ ! -x "$1" ]; then
      echo -n "not "
    fi
    echo "seearch."
  elif [ -f "$1" ]; then
    echo "$1 is a regular file"
  else
    echo "$1 is a special type of file."
  fi

  if [ -O "$1" ]; then
    echo "you own the file."
  else
    echo "you do not own the file"
  fi

  if [ -r "$1" ]; then
    echo "you have read permission"
  fi

  if [ -w "$1" ]; then
    echo "you have write permission"
  fi

  if [ -x "$1" -a ! -d "$1" ]; then
    echo "you gave execution permission"
  fi
}

function showPaths {
  # change IFS
  IFS=:
  for dir in $PATH
  do
    ls -ld $dir
  done
}

function displayPaths {
  paths=$PATH

  while [ $paths ]; do
    ls -ld ${paths%%:*}
    paths=${paths#*:}
  done
}

function checkFiles {
  for candidate in "$@"; do
    fileInfo "$candidate"
    echo
  done
}


function traverseDir {
  for file in "$@"; do
    thisfile=$thisfile/$file
    if [ -d "$thisfile" ]; then
      echo -e "$partition$dashes$file\\"
      partition="$partition$singletab|"
      echo -e $partition
      traverseDir $(command ls $thisfile)
      echo -e $partition
    elif ! [ -d "$thisfile" ]; then
      echo -e "$partition$dashes$file"
    fi
    thisfile=${thisfile%/*}
  done
  partition=${partition%"$singletab|"}
}

function makeDirTree {
  dashes="-------"
  partition="|"
  singletab="\t"
  for tryfile in "$@"; do
    if [ -d "$tryfile" ]; then
      echo -e "$tryfile\\"
      echo $partition
      thisfile=$tryfile
      traverseDir $(command ls $tryfile)
    elif ! [ -d ${thisfile} ]; then
      echo "$tryfile"
    fi
  done

  unset dir singletab tab
}
