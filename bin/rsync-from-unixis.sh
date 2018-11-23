#!/bin/sh

rsync -av --progress --one-file-system --delete \
	$@ \
	/ \
	/backup/unixis/