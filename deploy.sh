#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray

PID=""
BRANCH=step2
PROFILE=prod
BUILD_FILE=subway-0.0.1-SNAPSHOT.jar

function install() {
  sudo apt update
  sudo apt install -y default-jre
  sudo apt install -y default-jdk
}

function pull() {
  git clone -b $BRANCH --single-branch https://github.com/becky-bigc/infra-subway-stable.git
  cd /home/ubuntu/infra-subway-stable
}

## gradle build
function gradle_build() {
  echo -e ""
  echo -e "${txtpur}>> gradle build${txtrst}"
  ./gradlew clean build

}

## 프로세스 pid를 찾는 명령어
function find_pid() {
  echo -e ""
  echo -e "${txtpur}>> find running process id${txtrst}"
  PID=$(pgrep -f ${BUILD_FILE})
  echo -e "${txtred}$PID${txtrst}"
}

## 프로세스를 종료하는 명령어
function kill_pid() {
  echo -e "pid : $PID"
  if [[ -z $PID ]]; then
    echo "${txtred}isn't running process${txtrst}"
  else
    echo -e "${txtpur}>> kill process $pid ${txtrst}"
    kill -9 $pid
  fi
}

function deploy() {
  echo -e ""
  echo -e "${txtpur}>> deploy ${txtrst}"
  echo -e "$( find ./* -name "*subway*jar")"
  nohup java -jar -Dspring.profiles.active=${PROFILE} $( find ./* -name ${BUILD_FILE}) >1 subway.log 2>&1  &
  echo -e "${txtpur}>> deploy ${txtrst}"
}

function start() {
  install;
  pull;
  gradle_build;
  find_pid;
  kill_pid;
  deploy;
}

start;
