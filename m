From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Kernel panic with current bcache-3.2 branch.
Date: Fri, 17 Aug 2012 01:23:32 +0100
Message-ID: <502D8F04.4010502@abpni.co.uk>
References: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw@mail.gmail.com> <20120816233457.GA26564@google.com> <502D8E28.9090401@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502D8E28.9090401-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 17/08/2012 01:19, Jonathan Tripathy wrote:
> On 17/08/2012 00:34, Kent Overstreet wrote:
>> On Thu, Aug 16, 2012 at 06:51:15PM +1000, Joseph Glanville wrote:
>>> Hi list, Kent,
>>>
>>> I caused a crash with the current 3.2 branch under Xen dom0.
>>> By the look of it the swap LV caused the crash?
>> Argh. Strange bug.
>>
>> I wonder if this is related to a bug someone on lkml noticed the other
>> day in my change to the dm code... I see you've got dm_multipath linked
>> in. That would cause memory corruption (underruning allocated memory),
>> which might cause this.
>>
>> I'm going to try and reproduce it too, it might be something simpler.
>> How are things configured? I see raid1 in the call stack, but there must
>> be something else too because raid1 doesn't call bio_pair_split().
>>
> Just to let you guys know that I'm currently compiling the bcache-3.2 
> branch as I type this and will be testing bcache on a Xen Dom0 test 
> bed over the next few weeks. OS is Ubuntu 12.04.x86_64. Xen version 
> will be whatever is in the Ubuntu universe repo (4.1.2). Kent, thanks 
> for your commit within the last hour. Was this to fix Joseph's problem?
>
> Thanks
> -- 
>
I should also add that my backend spindle storage is a MD RAID10 array. 
My to-be cache device is a MD RAID1 array of 2 SSD drives.

Cheers
