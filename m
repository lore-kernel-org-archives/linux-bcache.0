From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: writeback mode behaviour on proper shut down
Date: Tue, 10 May 2016 18:14:01 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605101813400.22680@mx.ewheeler.net>
References: <CACHiF8AEZ0Ppoa9mzou76o8j5UC-gXyjt25EDvnqq9S-Kk0B8Q@mail.gmail.com> <alpine.LRH.2.11.1604261953230.21555@mx.ewheeler.net> <CACHiF8C0A+Gmr5xYCRhB+dm0zLu3iyYysuQXNYAVLOmDUix5hg@mail.gmail.com> <alpine.LRH.2.11.1604270209100.21555@mx.ewheeler.net>
 <CACHiF8CO59dACuZuY2M4wOWgoXC6-MEZCvu35D_kWX6KE22OqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:57101 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbcEKBNx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 21:13:53 -0400
In-Reply-To: <CACHiF8CO59dACuZuY2M4wOWgoXC6-MEZCvu35D_kWX6KE22OqQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ching lu <lsching17@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Thu, 28 Apr 2016, ching lu wrote:

> is there any sysfs attribute storing the list of all attached cache
> devices? i would like to write a script to force flushing cache by
> stopping them all

I don't think so, but you could scan sysfs easy enough.

--
Eric Wheeler



> 
> "echo 1 > /sys/fs/bcache/<cset-uuid>/stop"
> 
> Furthermore, do the statement return only after the cache device is stopped
> or i need to poll until "/sys/fs/bcache/<cset-uuid>/bdev*/state"="clean"
> 
> On Wed, Apr 27, 2016 at 10:10 AM, Eric Wheeler
> <bcache@lists.ewheeler.net> wrote:
> >
> > On Wed, 27 Apr 2016, ching lu wrote:
> >
> >> is there any command for forcing flushing cache or invalidate cache?
> >
> > I think you would benefit from reading this:
> >
> > https://www.kernel.org/doc/Documentation/bcache.txt
> >
> >
> > --
> > Eric Wheeler
> >
> >
> >
> >>
> >> On Wed, Apr 27, 2016 at 3:57 AM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> >> > On Tue, 26 Apr 2016, ching lu wrote:
> >> >
> >> >> Hi all,
> >> >>
> >> >> if i have 1 SSD caching 1 HDD using bcache, the cache mode is writeback
> >> >>
> >> >> if the PC shutdown/unmount normally, will all dirty data in the cache
> >> >> be flushed to backing device before poweroff?
> >> >
> >> > No, it will remain in the cache.
> >> >
> >> >> i am afraid that SSD lose data if left without power for a long time.
> >> >> e.g. hoilday.
> >> >
> >> > Wouldn't your data be retained if you used the SSD alone?  SSDs should be
> >> > stable in a powered off state unless it is a bad device.
> >> >
> >> > There exist RAM-based disks that may be volatile, but that is unlikely to
> >> > be your situation.
> >> >
> >> > --
> >> > Eric Wheeler
> >> >
> >> >>
> >> >> Thanks in advance,
> >> >> C
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
