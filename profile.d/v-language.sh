#!/bin/sh

# English motherfucker, do you speak it?
if test -z "$LANG" && test -z "$LANUAGE"
then
    LANGUAGE="en_US:en"
    LANG="en_US.UTF-8"
    export LANGUAGE LANG
fi
