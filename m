From: "Garnett, James" <JGarnett@HAP.ORG>
Subject: Bcache on SLES 12
Date: Wed, 9 Mar 2016 18:03:17 +0000
Message-ID: <EDB95D300F23B3448D28C7C92472D214013515F45F@xchangedb2.HAP.ORG>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxmail1.hap.org ([70.142.149.10]:16826 "EHLO mxmail1.hap.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbcCISFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 13:05:22 -0500
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Here is a description of a problem I found with setting up Bcache on SLES 12 and also the fix.

Bcache-tools Version: 0.1.g71-2.12
Linux Kernel Uname level: 3.12.51-52.39-default
SuSE-release: VERSION = 12 PATCHLEVEL = 0

Problem: After running make-bcache -B '/dev/sdx' example make-bcache -B /dev/sdb and running 
'echo /dev/sdb > /sys/fs/bcache/register'. I received an invalid command error because /sys/fs/bcache/register does not exist.
I then ran the script '/lib/udev/bcache-register' which still did not create /sys/fs/bcache/register.

Fix: I ran YAST and added /Software/Add-On Products/SUSE Linux Enterprise Software Development Kit 12. After adding a group of libraries automatically installed.
Afterwards I reran '/lib/udev/bcache-register' which successfully created /sys/fs/bcache/register. Lastly I was able to follow the Getting Started section of the Bcache documentation located at evilpiepirate.
Upon reboot; /sys/fs/bcache/register still does not exist so I created a script that fixes the problem and mounts /dev/bcach0. See Below:

/lib/udev/bcache-register
echo /dev/sdb > /sys/fs/bcache/register
echo /dev/msdp_images/IMAGES > /sys/fs/bcache/register
mount /dev/bcache0 /msdp/images


James Garnett
Sr. Systems Architect
Health Alliance Plan of Michigan
