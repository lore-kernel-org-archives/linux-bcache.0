From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: can't attach caching device to backing device
Date: Tue, 29 Nov 2011 14:13:46 +0800
Message-ID: <4ED4781A.1080701@fnarfbargle.com>
References: <8C67A0427441E84B879B0D6058D20D5222410FE6@EXCH-MBX-1.epic.com> <CAC7rs0sXfPXY81BpdQhtNMrj--bUeP+VSSqbDMvTYA_DyMRf3g@mail.gmail.com> <8C67A0427441E84B879B0D6058D20D5222420EA2@EXCH-MBX-1.epic.com> <8C67A0427441E84B879B0D6058D20D5222421068@EXCH-MBX-1.epic.com> <20111121135415.GA26333@dhcp-172-18-216-138.mtv.corp.google.com> <8C67A0427441E84B879B0D6058D20D5222422D98@EXCH-MBX-1.epic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8C67A0427441E84B879B0D6058D20D5222422D98-QfgMShIfpGfUFh++4gLpBEEOCMrvLtNR@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 22/11/11 05:31, Justin Rush wrote:
> I am running into the same issue with LVM, using the entire raid device, and using a single plain disk... I must be doing something wrong here.

You are.

>   ~ # pvcreate /dev/md127
>    Physical volume "/dev/md127" successfully created
>
> ~ # vgcreate vg_500s_bcache /dev/md127
>    Volume group "vg_500s_bcache" successfully created
>
> ~ # lvcreate -L50G -nlv_bcache_test vg_500s_bcache
>    Logical volume "lv_bcache_test" created
>
>   ~ # make-bcache -B /dev/vg_500s_bcache/lv_bcache_test
> UUID:                   0847db15-4d6b-4271-a052-4338752a704f
> Set UUID:               06fa14ab-cbbe-4e10-ac5c-f48f92ffea39
> nbuckets:               102400
> block_size:             8
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
>
>   ~ # echo /dev/vg_500s_bcache/lv_bcache_test>/sys/fs/bcache/register
>   ~ # echo /dev/sdk1>/sys/fs/bcache/register
>
> ~ # echo "d5cadc1d-0fb6-4be5-bb32-f649c540c03d">/sys/block/bcache0/bcache/attach
> -bash: echo: write error: No such file or directory


You are trying to attach a cache device directly to a backing device. 
That won't work.

When you register the devices, do :
ls /sys/fs/bcache/

You will see a directory name in there. That is the UUID of the 
"cache-set" you need to attach to your backing device. It is different 
from the cache device itself.

Regards,
Brad
