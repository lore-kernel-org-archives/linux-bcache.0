From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 03 Jul 2013 12:40:42 -0500
Message-ID: <51D4621A.505@warr.net>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com> <kr1k7a$v4m$1@ger.gmane.org> <CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w@mail.gmail.com> <51D45919.40400@warr.net> <CACaajQsSL6kdjgWhr+v9QxAKdPK=UvUd6NUn7YDESjYYJ_tiDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQsSL6kdjgWhr+v9QxAKdPK=UvUd6NUn7YDESjYYJ_tiDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


On 07/03/2013 12:15 PM, Vasiliy Tolstov wrote:
> 2013/7/3 Jason Warr <jason-/cow75dQlsI@public.gmane.org>:
>> If you want md0 to be a raid1 device in the future you need to create it
>> as a 2 device array with a missing drive:
>>
>> mdadm -C /dev/md0 -l1 -n2 /dev/sda missing
>>
>> You can then add in the other device whenever you can/want.  The key
>> though would be to make sure the size in blocks of the first device is =
>> or smaller than the second device will be.  What I would do is create a
>> fd type partition that is 1% smaller than total raw device size on
>> /dev/sda just to give your self a small margin of error.
>>
>> parted /dev/sda mkpart primary 1.0 99% --align optimal
>> parted /dev/sda set 1 raid on
>> mdadm -C /dev/md0 -l1 -n2 /dev/sda1 missing
>>
>> That way down the road you can add in a disk of about the same size to
>> the existing raid1 completely transparent of bcache with a single command.
>>
>> mdadm /dev/md1 -a /dev/sdX1
>
> Thanks. But as i understand if the second drive bigger then first i
> can sync raid1 and after thet grow /dev/md0 to new size...
In a mirror your raid device can only be as big as the smallest device. 
So if you put in a secondary device that is larger than the first you
still cannot go beyond the size of the first unless you then replace it
after syncing the second.

> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
