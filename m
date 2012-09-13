From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Thu, 13 Sep 2012 11:43:51 -0700
Message-ID: <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sounds like a good portion of your IO is bypassing the cache. That
will happen if some of it's sequential, or if the SSD latency goes
over a threshold - sequential_cutoff, congested_read_threshold_us and
congest_write_threshold_us (if I'm remembering the names correctly)
are the settings that control all that. 0 disables all of them.

On Wed, Sep 12, 2012 at 1:01 PM, Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org> wrot=
e:
> I am having a problem with BCache.
>
> I=92ve followed the documentation and have my cache attached. Here is
> what dmesg tells me:
>
> [  372.622905] bcache: invalidating existing data
> [  372.637517] bcache: registered cache device rssda1
> [  400.704672] bcache: Caching dm-2 as bcache0 on set
> 16fd7139-f018-461c-9d9e-daa
>
> I warmed up the cache by using an application (vdbench) to do random
> reads over a 10GB region.
>
> Everything looks good as the response time comes down as the cache
> warms up. But, for some reason the cache_hit_rate is showing 90% and
> yet I=92m still seeing heavy activity to the disk device.
>
> bwalker@nellis:~> cat
> /sys/fs/bcache/16fd7139-f018-461c-9d9e-daa7666c7f1e/stats_total/cache=
_hit_ratio
> 94
> bwalker@nellis:~>
>
> Any ideas on why this might be happening are appreciated.
>
> -brad w.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
