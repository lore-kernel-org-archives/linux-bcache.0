From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 14:02:40 +0200
Message-ID: <521C9560.2020603@rolffokkens.nl>
References: <521B1C5E.2090007@rolffokkens.nl> <20130826214155.GA2798@kmo-pixel> <521C4E2B.8090008@rolffokkens.nl> <521C78B8.7060402@grnet.gr> <kvi3hj$nvo$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kvi3hj$nvo$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Gabriel, I might have been unclear about this, but this __IS__ a problem 
on Fedora. Without a full path for modprobe (/sbin/modprobe or 
/usr/sbin/modprobe) in bcache-register, udev does not create the 
/dev/bcache* devices. So at the moment I fix it in the package.

If this is however Fedora specific I'll have the fix it in the package 
of course. But it's hard for me to tell, and /sbin/modprobe seemed like 
a cross-distro solution to me.

On 08/27/2013 01:45 PM, Gabriel de Perthuis wrote:
> On Tue, 27 Aug 2013 13:00:24 +0300, Alex Pyrgiotis wrote:
>> On 08/27/2013 09:58 AM, Rolf Fokkens wrote:
>>> -modprobe -qba bcache
>>> +/sbin/modprobe -qba bcache
>>>    test -f /sys/fs/bcache/register_quiet && echo "$1" >
>>> /sys/fs/bcache/register_quiet
>>>
>>> /sbin is not in the $PATH for utilities started from udev. For Fedora it
>>> isn't anyway, but it won't harm other distro's neither.
>>>
>> Hi all,
>>
>> Pardon the interrupt, but this is not the case for Arch Linux:
>> https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/
>>
>> In my opinion, if modprobe *has* to be called with the exact path name,
>> it would probably be clearer to use `which modprobe` and then call the
>> result.
> IME the exact path name is unnecessary.
> Rolf, your best shot at contributing is to bring up problems that have
> actually been encountered on Fedora.  Changes need to come as a side
> effect of discussions, not the other way around.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
