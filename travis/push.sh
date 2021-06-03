#!/bin/sh

setup_job() {
case "$JOB" in
    "agent") BRANCH="deploy_agent";;
    "admin") BRANCH="deploy_admin";;
    *) echo "job not specified"
esac
}

setup_git() {
git config --global user.email "yejisoft@gmail.com"
git config --global user.name "Yeji Hong"
git checkout -b $BRANCH
}

commit_deb_files() {
git add *.deb
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
git remote add new https://${GH_TOKEN}@github.com/hamonikr/hamonize.git > /dev/null 2>&1
git push -f new $BRANCH
}

setup_job
setup_git
commit_deb_files
upload_files
