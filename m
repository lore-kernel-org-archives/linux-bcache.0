From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Can't register existing backing devices anymore
Date: Sun, 13 Aug 2017 17:20:53 +0000
Message-ID: <cc0b3215845fe34399f72dfcfe897001@889215b17b02>
References: <939a4d7b-add7-08d6-a68d-24c4dc8bd7e7@suse.de>
 <5eef4439-903f-c3f3-1a84-fb2eb8744026@suse.de>
 <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
 <a2cb2667df612d0509f2c60e47ff67c5@889215b17b02>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:56319 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdHMRQv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 13 Aug 2017 13:16:51 -0400
In-Reply-To: <939a4d7b-add7-08d6-a68d-24c4dc8bd7e7@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

August 13, 2017 4:44 PM, "Coly Li" <colyli@suse.de> wrote:


Ok, I managed to mount my fs again by disabling the entries in /etc/crypttab and by manually 'cryptsetup open'-ing one backing device after the other.  As soon as a dev/dm-? becomes available the kernel correctly identifies it as a bcache backing device and automatically registers it. 

But when those devices are listed in /etc/crypttab, I consistently get that behavior I described in the first mail.

Race condition maybe?


   j

   

> 
>> August 13, 2017 4:27 PM, "Coly Li" <colyli@suse.de> wrote:
>> 
>> Hi Coly,
>> 
>>> Could you please give me some hint how the /dev/dm- nodes are created ?
>>> I will try to reproduce it on my hardware.
>>> 
>>> Thanks for the report.
>> 
>> I created them with 'cryptsetup luksFormat ...', IIRC. When I run 'cryptsetup luksDump' I get:
>> 
>> Version: 1
>> Cipher name: aes
>> Cipher mode: xts-plain64
>> Hash spec: sha256
>> Payload offset: 4096
>> MK bits: 256
>> MK digest: <STUFF>
>> MK salt: <STUFF>
>> MK iterations: 400000
>> UUID: 81a8d12e-9309-4317-b447-ab3c86e2f7ea
>> 
>> Key Slot 0: ENABLED
>> Iterations: 3200000
>> Salt: <STUFF>
>> Key material offset: 8
>> AF stripes: 4000
>> 
>> and this is the contents of my /etc/crypttab:
>> 
>> # <name> <device> <password> <options>
>> crypted-sdb /dev/sdb1 /etc/cryptfs.key
>> crypted-sdc /dev/sdc1 /etc/cryptfs.key
>> crypted-sdd /dev/sdd1 /etc/cryptfs.key
>> crypted-sde /dev/sde1 /etc/cryptfs.key
> 
> Oh, I don't use cryptsetup before, let me try ... Thanks for the hint :-)
> 
> Coly Li
