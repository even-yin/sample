#!/usr/bin/env bash
function get_current_branch() {
  current_local_branch=`git symbolic-ref --short -q HEAD`;
}

function exe_cmd() {
    local curr_cmd=$1;
    echo "执行命令: $curr_cmd"
    $curr_cmd
    local curr_cmd_result=$?
    if [ $curr_cmd_result -ne 0 ];then
        echo "执行命令: $curr_cmd 失败"
        exit
    fi
}

origin_prefix="origin "
get_current_branch
if [ $current_local_branch ]; then
  echo "当前本地分支: $current_local_branch"
else
  echo '当前不在git版本中'
  exit
fi

current_origin_branch="$origin_prefix$current_local_branch"
echo "当前远程分支: $current_origin_branch"

cmd_git_fetch_current="git fetch $current_origin_branch"
cmd_git_pull_current="git pull $current_origin_branch"

exe_cmd "$cmd_git_fetch_current"

current_local_commit_id=`git rev-parse --short HEAD`
echo "当前本地分支commitId: $current_local_commit_id"
current_origin_commit_id=`git rev-parse --short origin/HEAD`
echo "当前远程分支commitId: $current_origin_commit_id"
nedd_pull=false
if [ "$current_local_commit_id" != "$current_origin_commit_id" ];then
    echo "本地分支[$current_local_branch]commitId:[$current_local_commit_id]和远程分支[$current_origin_branch]commitId:[$current_origin_commit_id]不一致"
    nedd_pull=true
fi

exe_cmd "$cmd_git_pull_current"