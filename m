From: i- <itooo-xVucS5mfmt0AvxtiuMwx3w@public.gmane.org>
Subject: Not a bcache superblock
Date: Mon, 25 Jul 2011 16:14:21 +0000 (UTC)
Message-ID: <loom.20110725T180931-69@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

When trying to register a device with bcache, I have the following error message
: "bcache: error opening /dev/sdb1: Not a bcache superblock"

Digging around showed me the magic number could not be matched, digging a bit
more I found out that the cache_sb structures are different in the tools code
and in the kernel code.

There are 3 fields before the magic in the tools' bcache.h but the magic is the
first field in bcache.c in the linux module code...

Am I out of sync between repos ? (I cloned them both today)

Regards
