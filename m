From: Zachary Palmer <zachary.palmer-J5qI5MFTcs8@public.gmane.org>
Subject: Re: Linux 3.11-rc4 Writeback Cache Corruption
Date: Wed, 04 Sep 2013 23:16:04 -0400
Message-ID: <5227F774.7010002@bahj.com>
References: <52265410.4010000@bahj.com> <522656EC.8040002@gmail.com> <5227F74F.5000305@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5227F74F.5000305-J5qI5MFTcs8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Whoops; forgot to send this e-mail to the whole list.  :)
> So I have some unfortunate test results regarding this corruption 
> issue.  I tested my laptop on two kernels I built today.  The 
> procedure was as follows:
>
>     1. Check out bcache-3.10-stable.  Kernal was build using the 
> .config I have for Debian package 
> linux-image-3.10-0.bpo.2-686-pae=3.10.5-1~bpo70+1.  All new options 
> were left at defaults.
>     2. Begin by checking out bcache git repository at 
> bcache-for-3.11.  Next, add Linux stable git as an origin.  Then, "git 
> br temp; git co temp; git merge linux-3.11.y".  The merge applies 
> automatically.  Build the resulting kernel, again using the above 
> .config with all new options left at defaults.
>
> My hope was that one of these two kernels would resolve both (a) the 
> cache corruption issue and (b) my hibernate/suspend problem. This did 
> not appear to be the case.  Using kernel #2 above (Linux 3.11.0), 
> cache corruption was immediately evident; both apt-cacher and MySQL 
> failed to start due to segfaults.  Cache corruption was resolved by 
> detaching and reattaching the cache device under a clean kernel.
>
> Using kernel #1 above, I get the same results as the Debian stock 
> kernel for Wheezy backports (the one from the package named above): 
> bcache seems to work just fine until the kernel attempts to stop 
> devices for suspend, hibernate, or shutdown; at this point, bcache 
> times out waiting for the device to stop and the laptop never changes 
> power states.
>
> For the time being, it is easier for me to live without 
> suspend/hibernate than it is for me to migrate back to a cacheless 
> layout; moving all of that data around is time-consuming and I really 
> want to use bcache.  :)  If there is any information I could collect 
> with my machine that would help in the debugging process, please let 
> me know!
>
> Thanks,
>
> Zach
>> [This mail was also posted to gmane.linux.kernel.bcache.devel.]
>>
>> On Tue, 03 Sep 2013 17:26:40 -0400, Zachary Palmer wrote:
>>> So here's the question: how would I best go about testing this patch?
>>> In looking through the git history, it doesn't seem as if the
>>> bcache-for-3.11 branch has been synced against the Linux git since
>>> 3.10-rc7 (on June 22nd).  I was thinking I could
>>>
>>>       * Pull the Linux kernel source
>>>       * Add the bcache git as an origin
>>>       * Merge the bcache-for-3.11 branch into the Linux 3.11 mainline
>>> branch myself and
>>>       * Assuming that this works, compile and boot the resulting kernel
>>> using my Debian kernel .config
>>>
>>> Does this sound reasonable?  Or is there a better way to do this? I'm
>>> pretty happy with whatever gives me at least the behavior of my 
>>> mainline
>>> 3.10 kernel and I'm looking forward to getting bcache and laptop power
>>> modes on the same machine.  :)
>> Yeah, it'll merge cleanly.  You can reuse the .config and build with
>> `make deb-pkg -j -l6`, which is slowly replacing make-kpkg 
>> functionality.
>>
>>
>
