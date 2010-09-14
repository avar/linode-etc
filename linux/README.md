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

Configure a `/boot/grub/menu.lst`, e.g. with the lines from
[here](http://github.com/avar/linode-etc/blob/master/boot/grub/menu.lst)
but *without* everything after "BEGIN AUTOMAGIC KERNELS LIST".

*MAKE SURE* the `kernel` line in `/boot/grub/menu.lst` actually points
to your new kernel image. You must manually edit `/boot/grub/menu.lst`
and update the kernel entry:
   
    $ prove -v -r /etc/linux/t
    /etc/linux/t/grub-kernel-line.t ..
    1..3
    ok 1 - current kernel image /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+ exists
    ok 2 - current root device /dev/xvda exists
    ok 3 - Our latest kernel /etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+ is listed among the grub kernels: </etc/boot/vmlinuz-2.6.36-rc4-Avar-Akbar+>
    ok
    All tests successful.
    Files=1, Tests=3,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.05 cusr  0.02 csys =  0.11 CPU)
    Result: PASS
   
Then run `update-grub`:

    $ sudo update-grub /boot/vmlinuz*
    Searching for GRUB installation directory ... found: /boot/grub
    Searching for default file ... found: /boot/grub/default
    Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
    Searching for splash image ... none found, skipping ...
    Found kernel: /etc/boot/vmlinuz-2.6.35-rc5+
    Updating /boot/grub/menu.lst ... done

# Rebooting

Configure the kernel
[to pv-grub](http://library.linode.com/advanced/pv-grub-howto#setting_your_linode_to_use_pv_grub)
in the Linode manager, then:

    sudo reboot
