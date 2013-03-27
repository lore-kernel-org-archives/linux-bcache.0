From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Raid5 slower with bcache
Date: Wed, 27 Mar 2013 19:54:15 +0100
Message-ID: <CAAnFQG-Nm8yL4rzizDkV7L=0Rxr1naD1HAB8RyR1zpeX5tG4Vw@mail.gmail.com>
References: <CAAnFQG9Uafe2PLgA33Uve95W06hb_EHMOqC5FQg9mUbuH-hznw@mail.gmail.com>
 <20130327182536.GA22232@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130327182536.GA22232-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Mar 27, 2013 at 7:25 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

>> I've been using bcache since last summer, caching a 4x3TB raid5.
>>
>> Last week one of my disks died so after replacing it, I also got a new
>> SSD and began to do some tests. There is something which, while not
>> proving anything, worries me anyway. Better than describing it, just
>> see this (caches were flushed before each hdparm):
>
> I think I may have finally figured this one out - bcache wasn't setting
> readahead_pages, and raid5/6 needs it to be set based on the number of
> devices in the array. Can you try the version I just pushed?

Well, it improves it a little bit but there is still a wide gap, 1/3
worse than the raid directly:

# hdparm -tT /dev/md0

/dev/md0:
 Timing cached reads:   23742 MB in  2.00 seconds = 11882.23 MB/sec
 Timing buffered disk reads: 1110 MB in  3.00 seconds = 369.83 MB/sec

# hdparm -tT /dev/md0

/dev/md0:
 Timing cached reads:   24350 MB in  2.00 seconds = 12188.02 MB/sec
 Timing buffered disk reads: 1118 MB in  3.00 seconds = 372.39 MB/sec

# hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   23404 MB in  2.00 seconds = 11713.20 MB/sec
 Timing buffered disk reads: 724 MB in  3.00 seconds = 240.98 MB/sec

# hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   22638 MB in  2.00 seconds = 11330.39 MB/sec
 Timing buffered disk reads: 694 MB in  3.02 seconds = 230.08 MB/sec

# hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   23916 MB in  2.00 seconds = 11969.22 MB/sec
 Timing buffered disk reads: 686 MB in  3.00 seconds = 228.53 MB/sec


-- 
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
