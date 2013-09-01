From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Please pull] make-bcache: prevent stray superblocks
Date: Sun, 01 Sep 2013 12:44:48 +0200
Message-ID: <52231AA0.9090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello,
Here is a patch updating make-bcache to disallow stray superblocks,
so that it matches the stricter udev check.

- https://github.com/g2p/bcache-tools/commits
- https://github.com/g2p/bcache-tools/commit/master

From the commit message:
Fail if the device has any leftover superblock or partition table label.

Add a --wipe-bcache flag to overwrite bcache superblocks and recommend
wipefs for non-bcache superblocks.

Once the device is safe to write, always zero immediately before the
bcache superblock.

Make sure errors go to stderr.  Use pkg-config.
