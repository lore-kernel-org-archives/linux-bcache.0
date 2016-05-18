From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: block size question
Date: Wed, 18 May 2016 09:11:25 +0200
Message-ID: <573C159D.20806@megasoft.be>
References: <573C02B3.5010501@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53296 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcERHLc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 03:11:32 -0400
In-Reply-To: <573C02B3.5010501@net.home>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vlad <vovan@vovan.nl>, linux-bcache@vger.kernel.org

The blocksize should be equal or bigger then the blocking device.
Otherwise you risk writing multiple blocks 512 for 1 1k sector, resulting in read-modify-write transaction on 4k disks.

But for some reason I didn't do this on my desktop.
(I might need to reformat if i'm right about this :( )


Killian De Volder
On 18-05-16 07:50, Vlad wrote:
> Hallo,
> 
> What would be the optimal block size in case if physical block sizes
> different for cache and backing devices? Can I use different block sizes
> for cache and backing devices, like:
> make-bcache --block 4k -B /dev/sdc
> make-bcache --block 512 -C /dev/sda
> 
> I have a feeling that the block size should be the same and the biggest
> block size should be used, but I'd appreciate any thoughts about that.
> 
> Thanks in advance,
> Vlad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
