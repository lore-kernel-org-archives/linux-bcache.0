From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache strange behaviour in write back mode
Date: Wed, 24 Apr 2013 13:13:40 -0700
Message-ID: <CAC7rs0s-_e1WaymU1OcuBv+Tf8hiJLED=m5Qrpxhar6Zk3H9uQ@mail.gmail.com>
References: <51758C42.4040708@profitbricks.com>
	<51783733.9080907@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51783733.9080907-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Ah, you would've been running an old version of the bcache-testing bran=
ch...

Someone else bisected a different bug to that commit, so that one's
staying in the dev branch for now.

I just pushed the allocator fix to the bcache-for-upstream branch, can
you give that a try?

On Wed, Apr 24, 2013 at 12:49 PM, Jack Wang <jinpu.wang-EIkl63zCoXbZz8UjPX3odA@public.gmane.org=
m> wrote:
> I revert this commit:
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.=
c
> index e5ff12e..2f36743 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -489,6 +489,12 @@ static void bch_insert_data_loop(struct closure =
*cl)
>                 bch_queue_gc(op->c);
>         }
>
> +       /*
> +        * Journal writes are marked REQ_FLUSH; if the original write=
 was a
> +        * flush, it'll wait on the journal write.
> +        */
> +       bio->bi_rw &=3D ~(REQ_FLUSH|REQ_FUA);
> +
>         do {
>                 unsigned i;
>                 struct bkey *k;
> @@ -716,7 +722,7 @@ static struct search *search_alloc(struct bio *bi=
o,
> struct bcache_device *d)
>         s->task                 =3D current;
>         s->orig_bio             =3D bio;
>         s->write                =3D (bio->bi_rw & REQ_WRITE) !=3D 0;
> -       s->op.flush_journal     =3D (bio->bi_rw & REQ_FLUSH) !=3D 0;
> +       s->op.flush_journal     =3D (bio->bi_rw & (REQ_FLUSH|REQ_FUA)=
) !=3D 0;
>         s->op.skip              =3D (bio->bi_rw & REQ_DISCARD) !=3D 0=
;
>         s->recoverable          =3D 1;
>         s->start_time           =3D jiffies;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 6817ea4..0932580 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -766,6 +766,8 @@ static int bcache_device_init(struct bcache_devic=
e
> *d, unsigned block_size)
>         set_bit(QUEUE_FLAG_NONROT,      &d->disk->queue->queue_flags)=
;
>         set_bit(QUEUE_FLAG_DISCARD,     &d->disk->queue->queue_flags)=
;
>
> +       blk_queue_flush(q, REQ_FLUSH|REQ_FUA);
> +
>         return 0;
>  }
>
> the strange behaviour is gone. And I checked the bcache-testing, it d=
oes
> not contain that commit any more, maybe I'm lost in the git tree upda=
te.
> Anyway, thanks Kent for your kindly support.
>
> Jack
>
> On 2013=E5=B9=B404=E6=9C=8822=E6=97=A5 21:15, Jack Wang wrote:
>> Hi all,
>>
>> We've seen strange behaviour in bcache mode in current bcache-testin=
g
>> branch with Possible allocator fix:
>>
>> Once I start writing data with "dd if=3D/dev/zero of=3D/dev/bcache0 =
bs=3D4k
>> count=3D10000 oflag=3Dsync", all SSDs in the Pool go close to 100% u=
til and
>> I see about 3600 writes/second in iostat for each disk in the pool, =
BUT
>> no data written in means of throughput.
>>
>> Then after some seconds (the flush interval of bcache) I see the flu=
sh
>> of the writeback and also data written to the pool SSDs which looks
>> pretty much like reordering and merging happened for that data.
>>
>> bcache-3.2 does not have such problem.
>> only bcache(master) and bcache-testing have such problem.
>>
>> What's the possible reason?
>>
>> Regards,
>> Jack
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
