# About this repository

This Git repository hosts the `/etc` configuration for
[v.nix.is](http://v.nix.is). Its origin is
[avar/linode-etc](http://github.com/avar/linode-etc) on GitHub.

# What's here

We've only checked in files which have been modified from the Debian
defaults. This way we can easily migrate to another machine, install
the relevant packages and checkout this repository on top of the
`/etc` tree.

# How to commit

First make sure you have a `~/.gitconfig` which includes `user.name`
and `user.email` settings. See [the Github
documentation](http://help.github.com/git-email-settings/) for more
info.

## Adding a file

If you're going to edit a file first commit the default Debian
version. This gives us something to `git diff` against:

    sudo git add -f /etc/crontab

## Modifying files

After that commit your changes:

    # See what you changed
    git diff --staged

    # Add your changes
    sudo git commit

    # Push back to Github
    git push

# Documentation

Most of the documentation on the setup of various services is in the
Git commit logs.

For example; to find out why the mail setup is why it is just [read
the `git
log`](http://github.com/avar/linode-etc/commits/master/postfix) for
the `postfix/` directory.

There may also be some documentation in subdirectories of `/etc`. To
check it out look at:

    sudo find /etc -name 'README.md'

# Issues

Some issues and TODO items are tracked
[in the issue tracker](http://github.com/avar/linode-etc/issues) which
is hosted on Github.
