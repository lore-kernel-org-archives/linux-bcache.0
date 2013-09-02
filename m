From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Suspend and Hibernation Bugs
Date: Mon, 2 Sep 2013 09:37:43 -0700
Message-ID: <20130902163743.GA14878@blackbox.djwong.org>
References: <52238303.6040509@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52238303.6040509-J5qI5MFTcs8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Sep 01, 2013 at 02:10:11PM -0400, Zachary Palmer wrote:
> Hello there.  I'm not sure if this is the appropriate venue, so
> please let me know if this information should be somewhere else.  I
> have configured a Debian 7.0 installation on a Dell Inspiron 17R SE
> laptop to use a bcache root device.  The previous known working
> configuration for the laptop was:
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
>     * Installed a Linux 3.10 kernel from wheezy-backports
> (3.10-0.bpo.2-686-pae)
>     * Obtained a copy of the bcache-tools source from the git repo
> and compiled it
>     * Constructed a Debian package for bcache-tools using checkinstall
>     * Because udev recognition wasn't enough at boot time, added a
> script /etc/initramfs-tools/scripts/init-premount/z-bcache which
> looks like this:
>             #!/bin/sh -e
> 
>             # ZEP - Added (2013-08-29) because some bcache devices
> were not being detected
>             #       at startup by udev.  This sloppy hack should do
> the job.
> 
>             PREREQS=""
> 
>             prereqs() { echo "$PREREQS"; }
> 
>             case "$1" in
>                 prereqs)
>                     prereqs
>                     exit 0
>                     ;;
>             esac
> 
>             . /scripts/functions
> 
>             if [ -e '/sys/fs/bcache/register_quiet' ]; then
>                 log_begin_msg "Scanning for bcache devices..."
>                 for d in `ls /dev/sd*`; do
>                     echo "$d" > /sys/fs/bcache/register_quiet
> 2>/dev/null || true
>                 done
>                 log_end_msg "bcache device scan complete"
>             else
>                 log_warning_msg "/sys/fs/bcache/register_quiet not
> found; not registering devices"
>             fi
>     * Executed update-initramfs -u -k all to get everything working
> 
> My machine boots from /dev/sda8 and the initramfs has enough
> machinery to get the root drive mounted.  I was thrilled until I
> discovered that neither suspend nor hibernate seems to work; the
> suspend process seizes up while suspending devices and never comes
> back.  I booted the laptop from a custom Debian live disk using the
> same kernel (3.10-0.bpo.2-686-pae) and performed a series of tests:
> 
>     * When the bcache kernel module was not loaded, suspend to RAM
> worked correctly.
>     * When the bcache kernel module was loaded but no devices were
> registered, suspend to RAM worked correctly.
>     * When a single bcache device was registered using "echo
> /dev/sda7 > /sys/fs/bcache/register; echo /dev/sdb3 >
> /sys/fs/bcache/register", suspend to RAM failed to change the power
> state of the machine.
>     * With a /dev/bcache0 device in use as an encrypted volume,
> running "echo freezer > /sys/power/pm_test; echo platform >
> /sys/power/disk; echo disk > /sys/power/state" allows the machine to
> awaken from the test correctly.
>     * With a /dev/bcache0 device in use as an encrypted volume,
> running "echo devices > /sys/power/pm_test; echo platform >
> /sys/power/disk; echo disk > /sys/power/state" causes the machine to
> hang.
> 
> Has suspend/hibernate been tested with bcache?  Is it supported? I'm
> trying to figure out if it's my specific laptop hardware causing the
> issue or if bcache is somehow at fault.  (Clearly, I can get
> suspend/hibernate back if I migrate back to using just my HDD, but
> caching blocks in a fashion designed for SSDs seems like such a
> lovely idea.)

Suspend/resume works fine for me (sort of).  On 3.10.5 I saw some sort of bug
with the freezer that went away if I disabled the Intel MEI driver (or just
applied Kent's for-3.11 branch).  I don't recall if Kent ever submitted it for
3.10.

--D
