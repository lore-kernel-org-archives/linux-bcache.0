From: "Garnett, James" <JGarnett@HAP.ORG>
Subject: RE: Bcache on SLES 12
Date: Wed, 9 Mar 2016 19:29:57 +0000
Message-ID: <EDB95D300F23B3448D28C7C92472D214013515F4FD@xchangedb2.HAP.ORG>
References: <EDB95D300F23B3448D28C7C92472D214013515F45F@xchangedb2.HAP.ORG>
 <56E076A8.8050308@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxmail2.hap.org ([70.142.149.11]:21391 "EHLO mxmail2.hap.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbcCITcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 14:32:03 -0500
In-Reply-To: <56E076A8.8050308@evilazrael.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Thanks for the reply, I did not find any documentation on Suse/Novell website to assist with the config, I'm sure they have other customers that would think that bcache does not work or is bugged.

Dependencies should be added to bcache_tools for SLES12 that will point to the specific Development Kit tools i.e. libraries that are needed.

As for me I'll stop the script I created, reboot; and then try modprobe bcache.

Thanks


-----Original Message-----
From: Christoph Nelles [mailto:evilazrael@evilazrael.de] 
Sent: Wednesday, March 09, 2016 2:17 PM
To: Garnett, James <JGarnett@HAP.ORG>; linux-bcache@vger.kernel.org
Subject: Re: Bcache on SLES 12

Hi,

a modprobe bcache would have done the job as the kernel module is not automatically loaded per default on SLES 12.

Regards

Christoph

Am 09.03.2016 um 19:03 schrieb Garnett, James:
> Here is a description of a problem I found with setting up Bcache on SLES 12 and also the fix.
>
> Bcache-tools Version: 0.1.g71-2.12
> Linux Kernel Uname level: 3.12.51-52.39-default
> SuSE-release: VERSION = 12 PATCHLEVEL = 0
>
> Problem: After running make-bcache -B '/dev/sdx' example make-bcache 
> -B /dev/sdb and running 'echo /dev/sdb > /sys/fs/bcache/register'. I received an invalid command error because /sys/fs/bcache/register does not exist.
> I then ran the script '/lib/udev/bcache-register' which still did not create /sys/fs/bcache/register.
>
> Fix: I ran YAST and added /Software/Add-On Products/SUSE Linux Enterprise Software Development Kit 12. After adding a group of libraries automatically installed.
> Afterwards I reran '/lib/udev/bcache-register' which successfully created /sys/fs/bcache/register. Lastly I was able to follow the Getting Started section of the Bcache documentation located at evilpiepirate.
> Upon reboot; /sys/fs/bcache/register still does not exist so I created a script that fixes the problem and mounts /dev/bcach0. See Below:
>
> /lib/udev/bcache-register
> echo /dev/sdb > /sys/fs/bcache/register echo /dev/msdp_images/IMAGES > 
> /sys/fs/bcache/register mount /dev/bcache0 /msdp/images
>
>
> James Garnett
> Sr. Systems Architect
> Health Alliance Plan of Michigan
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-bcache" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
             or http://evilazrael.net/pgp.txt
