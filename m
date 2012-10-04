From: Kingsly John <member+bcache-4+VQVQEymQXR7s880joybQ@public.gmane.org>
Subject: bcache, layered block devices and unclean shutdowns
Date: Thu, 4 Oct 2012 16:06:25 +0530
Message-ID: <20121004103625.GD17229@narnia.kingsly.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

In the archives I found a thread from a few months ago where it was
recommended that it's best to use bcache on the RAID layer.(rather than the
disks themselves or LVM)

Wouldn't this affect bcache's ability to recover from an unclean shutdown?
ie, if the raid array itself can't be brought up, bcache wouldn't be able to
write caches to disk? (Or is that not a possibility)

Kingsly

-- 
