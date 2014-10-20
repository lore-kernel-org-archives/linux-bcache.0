From: Tero Marttila <tero.marttila@paivola.fi>
Subject: Re: initramfs issues with mdraid/bcache-tools/lvm2 on debian wheezy-backports
 3.16
Date: Mon, 20 Oct 2014 12:46:22 +0300
Message-ID: <5444D9EE.4070904@paivola.fi>
References: <54394FD1.4090708@paivola.fi> <m1pfh2$ltn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from tonttu.paivola.fi ([194.197.235.227]:33097 "EHLO
	tonttu.paivola.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaJTJqb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 20 Oct 2014 05:46:31 -0400
Received: from [10.232.174.228] (host86-187-4-27.range86-187.btcentralplus.com [86.187.4.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by tonttu.paivola.fi (Postfix) with ESMTPSA id 452A21F72F
	for <linux-bcache@vger.kernel.org>; Mon, 20 Oct 2014 12:46:25 +0300 (EEST)
In-Reply-To: <m1pfh2$ltn$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


On 17/10/14 01:06, Ian Pilcher wrote:
> On 10/11/2014 10:42 AM, Tero Marttila wrote:
>>
>> part seems to give (based on udev_log="debug" output):
>>
>> 	write error: Invalid arument
>>
>> without any additional info in dmesg.
>>
>> However, running the identical command:
>>
>> 	/lib/udev/bcache-register /dev/md0
>>
>> by hand a short while later from within the initramfs prompts works..
>>
>
> This sounds like the error I reported back in July:
>
>    http://article.gmane.org/gmane.linux.kernel.bcache.devel/2594
>

Quite likely, although for whatever reason I didn't see any bcache 
register dmesgen. The retry-on-EBUSY approach sounds like it would 
resolve this, I'll need to have a go at testing it.

Ref the debian wheezy mdadm-initramfs bug, the udev settle fix would be 
required for any solution that makes the udev bcache-register hook wait. 
Seems like it has been fixed in jessie mdadm-3.3, but anyone using 
mdraid/bcache/lvm on wheezy will require some form of initramfs hacks.

  -- Tero Marttila
