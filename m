From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Mon, 26 Aug 2013 23:01:43 +0200
Message-ID: <521BC237.9000802@rolffokkens.nl>
References: <521B1E94.8090802@rolffokkens.nl> <kvfs5h$j12$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kvfs5h$j12$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/26/2013 05:27 PM, Gabriel de Perthuis wrote:
> Make path changes if you really need, but udev is supposed to find unqualified
> paths like bcache-register in $udevlibdir ( /lib/udev on debian, possibly
> /usr/lib/udev in fedora).
You're right; works fine without the full path.
>
>> This is the diff:
>>
>> --- bcache-tools-20130820/61-bcache.rules.rules    2013-08-20
>> 22:03:46.000000000 +0200
>> +++ bcache-tools-20130820/61-bcache.rules    2013-08-25
>> 15:53:32.690312711 +0200
>> @@ -5,14 +5,14 @@
>>    ACTION=="remove", GOTO="bcache_end"
>>
>>    # Backing devices: scan, symlink, register
>> -IMPORT{program}="/sbin/blkid -o udev $tempnode"
>> +#IMPORT{program}="/usr/sbin/blkid -o udev $tempnode"
>>    # blkid and probe-bcache can disagree, in which case don't register
>> -ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
>> +#ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache",
>> GOTO="bcache_backing_end"
> Those first two changes should be reverted.
I tried, but with the blkid check first my /dev/bcache* devices are not 
reliably created. I have 2 in total (/dev/bcache0 and /dev/bcach1) and 
with the blkid there's only one after any reboot. Although the name 
varies (bcache0 or bcache1) it actually is always the /dev/bcache* 
device for the 'second' bcache device that is created. second one means: 
the first one is the combi of /dev/sda3 & /dev/sdb1, the second one is 
the combi of /dev/sdc1 and /dev/sdd1. I'm not sure how I can figure out 
what's actually happening during boot.
>
>> -IMPORT{program}="/sbin/probe-bcache -o udev $tempnode"
>> +IMPORT{program}="/usr/sbin/probe-bcache -o udev $tempnode"
> This change isn't broken, though you could make use of any /sbin
> compat symlinks and not carry an upstream delta.
Moved back to using the symlinks, though later on ...
