# TODO if have uncommit, warn and stop......

local_name=`whoami`_local

sync_remote=sync_remote

alias ggit="git -c diff.mnemonicprefix=false -c core.quotepath=false -c credential.helper=sourcetree"

#cd app-acev2/

# del sync_remote
ggit branch -D $sync_remote

# checkout remote to sync_remote
ggit checkout -b $sync_remote --track origin/dev 

# switch to it
ggit checkout -f $sync_remote

# sync $local_name to $sync_remote
ggit merge --no-edit --log $local_name

# commit
ggit commit -m "auto commit"

# push it to remote(:dev)
ggit push -v --set-upstream origin refs/heads/$sync_remote:refs/heads/dev 

# switch to previous one
ggit checkout -f $local_name

# delete the $sync_remote
ggit branch -D $sync_remote

# let $sync_remote to most update {

ggit fetch origin 

ggit pull --no-commit --log origin dev 

ggit submodule update --init --recursive 

# let $sync_remote to most update }




