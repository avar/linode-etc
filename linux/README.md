This is how to build and install a custom kernel on Debian testing:

# Installing GRUB

Install `grub-legacy`, *not* the GRUB 2.0 package in `grub`:

    sudo aptitude install grub-legacy

# Compiling a kernel

Clone the linux-2.6 repository somewhere in your `~/`:

    git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    cd linux-2.6
    
Optionally, add some custom patches, e.g.:

    git remote add avar git://github.com/avar/linux-2.6.git
    git fetch avar
    git checkout -b xen-x86-tsc-unstable remotes/avar/xen-x86-tsc-unstable

Copy the config (or
[from the web](http://github.com/avar/linode-etc/tree/master/linux/)):

    cp /etc/linux/config .config
    
Upgrade the config for a new kernel:

    make oldconfig

If something changed we should check that into git:

    cp .config /etc/linux/config
    git diff /etc/linux/config
    git commit ...
    
Compile the kernel:
    
    make ARCH=x86_64 -j 4 all modules
    sudo make install modules_install

# Installing the kernel

Edit the lines before "BEGIN AUTOMAGIC KERNELS LIST" in
`/boot/grub/menu.lst` to point to your new kernel.

Then run `update-grub` to generate the rest of the `menu.lst` based on
that:

    $ sudo update-grub
    Searching for GRUB installation directory ... found: /boot/grub
    Searching for default file ... found: /boot/grub/default
    Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
    Searching for splash image ... none found, skipping ...
    Found kernel: /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+
    Found kernel: /etc/boot/vmlinuz-2.6.36-rc1-Avar-Akbar
    Found kernel: /etc/boot/vmlinuz-2.6.35-rc5-Avar-Akbar+
    Updating /boot/grub/menu.lst ... done
    
You can see if it worked by running the /etc/linux/t tests:

    $ prove -v -r /etc/linux/t
    /etc/linux/t/grub-kernel-line.t ..
    1..4
    ok 1 - current kernel image /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+ exists
    ok 2 - current root device /dev/xvda exists
    ok 3 - Our latest kernel /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+ is listed among the grub kernels: </etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+>
        1..7
        ok 1 - Got generated kernel: /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+
        ok 2 - Got generated kernel: /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+
        ok 3 - Got generated kernel: /etc/boot/vmlinuz-2.6.36-rc1-Avar-Akbar
        ok 4 - Got generated kernel: /etc/boot/vmlinuz-2.6.36-rc1-Avar-Akbar
        ok 5 - Got generated kernel: /etc/boot/vmlinuz-2.6.35-rc5-Avar-Akbar+
        ok 6 - Got generated kernel: /etc/boot/vmlinuz-2.6.35-rc5-Avar-Akbar+
        ok 7 - Our latest kernel /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+ is listed among the generated kernels ^^
    ok 4 - We ran update-grub
    ok
    All tests successful.
    Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.08 cusr  0.02 csys =  0.14 CPU)
    Result: PASS

# Rebooting

Configure the kernel
[to pv-grub](http://library.linode.com/advanced/pv-grub-howto#setting_your_linode_to_use_pv_grub)
in the Linode manager, then:

    sudo reboot
    
Or, more kindly:

    sudo shutdown -r '+360' "We're rebooting in 6 hours kernel and libc updates"
