#!/bin/bash

set -euo pipefail

rsync -av --progress --one-file-system --delete \
	--exclude=/dns \
	$@ \
	u.nix.is:/ \
	/backup/unixis/

rsync -av --progress --one-file-system --delete \
	$@ \
	u.nix.is:/dns \
	/backup/unixis/
