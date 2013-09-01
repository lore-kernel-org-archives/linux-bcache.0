From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Suspend and Hibernation Bugs
Date: Sun, 01 Sep 2013 21:46:39 +0200
Message-ID: <5223999F.2050508@gmail.com>
References: <52238303.6040509@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52238303.6040509-J5qI5MFTcs8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Hello there. I'm not sure if this is the appropriate venue, so please
> let me know if this information should be somewhere else. I have
> configured a Debian 7.0 installation on a Dell Inspiron 17R SE laptop
> to use a bcache root device. The previous known working configuration
> for the laptop was:
>
>     /dev/sda (1TB HDD)
>         ...
>         /dev/sda7 (used as LUKS encrypted volume)
>             /dev/mapper/sda7_crypt (used as LVM PV)
>                 /dev/vg0/home
>                 /dev/vg0/root
>                 ...
>         /dev/sda8 (used as ext3 /boot)
>
> The new configuration is
>
>     /dev/sda (1TB HDD)
>         ...
>         /dev/sda7 (used as bcache backing device)
>             /dev/bcache0 (used as LUKS encrypted volume)
>                 /dev/mapper/bcache_crypt (used as LVM PV)
>                     /dev/vg0/home
>                     /dev/vg0/root
>                     ...
>         /dev/sda8 (used as ext3 /boot)
>     /dev/sdb (32GB SSD)
>         ...
>         /dev/sdb3 (used as bcache caching device)
>
> In order to get things booting, I also:
>
>     * Installed a Linux 3.10 kernel from wheezy-backports (3.10-0.bpo.2-686-pae)
>     * Obtained a copy of the bcache-tools source from the git repo and compiled it
>     * Constructed a Debian package for bcache-tools using checkinstall
>     * Because udev recognition wasn't enough at boot time, added a script
>       /etc/initramfs-tools/scripts/init-premount/z-bcache which looks like this:

Just addressing the udev part; could you check with wipefs (nondestructive with no flags)
that /dev/sda7 doesn't have an old non-bcache superblock?

There's been a transitional period when udev rules were stricter than what make-bcache
created, which will be fixed with the patch at https://github.com/g2p/bcache-tools/commits.
