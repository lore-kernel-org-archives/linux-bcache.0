From: Alex Elsayed <eternaleye+usenet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Unable to mount btrfs rootfs over after merging bcache
Date: Tue, 07 Aug 2012 00:18:08 -0700
Message-ID: <jvqffl$6ci$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi, I've found that if I merge bcache into my kernel it causes booting with 
a btrfs rootfs on top of dm-thin (with dm-crypt under it) to fail. In 3.4 it 
looped indefinitely IIRC, whereas with 3.5 it OOPSed until panic.

I don't have logs, sadly, as this occurs before I have a writable FS.

I will note that I don't have a bcache device, and this occurs even if 
bcache is compiled out.
