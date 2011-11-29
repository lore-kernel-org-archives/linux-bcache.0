From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Tue, 29 Nov 2011 15:31:48 +0800
Message-ID: <4ED48A64.4080406@fnarfbargle.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com> <4ED47771.9030309@fnarfbargle.com> <20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111129063126.GA14194-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 29/11/11 14:31, Kent Overstreet wrote:


>> I need to use this :
>> for i in /dev/sd? /dev/md* ; do [ -n "`/sbin/probe-bcache $i`" ]&&
>> echo $i>  /sys/fs/bcache/register_quiet ; done
>>
>> Now, it does not actually need the test in there, however that stops
>> it spewing "write error: Invalid argument" onto the console when you
>> echo a device that does not have a bcache superblock.
>>
>> It does NOT like you accidentally trying to register a device twice :
>
> Eesh. That's annoying.
>
> I suppose really the bcache symlink in the /sys/block/bcacheN directory
> is incorrect - without that stacking _ought_ to work and I'm not sure
> it's possible to reliably detect stacking anyways.

I'm not sure that stacking is the issue. I simply did

echo /dev/md10 > /sys/fs/bcache/register
echo /dev/md10 > /sys/fs/bcache/register

at that point it all came crashing down. I'd have thought simply 
detecting that a particular device was already registered would solve 
the problem.

> Very annoying though - that symlink is very handy. Argh.
>
> hm. maybe I could check the make_request_fn to detect stacking and
> prevent it that way...
>
> No other issues, I take it?

Well, I had intended to run some tests with it stacked on top of md, but 
as I pointed out in the last oops in my prior mail, every time I try and 
attach the cache set to /dev/md10 the machine panics, so I've not really 
progressed to actually trying things out. I figured re-running the tests 
I'd already run with it stacked on a single drive was pretty pointless.

Regards,
Brad
