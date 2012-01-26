From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Stats
Date: Thu, 26 Jan 2012 12:35:57 -0800
Message-ID: <CAH+dOxJTg6tcwk0pV35_LC4bjW1hTffEWeYxOzyssJi1meGJpw@mail.gmail.com>
References: <CAB7K1hGfTHjskUbmgWG6GBBZCyfDFvTzZwpHjEAmsUgnt3FnMA@mail.gmail.com>
	<CAHYUNGaenUE7VCprt8cbbLOVVD+J17ao1w65BNz7kW7xg-e4nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHYUNGaenUE7VCprt8cbbLOVVD+J17ao1w65BNz7kW7xg-e4nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

=46rom the timestamps, that's decaying way too fast. Looks like a bug.

On Thu, Jan 26, 2012 at 10:38 AM, Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
> The=A0/sys/block/bcache0/bcache/stats_total/bypassed should accumulat=
e
> (notice the stats_total), but stats_day only shows results with an
> exponentially weighted average with a half life of 1 day. =A0If your
> load varies during the day, the amount bypassed will swing up and dow=
n
> accordingly.
>
> Adam
>
> On Thu, Jan 26, 2012 at 10:31 AM, David Rhodes Clymer
> <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
>>
>> Although the doc (Documentation/bcache.txt) seems to indicate that
>> "bypassed" should contain cumulative IO for the stat period, I've
>> noticed that it does not consistently increase. In fact, it increase=
s
>> and decreases quite a bit over a short period of time.
>>
>> root@zapazoid:~# date
>> Thu Jan 26 13:23:34 EST 2012
>> root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
>> 5.4M
>> root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
>> 9.1M
>> root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
>> 1008k
>> root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
>> 2.4M
>> root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
>> 5.1M
>> root@zapazoid:~# date
>> Thu Jan 26 13:24:44 EST 2012
>>
>>
>> This is while doing an rsync into a cached filesystem, which I would
>> imagine would entail a significant amount of sequential writes.
>>
>> Am I just misunderstanding what this is supposed to be telling me?
>>
>> -davidc
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
