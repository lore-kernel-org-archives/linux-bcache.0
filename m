From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Fri, 18 Oct 2013 11:56:52 +0200
Message-ID: <CE86CB5C.BB96%rolf@rolffokkens.nl>
References: <20131018092234.GA18159@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131018092234.GA18159-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi all,

We've been waiting to see if other people who couldn't make on Sunday
would also do some testing. That hasn't happened, so a few words on my
impressions on the test day are appropriate indeed.

First of all not many people really did some testing. We didn't expect
many people to participate, but the 3 people who did (many thanks to
them!) were the bare minimum we anticipated. This was probably caused by
the following:
- SSD caching may need more explanation, not many people understand what
it is and what the benefits are
- Because it's hard to change an existing partition to a 'bcached'
partition, it's not really tempting to test (there's a blocks utility
under development that may help, currently backup-restore is the only way).
- Not many people have the required resources available to do testing.
Even when testing in a VM not many people have the required 10GB available
(The requirements could be lowered top about 6GB, so that might help)
- Installing F20 as requested in the prerequisites was harder to the
testers than we anticipated. Specifically planning a specific partition
layout in Anaconda requires a lot of attention (I could upload a VM image
somewhere to facilitate that).

About the testing itself:
- the alignment of the tools (bcache-tools, kernel, util-linux and dracut)
is really good now, people were able to do the testcases (1.A and 1.B)
without a hitch.
- nobody tested the LVM integration (testcases 2.A and 2.B), so no test
results on that part.
- Unfortunately kernel 3.11.4 (which was the latest version on Sunday)
exhibited a bug during stress testing
(https://bugzilla.redhat.com/show_bug.cgi?id=1018615), but that bug is
supposed to be fixed in kernel 3.11.5 which was released later this week.

So I think SSD Caching (using bcache) is in a good shape, but I would like
to encourage people to do some more testing. Of course other feedback is
also appreciated.

Thanks,

Rolf

Op 10/18/13 11:22 AM schreef Piergiorgio Sartor
<piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>:

>On Thu, Sep 26, 2013 at 11:56:25AM +0200, Rolf Fokkens wrote:
>[...]
>> The SSD Cache Fedora test day
>> =============================
>> On 13th of October there's an "SSD Cache Fedora test day": see the
>> Wiki page
>> https://fedoraproject.org/wiki/Test_Day:2013-10-13_SSD_Cache. This
>> page is work in progress, any feedback is welcome. People interested
>> in testing are invited to participate on 13th of October.
>> 
>> When there's anything new toreport, I'll keep you posted.
>
>Hi Rolf,
>
>could you spend few words about the results
>of the SSD Cache Fedora test day?
>
>Anything interesting or surprising happened?
>Any disappointment?
>
>Thanks,
>
>bye,
>
>-- 
>
>piergiorgio
