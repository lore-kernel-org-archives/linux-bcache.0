From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: blkid always detects FS
Date: Tue, 27 Aug 2013 11:31:41 +0200
Message-ID: <521C71FD.1030704@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

since commit 0b57e166ae86d525ef42842cabf7692fc7c44039 in bcache tools
all my bcache devices do not register anymore.

For all my bcache devices blkid returns:

# /sbin/blkid -o udev /dev/sdd1
ID_FS_UUID=6937d2e6-c8e3-4590-954b-65937fc23a52
ID_FS_UUID_ENC=6937d2e6-c8e3-4590-954b-65937fc23a52
ID_FS_TYPE=xfs

What's wrong here? All disks have XFS on top of bcache running.

Greets,
Stefan
