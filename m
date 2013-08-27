From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 11:45:55 +0000 (UTC)
Message-ID: <kvi3hj$nvo$1@ger.gmane.org>
References: <521B1C5E.2090007@rolffokkens.nl>
	<20130826214155.GA2798@kmo-pixel> <521C4E2B.8090008@rolffokkens.nl>
	<521C78B8.7060402@grnet.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 27 Aug 2013 13:00:24 +0300, Alex Pyrgiotis wrote:
> On 08/27/2013 09:58 AM, Rolf Fokkens wrote:
>> -modprobe -qba bcache
>> +/sbin/modprobe -qba bcache
>>   test -f /sys/fs/bcache/register_quiet && echo "$1" > 
>> /sys/fs/bcache/register_quiet
>> 
>> /sbin is not in the $PATH for utilities started from udev. For Fedora it 
>> isn't anyway, but it won't harm other distro's neither.
>> 
> 
> Hi all,
> 
> Pardon the interrupt, but this is not the case for Arch Linux:
> https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/
> 
> In my opinion, if modprobe *has* to be called with the exact path name,
> it would probably be clearer to use `which modprobe` and then call the
> result.

IME the exact path name is unnecessary.
Rolf, your best shot at contributing is to bring up problems that have
actually been encountered on Fedora.  Changes need to come as a side
effect of discussions, not the other way around.
