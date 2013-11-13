From: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Subject: Re: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 09:32:20 -0500
Message-ID: <52838D74.6020502@bahj.com>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com> <op.w6hq4v0of3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <op.w6hq4v0of3gqgg-r49W/1Cwd2cba4AQcYcrVKxOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11/13/2013 09:13 AM, Matthew Patton wrote:
> On Wed, 13 Nov 2013 03:42:54 -0500, Francis Moreau 
> <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> And finally, can I create the over-provisioning without lost the
>> content of my backing device ?
>
> hell no.
>
I'm a bit confused: why not?  Francis seems to be asking if the entire 
bcache device needs to be recreated.  It definitely is necessary to 
rebuild the cache device, but the backing device shouldn't be affected.  
Let's call the backing device /dev/backdev and the cache device 
/dev/cachedev.  Then it should be possible to do the following:

0. If you are using writeback caching, "echo none > 
/sys/block/backdev/bcache/cache_mode" to tell bcache to flush the 
contents of the cache and then wait until "cat 
/sys/block/backdev/bcache/dirty_data" yields a zero
1. "echo 1 > /sys/block/backdev/bcache/detach" to remove the caching 
device from the bcache volume
2. "echo 1 >  /sys/fs/bcache/$UUID/unregister" to remove the caching 
device from the kernel
3. repartition the caching device so that /dev/cachedev is only e.g. 75% 
of the SSD
4. "make-bcache -C /dev/cachedev" to recreate the cache device
5. "echo /dev/cachedev > /sys/fs/bcache/register" to make the kernel 
aware of the new device
6. "ls /sys/fs/bcache" or just pay attention to make-bcache to find the 
cache volume UUID
7. "echo $UUID > /sys/block/backdev/bcache/attach" to reattach the 
caching device
8. "echo whatever-mode > /sys/block/backdev/bcache/cache_mode" to put it 
back into whichever mode you wish

Is there something wrong with my reasoning?  I may also have 
misunderstood the situation.  I'm just hoping I understand bcache as 
well as I think I do.  :)

Cheers,

Zach
