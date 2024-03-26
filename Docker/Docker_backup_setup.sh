#!/bin/bash
#dockerbackup Setuptool
start cmd /c

ackup_dir="/c/Docker_Backup"

mkdir -p "$backup_dir"
mkdir -p "$backup_dir/wordpress"
mkdir -p "$backup_dir/database"