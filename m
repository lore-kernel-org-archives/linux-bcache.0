From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 3 Jul 2013 16:56:02 +0000 (UTC)
Message-ID: <kr1l31$v4m$2@ger.gmane.org>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com>
	<kr1k7a$v4m$1@ger.gmane.org>
	<CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 03 Jul 2013 20:50:59 +0400, Vasiliy Tolstov wrote:
> 2013/7/3 Gabriel de Perthuis:
>> Hello,
>>
>> You could use `blocks to-lvm`[1] to convert your large disk to lvm,
>> and then `blocks to-bcache` to convert the lvm volume to bcache.
>> The lvm conversion will allow you to migrate the data off the
>> prefailed disk later, either by moving it (pvmove) or by converting
>> to raid1 (lvconvert).
> 
> Why i can't do :
> 
> create /dev/md0 with /dev/sda (sata) level=1 raid-devices=1
> format /dev/md0 with bcache
> format /dev/sdb (ssd) with brache
> 
> create bcache0 with /dev/md0 and /dev/sdb

That's reasonable, if you don't have any data you need to keep.
You can use

    make-bcache -C /deb/sdb -B /dev/md0

to format the devices and attach them at the same time.
