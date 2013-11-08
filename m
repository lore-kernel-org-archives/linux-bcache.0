From: Yuxuan Shui <yshuiv7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache causes data lose.
Date: Fri, 8 Nov 2013 04:13:58 +0000
Message-ID: <CAGqt0zy08jmT5NW62OEwV_1nH1aeN=ZYW7XiD9UwG3TSRk4R8A@mail.gmail.com>
References: <CAMJW5=23t=jQRObnB5NHU8hTRBg6bCyW2m0+HCgtS8dxd82rRg@mail.gmail.com>
	<20131107202211.GG3842@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131107202211.GG3842@kmo>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Nov 7, 2013 at 8:22 PM, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Thu, Nov 07, 2013 at 10:39:39AM +0000, Yuxuan Shui wrote:
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
>
> That's not good :/ Can you tell me everything that's in your setup? md/lvm/what
> drivers you're using for your drives/anything else that might be relevant...

I'm running a almost fresh Archlinux installation, first with a 3.11.6
kernel then updated to 3.12.

My SSD drive is Samsung 840EVO 120G. I'm not using md or lvm, just
btrfs on top of bcache.
