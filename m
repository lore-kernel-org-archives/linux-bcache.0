From: Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: comparison with rival projects
Date: Wed, 15 Dec 2010 16:18:36 -0800
Message-ID: <AANLkTi=hos1PdNJeRfi8mOxN9whosK+6cEfBpkv38coK@mail.gmail.com>
References: <1822941381.28401292455616547.JavaMail.root@shiva> <4D0957B4.6060801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D0957B4.6060801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inf-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Dec 15, 2010 at 4:05 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 12/15/2010 03:26 PM, luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org wrote:
>>
>> Hi,
>> Iam new in problematic of caching persistent data. I want to use cac=
hing
>> (on ssd disk) on my desktop with a lot of ram. I hope, it will provi=
de me
>> better latency for starting programs (developer/scientific desktop).=
 My
>> questions are:
>>
>> Is it possible to use single ssd disk for making two caches? One for
>> /dev/md2 (root partition, raid10) and second for /dev/md3 (raid5,hom=
e
>> partition, etc) (I hope this is possible by partitioning that ssd di=
sk and
>> using partitions for caching)
>
> Yep. One cache device can be used with (currently) up to 256 backing
> devices.
>
>>
>> Is it dangerous (in terms of data loss) to use writethrough caching =
to
>> single ssd disk of raid5 block device? (I have 5 disks, using lvm on=
 top of
>> raid).
>
> Shouldn't be, recovery from unclean shutdown is quite well tested, bo=
th
> writethrough and writeback should be perfectly safe.
>
>>
>> For caching device is most critical number for random reads or opera=
tions
>> per second. Is it right?
>
> For writethrough caching random reads, for writeback both reads and w=
rites.
>
>>
>> Trim is not need feature for cache ssd device. It will have same cac=
he
>> performance without it. Is it right?
>
> Really just depends on the ssd; some (cheaper, earlier) drives are kn=
own for
> performance significantly degrading over time, with trim helps with (=
but
> doesn't necessarily eliminate). Bcache uses trim if it's available.
>
>>
>> What benefits/disadvantages have bcache [1] project over dm-cache [2=
] and
>> flashcache [3]? My current knowledge is that writethrough is possibl=
e only
>> in bcache, but dm-cache is implemented in more "standard" way (thdou=
gh
>> devicemaper). Also bcache has some more information on web.
>>
>> [1] - http://bcache.evilpiepirate.org/
>> [2] - http://users.cis.fiu.edu/~zhaom/dmcache/index.html
>> [3] - https://github.com/facebook/flashcache
>
> Flashcache is based off of dm-cache.
>
> Flashcache has been used in production awhile, bcache is still a litt=
le
> rough around the edges - but bcache has better performance, more feat=
ures,
> and it always orders writes correctly so as to be crash safe (flashca=
che has
> a "torn write" problem).

Kent, now that we are on the topic, I wonder if there has been some
benchmarking comparing bcache to flashcache performance?

Also I wonder if you plan to target for getting bcache included in
mainline kernel. I wonder if such attempts were made for flashcache
but that's probably off-topic.

Thanks.
--
Nauman

>
>>
>> PS: Is there any tutorial for gentoo users?
>
> Nah, I'm an ubuntu/debian user. For caching / the important thing is =
to hook
> into your initramfs and get everything loaded before you mount your r=
oot
> filesystem.
>
>>
>> Thanks for any explanations / answers,
>> --
>> LuVar
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache"=
 in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
