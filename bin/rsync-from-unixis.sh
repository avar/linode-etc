#!/bin/bash

set -euo pipefail

echo "We did the one-off rsync already!"
exit 1

rsync -av --progress --one-file-system --delete \
	--exclude=/dns \
	--exclude=/boot \
	$@ \
	u.nix.is:/ \
	/backup/unixis/

for partition in /boot /dns
do
	rsync -av --progress --one-file-system --delete \
		$@ \
		u.nix.is:$partition \
		/backup/unixis/
done
