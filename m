From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: Bcache on SLES 12
Date: Wed, 9 Mar 2016 20:16:56 +0100
Message-ID: <56E076A8.8050308@evilazrael.de>
References: <EDB95D300F23B3448D28C7C92472D214013515F45F@xchangedb2.HAP.ORG>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from evilazrael.net ([5.10.172.2]:44820 "EHLO mail.evilazrael.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbcCITRQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 14:17:16 -0500
In-Reply-To: <EDB95D300F23B3448D28C7C92472D214013515F45F@xchangedb2.HAP.ORG>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Garnett, James" <JGarnett@HAP.ORG>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

a modprobe bcache would have done the job as the kernel module is not 
automatically loaded per default on SLES 12.

Regards

Christoph

Am 09.03.2016 um 19:03 schrieb Garnett, James:
> Here is a description of a problem I found with setting up Bcache on SLES 12 and also the fix.
>
> Bcache-tools Version: 0.1.g71-2.12
> Linux Kernel Uname level: 3.12.51-52.39-default
> SuSE-release: VERSION = 12 PATCHLEVEL = 0
>
> Problem: After running make-bcache -B '/dev/sdx' example make-bcache -B /dev/sdb and running
> 'echo /dev/sdb > /sys/fs/bcache/register'. I received an invalid command error because /sys/fs/bcache/register does not exist.
> I then ran the script '/lib/udev/bcache-register' which still did not create /sys/fs/bcache/register.
>
> Fix: I ran YAST and added /Software/Add-On Products/SUSE Linux Enterprise Software Development Kit 12. After adding a group of libraries automatically installed.
> Afterwards I reran '/lib/udev/bcache-register' which successfully created /sys/fs/bcache/register. Lastly I was able to follow the Getting Started section of the Bcache documentation located at evilpiepirate.
> Upon reboot; /sys/fs/bcache/register still does not exist so I created a script that fixes the problem and mounts /dev/bcach0. See Below:
>
> /lib/udev/bcache-register
> echo /dev/sdb > /sys/fs/bcache/register
> echo /dev/msdp_images/IMAGES > /sys/fs/bcache/register
> mount /dev/bcache0 /msdp/images
>
>
> James Garnett
> Sr. Systems Architect
> Health Alliance Plan of Michigan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
             or http://evilazrael.net/pgp.txt
