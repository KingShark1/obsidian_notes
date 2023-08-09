#!/bin/bash
current_date_time=$(date)
git add .
git commit -m "Commit on $current_date_time"
git push git@github.com:KingShark1/obsidian_notes.git HEAD:main
