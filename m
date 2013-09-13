From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [ANN] Ubuntu PPA for bcache-tools and blocks
Date: Fri, 13 Sep 2013 13:04:25 +0200
Message-ID: <5232F139.4080508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ubuntu-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,
I've published various bcache-related packages to

https://launchpad.net/~g2p/+archive/storage/

The packages are built for saucy and raring, and can be
added with

    sudo add-apt-repository ppa:g2p/storage
    sudo apt-get update
    sudo apt-get install bcache-tools blocks

bcache is a hybrid caching layer that speeds up HDDs
with SSDs; it was merged in Linux 3.10.  Backported
Ubuntu kernels are available at

http://kernel.ubuntu.com/~kernel-ppa/mainline/

bcache-tools contains udev and initramfs integration and
some command-line tools.

blocks is a conversion tool that can convert block devices
to bcache and lvm.  Usage is described here:

https://github.com/g2p/blocks#bcache-conversion

This release of blocks adds a maintboot mode that can
convert root filesystems to bcache without a live cd.
