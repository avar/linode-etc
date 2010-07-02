#!/bin/sh

# English motherfucker, do you speak it?
if test -z "$LANG" && test -z "$LANUAGE" && locale -a | grep -q en_US.utf8
then
    LANGUAGE="en_US:en"
    LANG="en_US.utf8"
    export LANGUAGE LANG
fi
