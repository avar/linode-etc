#!/bin/bash

set -euo pipefail

if ! getent passwd leech
then
    useradd --create-home --comment "The shared leeching user" --shell /bin/false leech
fi

if ! getent passwd failo
then
    useradd --create-home --comment "Failo Failo Oie Oie Oie" --shell /bin/false failo
fi
