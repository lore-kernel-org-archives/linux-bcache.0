From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Fri, 28 Sep 2012 10:31:01 -0600
Message-ID: <CAPKZHbX_C62QmktNJkGKHa54FiaeiW5+s-v_=e6QcCw_P+N89w@mail.gmail.com>
References: <50651c68.a8e1440a.1165.67c8SMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50651c68.a8e1440a.1165.67c8SMTPIN_ADDED-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jason-/cow75dQlsI@public.gmane.org" <jason-/cow75dQlsI@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 27, 2012 at 9:41 PM, jason-/cow75dQlsI@public.gmane.org <jason-/cow75dQlsI@public.gmane.org> wrote:
> One thing that comes to mind for me is your 1gb test may be mostly hitting
> the ram cache on the ssd.  That is generally where ssd makers, consumer and
> to a lesser extent enterprise, get the peak I/O ops numbers from.

I understand your thinking. But, in tests using Facebook FlashCache as
well as our internally developed caching software (I work for a big
storage company), that is not what I see. What I see is that once the
cache warms ups, regardless of the size (i.e. 1GB, 10GB, 100GB), that
access times are sub-millisecond.

> Can you do the same tests, 10gb and 1gb, using only the ssd as your block
> device to get a baseline for it without bcache in the picture?

Good suggestion! I have done this and the data shows that my SSD has a
baseline of 800K iops when using a 4k blocksize.

> I would also do some mixed r/w tests just to sort of get a real world
> profile for your ssd and system.

I'll take a look at doing this over the weekend.

> You also don't mention what type and how many spindles you have in the
> mechanical array.

I'm using a RAID array which has lots of horsepower and the RAID 5
configuration has 6 drives. Each drive is a 15K rpm type. So the array
has very good performance.

One data point that is when I run Facebook flashcache, once the cache
is fully warmed, I see about 0.60 ms response time.

Any suggestions?

-brad w.
