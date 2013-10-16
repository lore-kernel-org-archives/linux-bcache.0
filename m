From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: bcache not works?
Date: Wed, 16 Oct 2013 08:22:29 +0400
Message-ID: <CACaajQueWka6dA3g-Uv7Asz9KhgX9nJ_sjd8bNRo2Y2iU-73jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I have this setup:
/dev/md127 - raid1 with one sata 3Tb drive
/dev/sdb SSD disk with 240 Gb

I'm succeseful create bcache0 device and format it to ext4.

/dev/bcache0 /var/lib/libvirt/images ext4
rw,relatime,journal_checksum,journal_async_commit,errors=remount-ro,min_batch_time=15000,max_batch_time=60000,data=ordered
0 0

After that i'm install kvm virtual machine and tries to create some
activity via iozone fio and other. But stats says nothing.

What i miss?

root@node03:~# cat
/sys/fs/bcache/76907875-ef3b-48b1-8531-f880e64487a8/stats_day/*
0
0
0
0
0
0
0
0



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
