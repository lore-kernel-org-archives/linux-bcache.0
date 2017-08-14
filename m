From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Can't register existing backing devices anymore
Date: Mon, 14 Aug 2017 17:17:33 +0000
Message-ID: <ea1407caa97c70adbe6a3441d88c3ad8@889215b17b02>
References: <939a4d7b-add7-08d6-a68d-24c4dc8bd7e7@suse.de>
 <5eef4439-903f-c3f3-1a84-fb2eb8744026@suse.de>
 <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
 <a2cb2667df612d0509f2c60e47ff67c5@889215b17b02>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:58284 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdHNRNd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 14 Aug 2017 13:13:33 -0400
In-Reply-To: <939a4d7b-add7-08d6-a68d-24c4dc8bd7e7@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

August 13, 2017 4:44 PM, "Coly Li" <colyli@suse.de> wrote:

Hi Coly, 


were you able to reproduce my problem?


   j 


> On 2017/8/13 下午11:40, Jorg Bornschein wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
