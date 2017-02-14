From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Tue, 14 Feb 2017 12:05:48 +0100
Message-ID: <20170214120548.Horde.jjkocB4OpTXTQseeIy0JLve@www3.nde.ag>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
 <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
 <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag>
 <20170208005732.207098f6@jupiter.sol.kaishome.de>
 <alpine.LRH.2.11.1702091335000.5783@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:17166 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdBNLFv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2017 06:05:51 -0500
In-Reply-To: <alpine.LRH.2.11.1702091335000.5783@mail.ewheeler.net>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

Hi *,

Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:
> On Wed, 8 Feb 2017, Kai Krakow wrote:
> [...]
>> What I meant is "make-bcacke --block X". It defaults to X=512b. I think
>> you may want to force it to 4k and see if your problem persists.
>
> Maybe --block 4096 should be default in make-bcache?
>
> Kent, is there any reason this wouldn't be a good idea?

actually, make-bcache seems not to default to 512 octets. If no  
specific block size is specified on the command line, it determines  
the maximum sector size of the devices involved:

--- cut here ---
if (!block_size) {
		for (i = 0; i < ncache_devices; i++)
			block_size = max(block_size,
					 get_blocksize(cache_devices[i]));

		for (i = 0; i < nbacking_devices; i++)
			block_size = max(block_size,
					 get_blocksize(backing_devices[i]));
}
--- cut here ---

get_blocksize() queries the logical block size as reported by the  
device ( ioctl(fd, BLKSSZGET, &logical_block_size) ).

At least that's what I see at  
https://github.com/g2p/bcache-tools/blob/master/make-bcache.c, said to  
be from Apr 16, 2014. And it seems to be the reason why invoking  
"make-bcache -B ... -C ..." did create a proper setup for me, while  
separating that to "make-bcache -B ..." and "make-bcache -C ..."  
created a wrongly set up caching device for me (backing device has 4k  
sector size, caching device 512b).

Regards,
J
