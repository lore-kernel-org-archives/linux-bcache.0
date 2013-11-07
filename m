From: Yuxuan Shui <yshuiv7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache causes data lose.
Date: Thu, 7 Nov 2013 17:36:32 +0000
Message-ID: <CAGqt0zwq9COvxw-dBn0CNxBSsWEJEagQ_yR=UBXGuzi83K2zVA@mail.gmail.com>
References: <CAMJW5=23t=jQRObnB5NHU8hTRBg6bCyW2m0+HCgtS8dxd82rRg@mail.gmail.com>
	<527B9064.6050902@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527B9064.6050902-J5qI5MFTcs8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I was running 3.11.6 when I first saw this. And I tried 3.12, same
problem. Only with 3.12 when this happen there's a line like "bcache
spotted bad key" in dmesg.

On Thu, Nov 7, 2013 at 1:06 PM, Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org> wrote:
> Which kernel are you running?  I had very similar problems with all 3.11
> kernels below 3.11.5; kernel 3.11.5 works just fine for me.  The 3.10
> kernels also seemed to be okay, but the mailing list has suggested that they
> may have some "time bomb" bugs, so you should probably be running 3.11.5 or
> newer.
>
> Cheers,
>
> Zach
>>
>> Hi,
>>
>> I'm trying bcache for the past two days. And I observed several data
>> corruptions.
>>
>> This happens with both writeback and writethrough cache. After reboot,
>> I saw my filesystem corrupted. With writeback cache, there's no way to
>> recover it. With writethrough cache, after I detach the backing device
>> from the cache set, I can mount my filesystem again. So I think this
>> is cleanly a bcache bug.
>>
>> I don't know if above information is enough, if you need to anything,
>> I'll do my best to provide
>>
>> Regards,
>> Yuxuan Shui.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
