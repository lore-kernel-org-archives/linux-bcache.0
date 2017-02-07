From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Wed, 08 Feb 2017 00:28:43 +0100
Message-ID: <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
 <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:14539 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdBGX2r (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 18:28:47 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
        by post.strato.de (RZmta 39.12 AUTH)
        with ESMTPA id R08cc2t17NSiHSQ
        for <linux-bcache@vger.kernel.org>;
        Wed, 8 Feb 2017 00:28:44 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id B8D6F1C068
        for <linux-bcache@vger.kernel.org>; Wed,  8 Feb 2017 00:28:43 +0100 (CET)
In-Reply-To: <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

Hello Kai,

Zitat von Kai Krakow <hurikhan77@gmail.com>:
> Am Tue, 07 Feb 2017 13:35:58 +0100
> schrieb "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
>
>> Hi *,
>> [...]
>> If it is about block sizes, questions pile up: Are the "dos" and
>> "don'ts" documented anywhere? It's a rather common situation for us
>> to run multiple backing devices on a single cache set, with both
>> complete HDDs and logical volumes as backing stores. So it's very
>> easy to come into a situation where we see either different block
>> sizes between backing store and caching device or even differing
>> block sizes between the various backing stores.
>>
>> - using 512b for cache and 4k for backing device seems not to work,
>> unless above is purely a size limit problem
>>
>> - 512b for cache and 512b for backing store seems to work
>>
>> - 4k for cache and 4k for backing store will probably work as well
>>
>> - will 4k for cache and 512b for backing store work (sounds likely,
>> as there will be no alignment problem in the backing store. OTOH,
>> will bcache try to write 4k data (cache block) into 512b blocks
>> (backing store) or will it write 8 blocks then, mapping the block
>> size differences?)
>>
>> - if the latter works, will using both 4k and 512b backing stores in
>> parallel work if using a 4k cache?
>>
>> Any insight and/or help tracking down the error are most welcome!
>
> Hmm, I think for me it refused to attach backend and cache if block
> sizes differ. So I think the bug is there...
>
> Once I created backing store and cache store in two separate steps.
> During attaching, it complained that block sizes don't match and the
> cacheset cannot be attached.

hm, I believe to have created the backing store and cache set in a  
common call to make-bcache for the mentioned server 2 and 3 - usually,  
I only attach separately when creating additional backing stores for  
an existing cache set. Currently I have no server to test, though.  
Attaching differingly block-sized cache sets definitely works for me,  
both kernel 4.1.36 and 4.9.8.

So you're saying that block sizes need to match? Then I'm in trouble,  
as I have SAS SSDs with 512b and HDDs with 4k block size that build  
the main storage for the environment in question.

Regards,
Jens
