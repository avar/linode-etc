#!/bin/sh

rsync -av --progress --one-file-system --delete \
	$@ \
	u.nix.is:/ \
	/backup/unixis/
