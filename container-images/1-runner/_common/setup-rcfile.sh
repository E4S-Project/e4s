#!/bin/bash -e

## Helpers
. utilities.sh

. /etc/os-release
if [[ $ID == "ubuntu" ]] ; then
  sys_rcfile=/etc/bash.bashrc
elif [[ $ID == "rocky" ]] ; then
  sys_rcfile=/etc/bashrc
else
  _err ERROR: cannot determine system rcfile from os-release
  exit 1
fi

mkdir -p /etc/rcfiles
rcfile=/etc/rcfiles/runner.sh
touch $rcfile
chmod +x $rcfile

if [[ $(arch) != "ppc64le" ]]; then
  require_env PYTHON_PATH PYTHON_VERSION
  echo export PATH=$PYTHON_PATH/pkgs/python-$PYTHON_VERSION/bin:'$PATH' > $rcfile
fi

if [[ $VERSION_ID == "26.04" ]]; then
  echo . /etc/profile.d/modules.sh >> $rcfile
else
  require_env TOOLS_PATH

  module_init="$(find $TOOLS_PATH -type f -path "*environment-modules*/init/bash")"
  if is_empty module_init ; then
    _err "error: could not find module init file"
    exit 1
  fi
  
  module_initrc=$(find $TOOLS_PATH -type f -path "*environment-modules*/etc/initrc")
  if is_empty module_initrc ; then
    _err "error: could not find module initrc file"
    exit 1
  fi

  sed -i '/append/d' $module_initrc

  echo export PATH=$TOOLS_PATH/view/bin:'$PATH' >> $rcfile
  echo . $module_init >> $rcfile
fi

if [[ $ID == "rocky" ]]; then
  echo source scl_source enable gcc-toolset-13 >> $rcfile
fi
chmod +x $rcfile

cat <<EOF >>$sys_rcfile
. $rcfile
EOF