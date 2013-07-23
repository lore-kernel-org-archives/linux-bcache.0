From: Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: can't get bache's sequential_cutoff to work
Date: Tue, 23 Jul 2013 22:38:49 +0200
Message-ID: <51EEE9D9.7090207@profihost.ag>
References: <51EE9056.7030903@profihost.ag> <CA+res+Ti1-tGANkb9wRAgF4sAcUqEv9RfGjDvbdX3bbxS=XK8g@mail.gmail.com> <51EEDC73.5020101@profihost.ag> <51EEE805.7090200@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51EEE805.7090200-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Mhm works directly on block device but not with XFS on top.
Am 23.07.2013 22:31, schrieb Stefan Priebe:
> It works fine if do really small block writes like this:
>
> # dd if=/dev/zero of=/dev/bcache0 bs=100 count=5000000
>
> Can anybody tell me why?
>
> Stefan
> Am 23.07.2013 21:41, schrieb Stefan Priebe:
>> It's 3.10 with bcache Updates from kent's for 3.10 branch.
>>
>> Stefan
>>
>> This mail was sent with my iPhone.
>>
>> Am 23.07.2013 um 18:00 schrieb Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>> <mailto:jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>>:
>>
>>> Hi Stefan,
>>>
>>> Strange, I tested bcache 2 month ago, mostly bcache-3.2 branch in
>>> writeback mode, it works as claimed.
>>>
>>> which kernel version are you using?
>>>
>>> Jack
>>>
>>>
>>> 2013/7/23 Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org
>>> <mailto:s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>>
>>>
>>>     Hi,
>>>
>>>     maybe i missed something or maybe i'm just wrong.
>>>
>>>
>>>     # cat /sys/block/bcache2/bcache/sequential_cutoff
>>>     512k
>>>
>>>     # cat /sys/block/bcache2/bcache/stats_five_minute/bypassed
>>>     64.3M
>>>
>>>     # dd if=/dev/zero of=/mnt/bcache2/ttt bs=4M count=1000 oflag=direct
>>>     1000+0 records in
>>>     1000+0 records out
>>>     4194304000 bytes (4,2 GB) copied, 11,0348 s, 380 MB/s
>>>
>>>     # cat /sys/block/bcache2/bcache/stats_five_minute/bypassed
>>>     69.3M
>>>
>>>     I also see only IOP/s an writes go to the SSD but not to the disk
>>>     behind. What's wrong?
>>>
>>>     Greets,
>>>     Stefan
>>>     --
>>>     To unsubscribe from this list: send the line "unsubscribe
>>>     linux-bcache" in
>>>     the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>     <mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>>>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>>
