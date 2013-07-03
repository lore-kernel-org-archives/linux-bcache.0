From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 3 Jul 2013 20:50:59 +0400
Message-ID: <CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w@mail.gmail.com>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com>
 <kr1k7a$v4m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kr1k7a$v4m$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

2013/7/3 Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hello,
>
> You could use `blocks to-lvm`[1] to convert your large disk to lvm,
> and then `blocks to-bcache` to convert the lvm volume to bcache.
> The lvm conversion will allow you to migrate the data off the
> prefailed disk later, either by moving it (pvmove) or by converting
> to raid1 (lvconvert).


Why i can't do :

create /dev/md0 with /dev/sda (sata) level=1 raid-devices=1
format /dev/md0 with bcache
format /dev/sdb (ssd) with brache

create bcache0 with /dev/md0 and /dev/sdb

?



--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
