#!/bin/sh

# spread failo's wisdom to interactive shells
if [[ $- == *i* ]] && [[ ! -f "$HOME/.hushlogin" ]]; then
    failo-wisdom | cowsay -f sodomized-sheep
fi
