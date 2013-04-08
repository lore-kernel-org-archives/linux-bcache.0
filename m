From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Pull request] bcache data offset
Date: Mon, 08 Apr 2013 12:09:42 +0200
Message-ID: <51629766.6030805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,
These patches update the bcache superblock format so that backing device 
data can be at an arbitrary offset from the start of the backing device; 
this helps convert partitions or logical volumes to bcache in-place, and 
<https://github.com/g2p/blocks> has been updated to use the new format.

The kernel half is on top of bcache-for-upstream, the bcache-tools half 
is on top of the development version of bcache-tools.
They can be pulled from
- https://github.com/g2p/linux/tree/bcache-for-upstream
- https://github.com/g2p/bcache-tools/tree/enable-data-offset
