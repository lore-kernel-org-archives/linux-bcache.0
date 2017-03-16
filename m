From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs] problem with `bcache fsck`
Date: Thu, 16 Mar 2017 23:07:20 +0100
Message-ID: <f7e0b5acca043eff08a55f424470221d@mejor.pl>
References: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
 <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:12870 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752017AbdCPWIU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Mar 2017 18:08:20 -0400
In-Reply-To: <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2017-03-16 21:34, Kent Overstreet napisał(a):
> On Thu, Mar 16, 2017 at 04:16:29PM +0100, Marcin wrote:
>> Hi!
>> It's good to hear that silence on mailinglist doesn't mean that there 
>> is no
>> changes in developing bcachefs!
> 
> Join the irc channel! It's pretty active.

Done.


>> Is bcache fsck able to do fsck on tiered devices?
> 
> Yes - just pass it all the devices, e.g.
> bcache fsck /dev/sdb /dev/sdc
> 
> Also, keep in mind fsck is still run by default at mount time, there's 
> normally
> no need to use userspace fsck (and running fsck in userspace and then 
> mounting
> will be slower than just mounting and running fsck then, due to mount 
> still
> having to scan all the metadata which will be cache cold).

If I add bcachefs to fstab openrc expects userland fsck to works this is 
why I tried it to use.

>> I know that there is some stability problem with tiered devices 
>> because when
>> I mounted tiered fs and started to copy files on it the host rebooted 
>> after
>> some time. I have to run netconsole to catch what kernel says, then I 
>> post
>> it on ML.
> 
> You might have been hitting a bug in a recent patch to improve 
> readpages
> performance - I backed it out last night after I discovered it.

There is no new commit, I'm at
commit 7274700edcf99ab67d4f72eca4f07d0220b9abae
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Tue Mar 14 21:07:39 2017 -0800

     bcache: fix device hot add


I suspect that problem is due to using  --metadata_replicas=2. If you 
have a some spare time please try fileystsem formated with this 
parameters:
# bcache format --compression_type=gzip --metadata_replicas=2 
--data_checksum_type=crc64 --metadata_checksum_type=crc64 --tier=2 
/dev/sde1 --tier=3 /dev/sdd1



>> And I'm still missing compression saves free space on disk:)
> 
> Yeah, that's something I've been wanting to get to, but people have 
> been
> badgering me for replication more :)

You have implemented too many features, everyone find something usefull 
for self and want to have it. You should implement only writing and 
reading to/from files;)

Btw:
# curl https://evilpiepirate.org/git/bcache-tools.git/
curl: (51) SSL: no alternative certificate subject name matches target 
host name 'evilpiepirate.org'


Marcin
