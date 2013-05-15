From: Campbell Steven <casteven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Bcache problem perhaps bug?
Date: Thu, 16 May 2013 10:03:38 +1200
Message-ID: <CAPerZE9pV43ASnSuo3R6G42s57MaPWA3rsOLnjch7v2y4UkC7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

We have been using bcache in a test environment here for a while to
vastly improve performance of a CEPH cluster. We have really only run
into one issue, and I'm sure it's something to do with the way we have
things configured (otherwise others would have noticed I'm sure) but
I'm not exactly sure where. We are currently running this
http://atlas.evilpiepirate.org/git/linux-bcache.git/commit/?id=dbc52367ad8e63b5bcb8c6b1442e8fb5ed251421
commit  from the bcache tree after this when we reboot the server it
will hang for ever with timeouts shown in the screenshots of the KVM
below (sorry limited options for collecting debug data via a windows
only KVM):

https://www.btg.co.nz/Public/2.jpg
https://www.btg.co.nz/Public/3.jpg
https://www.btg.co.nz/Public/4.jpg
https://www.btg.co.nz/Public/6.jpg

I have tested a plain mainline kernel without bcache on the same
machine and that works fine as does everything up to and around the
commit from the bcache tree mentioned above. Anything later than that
(up to and including the latest mainline checkout as of today)
exhibits the behaviour above.

Our setup is:

2 x Intel 520 120GB SSD's of which 10 GB is in a RAID 1 for the OS
with LVM over top and the remaining space on both SSD's is a RAID 0
with LVM on top and used as a bcache caching device for the 4 spinning
disks in the servers.

As a reference this post to the list appears to show the same errors
we are getting.

http://comments.gmane.org/gmane.linux.kernel.bcache.devel/1562

I made contact with Aaron, he wasn't able to resolve the issue.

Any pointers (or glaring problems with our setup) gladly accepted.

Thanks

Campbell
