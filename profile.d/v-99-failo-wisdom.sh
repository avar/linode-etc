#!/bin/sh

# spread failo's wisdom to interactive shells
if [[ $- == *i* ]] && [[ "$(groups)" != *gcf* ]]; then
    failo-wisdom
fi
