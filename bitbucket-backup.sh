#!/bin/bash

###############################################################
## Bitbucket backup generator
##
## Generate a copy of all repositories of an user 
## and update each one
##
## Usage:
## ./bitbucket-backup.sh BITBUCKET_USER BITBUCKET_PASSWORD
##
##
## Author: Santiago Carmo
## Email: santiagocca@gmail.com
## Version: 1.0
## 2014-01-10
## Licence: BSD
###############################################################

# get the repositories list from bitbucket using API and write the list into a file
curl -u ${1}:${2}  https://api.bitbucket.org/1.0/users/${1} > repoinfo

# extract from API JSON the repositóries names
repositories=(`cat repoinfo | python -m json.tool | grep slug | cut -f4 -d\"`)

# loop into repositories names and clone anyone that is not cloned yet
for repository in "${repositories[@]}"
do
	git clone ssh://git@bitbucket.org/${1}/$repository
done

# loop into repositories and do a GIT PULL on each aone
for repository in "${repositories[@]}"
do
  cd $repository
	git pull ssh://git@bitbucket.org/${1}/$repository
  cd ..
done

