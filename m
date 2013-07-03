From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 03 Jul 2013 12:02:17 -0500
Message-ID: <51D45919.40400@warr.net>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com> <kr1k7a$v4m$1@ger.gmane.org> <CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


On 07/03/2013 11:50 AM, Vasiliy Tolstov wrote:
> 2013/7/3 Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
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
>
> ?
If you want md0 to be a raid1 device in the future you need to create it
as a 2 device array with a missing drive:

mdadm -C /dev/md0 -l1 -n2 /dev/sda missing

You can then add in the other device whenever you can/want.  The key
though would be to make sure the size in blocks of the first device is =
or smaller than the second device will be.  What I would do is create a
fd type partition that is 1% smaller than total raw device size on
/dev/sda just to give your self a small margin of error.

parted /dev/sda mkpart primary 1.0 99% --align optimal
parted /dev/sda set 1 raid on
mdadm -C /dev/md0 -l1 -n2 /dev/sda1 missing

That way down the road you can add in a disk of about the same size to
the existing raid1 completely transparent of bcache with a single command.

mdadm /dev/md1 -a /dev/sdX1

>
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
