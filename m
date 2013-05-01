From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: block activity stats
Date: Tue, 30 Apr 2013 20:10:04 -0500
Message-ID: <51806B6C.5060402@warr.net>
References: <CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug@mail.gmail.com> <1367293610.13617.YahooMailClassic@web181503.mail.ne1.yahoo.com> <20130430203134.GI9931@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130430203134.GI9931-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

I'm sort of using this thread as a point to jump into one thing I am
working on.

I am working on a munin plugin and configuration settings to track the
cache and backing device statistics.  What metrics do you feel are
important to track for both the cache and backer?  Sysstat will
obviously capture all of the raw device I/O numbers we would need but to
tell the whole picture I'm sure there are allot of stats bcache tracks
that would be nice to relate to the raw I/O.

I also plan to write a script that will output raw numbers in a similar
fashion to what you'd get with iostat so one can get more of a immediate
snapshot with definable intervals.

Thanks,

Jason

On 04/30/2013 03:31 PM, Kent Overstreet wrote:
> On Mon, Apr 29, 2013 at 08:46:50PM -0700, matthew patton wrote:
>> Is block activity tracked exclusively by Bcache code or is Bcache
>> piggy-backing on already existing statistics tracking that is
>> implemented in LVM or the VM or (scsi?) block layers? If the first, I
>> was wondering how hard it would be to move it into the lower levels
>> and turned on/off with sysfs.
> 
> What sort of activity? Do you mean which blocks are cached and which
> aren't?
> 
> That sort of thing is tracked entirely within bcache.
> 
> Maybe you could tell me more specifically what you're trying to do?
> 
>> Is there a whitepaper that goes into the mechanics of the tracking,
>> the granularity (eg. block region size), (de)promotion trigger logic,
>> etc? Or is this a question best answered by "go read the code"?
> 
> There might be a more concise description of this stuff in the wiki, but
> probably the best documentation is going to be in the code - I wrote a
> lot of high level documentation and stuck it at the top of various
> files:
> 
> http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/bcache.h?h=bcache-dev
> 
> http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/alloc.c?h=bcache-dev
> 
> http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/btree.h?h=bcache-dev
> 
> Let me know what's missing!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
