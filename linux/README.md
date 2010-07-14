# Installing GRUB

Install `grub-legacy`, not the GRUB 2.0:

    sudo aptitude install grub-legacy

# Compiling a kernel

Clone the linux-2.6 repository:

    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Copy the config:

    cd linux-2.6
    cp /etc/linux/config .config
 
Make the kernel:
    
    make ARCH=x86_64 -j 4
