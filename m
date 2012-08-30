From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Expected Behavior
Date: Thu, 30 Aug 2012 23:59:39 +0100
Message-ID: <503FF05B.1040506@abpni.co.uk>
References: <503F132E.6060305@abpni.co.uk> <503F147A.10101@abpni.co.uk> <239802233aa1dabc37f60b293d2941c9@abpni.co.uk> <20120830212841.GB14247@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120830212841.GB14247-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 30/08/2012 22:28, Kent Overstreet wrote:
> On Thu, Aug 30, 2012 at 01:18:54PM +0100, Jonathan Tripathy wrote:
>> On 30.08.2012 08:21, Jonathan Tripathy wrote:
>>> On 30/08/2012 08:15, Jonathan Tripathy wrote:
>>>> Hi There,
>>>>
>>>> On my WIndows DomU (Xen VM) which is running on a LV which is
>>>> using bcache (against two SSD in MDRAID1 and a MD-RAID10 spindle
>>>> array), I ran an IOMeter test for about 2 hours (with 30 workers
>>>> and a io depth of 256). This was a very heavy workload (Got an
>>>> average iops of about 6.5k). After I stopped the test, I then
>>>> went back to fio on my Linux Xen Host (Dom0). The random write
>>>> performance isn't as good as it was before I started the IOMeter
>>>> test. It used to be about 25k and now showed about 7k iops. I
>>>> assumed that maybe this was due to the fact that bcache was
>>>> writing out dirty data to the spindles so the SSD was busy.
>>>>
>>>> However, this morning, after the spindles have calmed down,
>>>> performance of fio is still not great (still about 7k).
>>>>
>>>> Is there something wrong here? What is expected behavior?
>>>>
>>>> Thanks
>>>>
>>> BTW, I can confirm that this isn't an SSD issue, as I have a
>>> partition on the SSD that I kept seperate from bcache and I'm getting
>>> excellent (about 28k) iops performance there.
>>>
>>> It's as if after the heavy workload I did with IOMeter, bcache has
>>> somehow throttled the writeback cache?
>>>
>>> Any help is appreciated.
>>>
>> I'd like to add that a reboot pretty much solves the issue. This
>> leads me to believe that there is a bug in the bcache code that
>> causes performance to drop the more it gets used.
>>
>> Any ideas?
> Weird!
>
> Yeah, that definitely sounds like a bug. I'm going to have to try and
> reproduce it and go hunting. Can you think of anything that might help
> with reproducing it?
> -
Hi Kent,

I'm going to try and reproduce it myself as well. I just used IOMeter in 
a Windows DomU with 30 workers, each having an io depth of 256. A *very* 
heavy workload indeed, but my point was to see if I could break 
something. Unless the issue is specific to windows causing problems 
(NTFS or whatever), I'm guessing running fio with 30 jobs and an iodepth 
of 256 would probably produce a similar load.

BTW, do you have access to a Xen node for testing?

Thanks
