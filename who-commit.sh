#!/bin/bash

function check() {
    status=$?
    if [ $status -eq 0 ];then
       echo "success $1"
    else
       echo "fail,exi $1"
       exit -1
    fi
}

function check_whoami() {
    brk=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | grep "(\`whoami\`)"`
    if [ ! $brk ]; then
      #git checkout dev
      git branch `whoami` 2>/dev/null
      git checkout `whoami`
      check "#git checkout `whoami`"
    fi
}

function check_modifi() {
    res=`git status | grep -v grep | grep "modified:" | wc -l`
    #echo $res
    if [ $res -eq 0 ]; then
      return 1
    fi
    return 0
}

function check_renamed {
    res=`git status | grep -v grep | grep "renamed:" | wc -l`
    #echo $res
    if [ $res -eq 0 ]; then
      return 1
    fi
    return 0
}

function check_newfile() {
    res=`git status | grep -v grep | grep "new file:" | wc -l`
    #echo $res
    if [ $res -eq 0 ]; then
      return 1
    fi
    return 0
}

function check_delfile() {
    res=`git status | grep -v grep | grep "deleted:" | wc -l`
    #echo $res
    if [ $res -eq 0 ]; then
      return 1
    fi
    return 0
}

check_whoami

git add .
check "#git add ."
 
git status

check_modifi
up1=$?

check_renamed
up2=$?

check_newfile
up3=$?

check_delfile
up4=$?

if [[ $up1 -eq 1 && $up2 -eq 1 && $up3 -eq 1 && $up4 -eq 1 ]]; then
  echo "not to commit, exit"
  exit -1
fi

git commit -m "update"
check "#git commit"

git push origin `whoami`
check "#git push"



