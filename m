From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Tue, 14 Feb 2017 11:52:45 +0100
Message-ID: <20170214115245.Horde.cCYA8my4OTp7nnDzpZShDYe@www3.nde.ag>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
 <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
 <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag>
 <20170208005732.207098f6@jupiter.sol.kaishome.de>
 <20170210115700.Horde.IQLnhCcS8ohxmn7nYsuxBaj@www3.nde.ag>
 <alpine.LRH.2.11.1702101127170.5783@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:35394 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752384AbdBNKwu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2017 05:52:50 -0500
In-Reply-To: <alpine.LRH.2.11.1702101127170.5783@mail.ewheeler.net>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi Eric,

Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:
> On Fri, 10 Feb 2017, Jens-U. Mozdzen wrote:
> [...]
>> myserver:~ # blockdev --getss /dev/md125
>> 4096
>>
>> - created the bcache super block
>>
>> myserver:~ # make-bcache -B --block 4096b /dev/md125
>> UUID:                   05d4d36a-ef17-4ecb-99d4-0a0eeec03941
>> Set UUID:               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
>> version:                1
>> block_size:             8
>> data_offset:            16
>> myserver:~ # bcache-super-show /dev/md125
>> sb.magic                ok
>> sb.first_sector         8 [match]
>> sb.csum                 F4E616E067FA3C45 [match]
>> sb.version              1 [backing device]
>>
>> dev.label               (empty)
>> dev.uuid                05d4d36a-ef17-4ecb-99d4-0a0eeec03941
>> dev.sectors_per_block   8
>> dev.sectors_per_bucket  1024
>> dev.data.first_sector   16
>> dev.data.cache_mode     0 [writethrough]
>> dev.data.cache_state    0 [detached]
>>
>> cset.uuid               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
>> myserver:~ # [...]
>>
>> Why does it report 8 sectors per block? With 4k per sector, that'd  
>> be a block
>> size of 32k?
>
> Its in 512b units and 8*512=4096.  Lots of things are in units of 512 even
> though your block size is 4096.  Its correct, it just looks funny since
> you have 4k sectors.

first of all, thank you for that information, I succeeded in setting  
up that specific bcache scenario, have populated it and found no  
problems so far.

Once I had a few spare minutes, I double-checked the source code of  
make-bcache and bcache-show-super and indeed, there's hardcoded the  
factor of 512 bytes. Nothing wrong with that, but I strongly suggest  
to change both tools to include some unit information:

--- cut here ---
myserver:~ # make-bcache -B --block 4096b /dev/md125
[...]
block_size:             8 (units of 512 octets)

myserver:~ # bcache-super-show /dev/md125
[...]
dev.sectors_per_block   8 (pseudo-sectors of 512 octets each)
--- cut here ---

dev.sectors_per_block is especially misleading in its current display,  
because that data element actually does *not* relate to native block  
device sectors.

Both changes would be purely cosmetic and not altering current functionality.

It might be favorable (AKA "better readable") to instead output the  
"block_size" in bytes/octets in both places, instead of just dumping  
the value of the super block element.

Regards,
J
