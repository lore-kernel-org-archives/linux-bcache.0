From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: Re: bcache and hibernation
Date: Thu, 13 Nov 2014 18:23:42 +0100
Message-ID: <87zjbvvwtd.fsf@bluescreen303.nl>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
	<878ujfxflg.fsf@bluescreen303.nl>
	<CAPBO7TZF5qUV64UZJVE+WQkKa2aCJSTjkQxh6eVktH7nA41Vqw@mail.gmail.com>
	<874mu3xcum.fsf@bluescreen303.nl>
	<CAPBO7TbQA2MbFS43racKOwZ+=U2jC4OcLF413-MvvNKML5=QZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55207 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaKMRXp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Nov 2014 12:23:45 -0500
Received: by mail-wi0-f169.google.com with SMTP id n3so2636453wiv.0
        for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2014 09:23:44 -0800 (PST)
In-Reply-To: <CAPBO7TbQA2MbFS43racKOwZ+=U2jC4OcLF413-MvvNKML5=QZQ@mail.gmail.com>
	(Josep Lladonosa's message of "Thu, 13 Nov 2014 18:06:25 +0100")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Josep Lladonosa <jlladono@gmail.com>
Cc: linux-bcache@vger.kernel.org

Josep Lladonosa <jlladono@gmail.com> writes:

> On 13 Nov 2014 17:52, "Mathijs Kwik" <mathijs@bluescreen303.nl> wrote:
>>
>> Josep Lladonosa <jlladono@gmail.com> writes:
>>
>> > On 13 November 2014 16:52, Mathijs Kwik <mathijs@bluescreen303.nl>
> wrote:
>> >
>> >> As a followup question:
>> >>
>> >> Is there a safe way to use hiberation in the presence of bcache?
>> >>
>> >
>> > Hello,
>> >
>> > I am using (just now) a laptop with root filesystem on a bcache
> partition,
>> > a separate boot partition (non bcache, small) and a swap partition used
> for
>> > hibernation and it works perfectly.
>>
>> I'm glad to hear that. So how does your system boot/resume?
>> Does the initrd postpone registering/activating bcache until after the
>> resume-check? Or are my assumptions just wrong?
>
> I do not know. Worked without any special setup.

Well that's nice, but I would like to know for sure this is guaranteed
to be safe :)

>
> System boots as usual, but during kernel boot it finds a hibernation in
> swap area and just restores it.

I understand how suspend works. My question is regarding the steps
_before_ finding the hibernation image. My guess is there are situations
where detecting/activating a bcache device before restoring the
hibernation image can lead to disaster.

So either this is not the case (I would like an explanation why), or I
need a way to make sure udev does not register bcache before resuming.




>
>>
>>
>> >
>> > Josep
>> >
>> >
>> >>
>> >> Assuming a (initrd) boot procedure should at least wait for the
>> >> hard-disk to settle, this will mean some udev rules will fire...
>> >> With the bcache udev rules in place, this means activating/attaching a
>> >> cache+backing device. Am I assuming correctly that this might
>> >> immediately lead to on-disk changes (writeback dirty pages for
> example)?
>> >>
>> >> So what's the way to go?
>> >> Make sure the bcache module doesn't get loaded when resuming from
>> >> hibernation? Tell udev not to activate the device automatically until
> we
>> >> check for a resume-image?
>> >>
>> >>
>> >>
>> >>
>> >>
>> >> Mathijs Kwik <mathijs@bluescreen303.nl> writes:
>> >>
>> >> > Hi all,
>> >> >
>> >> > Today, I lost most my data (don't worry, got backups) after the cache
>> >> > got corrupted somehow. I suspected a recent suspend-to-disk to be the
>> >> > cause. I checked how my distribution (NixOS) handles suspend/resume
> and
>> >> > I have some concerns about how bcache fits into this.
>> >> >
>> >> > Normally, the kernel and initrd get loaded. The initrd loads required
>> >> > kernel modules, waits for udev to settle, activates luks&lvm, then
>> >> > finally asks the kernel to resume from the resume device.
>> >> >
>> >> > The kernel documentation on suspend is VERY clear you should NOT
> touch
>> >> > anything on disk between suspend and resume. So activating luks and
> LVM
>> >> > is probably risky already, but it apppears both luks and LVM do not
> make
>> >> > any on-disk changes when activated and any in-memory state (within
> the
>> >> > resumed image) is still valid. The benefit of activating luks and LVM
>> >> > before resume seems to be that it allows resuming from encrypted/lvm
>> >> > volumes.
>> >> >
>> >> > Now, with bcache added, things probably get a bit hairy. NixOS
> supports
>> >> > bcache inside the initrd and uses udev rules to activate/attach. I
>> >> > suspect this is probably unsafe. Probably bcache starts to see if any
>> >> > dirty pages exist, to write them to the backing store. Even without
>> >> > writeback caching, the activation of lvm will read some sectors,
> which
>> >> > might trigger the cache to update. Then after resuming the image, the
>> >> > in-memory state is corrupted and further damage occurs.
>> >> >
>> >> > - Does this sound plausible?
>> >> > - Is there any way to tell bcache to make absolutely no changes to
>> >> >   either the backing device or the cache?
>> >> >   Basically like a readaround+writearound which can be triggered on
>> >> >   hibernate and switched off on resume.
>> >> >
>> >> > Thanks,
>> >> > Mathijs
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
