From: Coly Li <colyli@suse.de>
Subject: Re: Can't register existing backing devices anymore
Date: Sun, 13 Aug 2017 23:40:47 +0800
Message-ID: <939a4d7b-add7-08d6-a68d-24c4dc8bd7e7@suse.de>
References: <5eef4439-903f-c3f3-1a84-fb2eb8744026@suse.de>
 <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
 <a2cb2667df612d0509f2c60e47ff67c5@889215b17b02>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750816AbdHMPkx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 13 Aug 2017 11:40:53 -0400
In-Reply-To: <a2cb2667df612d0509f2c60e47ff67c5@889215b17b02>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jorg Bornschein <jb@capsec.org>
Cc: linux-bcache@vger.kernel.org

On 2017/8/13 下午11:40, Jorg Bornschein wrote:
> August 13, 2017 4:27 PM, "Coly Li" <colyli@suse.de> wrote:
> 
> Hi Coly, 
> 
>> Could you please give me some hint how the /dev/dm- nodes are created ?
>> I will try to reproduce it on my hardware.
>>
>> Thanks for the report.
> 
> I created them with 'cryptsetup luksFormat ...', IIRC. When I run 'cryptsetup luksDump' I get:
> 
> Version:       	1
> Cipher name:   	aes
> Cipher mode:   	xts-plain64
> Hash spec:     	sha256
> Payload offset:	4096
> MK bits:       	256
> MK digest:     	<STUFF> 
> MK salt:       	<STUFF> 
> MK iterations: 	400000
> UUID:          	81a8d12e-9309-4317-b447-ab3c86e2f7ea
> 
> Key Slot 0: ENABLED
> 	Iterations:         	3200000
> 	Salt:               	<STUFF> 
> 	Key material offset:	8
> 	AF stripes:            	4000
> 
> 
> and this is the contents of my /etc/crypttab:
> 
> # <name>       <device>         <password>              <options>
> crypted-sdb    /dev/sdb1	/etc/cryptfs.key
> crypted-sdc    /dev/sdc1	/etc/cryptfs.key
> crypted-sdd    /dev/sdd1	/etc/cryptfs.key
> crypted-sde    /dev/sde1	/etc/cryptfs.key

Oh, I don't use cryptsetup before, let me try ... Thanks for the hint :-)

Coly Li
