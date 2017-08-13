From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Can't register existing backing devices anymore
Date: Sun, 13 Aug 2017 15:40:47 +0000
Message-ID: <a2cb2667df612d0509f2c60e47ff67c5@889215b17b02>
References: <5eef4439-903f-c3f3-1a84-fb2eb8744026@suse.de>
 <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:51244 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750816AbdHMPgp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 13 Aug 2017 11:36:45 -0400
In-Reply-To: <5eef4439-903f-c3f3-1a84-fb2eb8744026@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

August 13, 2017 4:27 PM, "Coly Li" <colyli@suse.de> wrote:

Hi Coly, 

> Could you please give me some hint how the /dev/dm- nodes are created ?
> I will try to reproduce it on my hardware.
> 
> Thanks for the report.

I created them with 'cryptsetup luksFormat ...', IIRC. When I run 'cryptsetup luksDump' I get:

Version:       	1
Cipher name:   	aes
Cipher mode:   	xts-plain64
Hash spec:     	sha256
Payload offset:	4096
MK bits:       	256
MK digest:     	<STUFF> 
MK salt:       	<STUFF> 
MK iterations: 	400000
UUID:          	81a8d12e-9309-4317-b447-ab3c86e2f7ea

Key Slot 0: ENABLED
	Iterations:         	3200000
	Salt:               	<STUFF> 
	Key material offset:	8
	AF stripes:            	4000


and this is the contents of my /etc/crypttab:

# <name>       <device>         <password>              <options>
crypted-sdb    /dev/sdb1	/etc/cryptfs.key
crypted-sdc    /dev/sdc1	/etc/cryptfs.key
crypted-sdd    /dev/sdd1	/etc/cryptfs.key
crypted-sde    /dev/sde1	/etc/cryptfs.key
 

best & thanks!



   j
