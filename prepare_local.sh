#!/usr/bin/env sh

PROJECTS=$1
BUILDER=$2

if
  [[ -z "$PROJECTS" || -z "$BUILDER" ]]
then
  printf "Use\n  $0 /path/to/projects /path/to/installbuilder\n"
  exit 1
fi

[[ -d "$PROJECTS" ]] || mkdir -p "$PROJECTS"

pushd $PROJECTS >/dev/null
for project in sm/sm wayneeseguin/rvm railsinstaller/railsinstaller-nix
do
  dir=${project#*/}
  if
    [[ -d $dir ]]
  then
    printf -- "-- updating $dir :\n"
    pushd $dir >/dev/null
    git pull
    popd >/dev/null
  else
    git clone git@github.com:$project.git
  fi
done
popd >/dev/null

printf -- "-- paths in /etc/rixrc :\n"
printf "\
export sm_local_path=$PROJECTS/sm\n\
export rvm_local_path=$PROJECTS/rvm\n\
export installbuilder_path=$BUILDER\n\
" | sudo tee /etc/rixrc
