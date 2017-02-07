From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: size limit for backing store? block sizes?  ("[sdx] Bad block
 number requested")
Date: Tue, 07 Feb 2017 13:35:58 +0100
Message-ID: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:25454 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdBGMmU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 07:42:20 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
        by post.strato.de (RZmta 39.12 AUTH)
        with ESMTPA id g0411ct17Ca0Ckf
        for <linux-bcache@vger.kernel.org>;
        Tue, 7 Feb 2017 13:36:00 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 965F41C068
        for <linux-bcache@vger.kernel.org>; Tue,  7 Feb 2017 13:35:58 +0100 (CET)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi *,

we're facing an obsure problem with a fresh bcache setup:

After creating a 8TB (netto) RAID5 device (hardware RAID controller),  
setting it up for bcache (using an existing cache set) and populating  
it with data, we got struck by massive dmesg reports of "[sdx] Bad  
block number requested" during writeback of dirty data. Both with our  
4.1.x kernel, as well as a 4.9.8 kernel.

After recreating the backing store with 3 TB (netto) and recreating  
the bcache setup, population went without any noticable errors.

While the 8TB device was populated with only the same amount of data  
(2.7 TB), block placement was probably across all of the 8TB space  
available.

Another parameter catching the eye is block sizes - the 8 TB backing  
store was created in a way such that 4k block size was exposed to the  
OS, while the 3 TB backing store was created so that 512b block size  
was reported. The caching set is on a PCI SSD with 512b block size.

So with backing:4k and cache:512b and 8 TB backing store size, bcache  
went mad during writeback ("echo 0 > writeback_running" immediately  
made the messages stop). With backing:512b and cache:512b and 3 TB  
backing store size, we had no error reports at all.

On a second  node, we have (had) a similar situation - backing:4k and  
cache:512b, but 4 TB backing store size. We've seen the errors there,  
too, when accessing an especially big logical volume that likely  
crossed some magic limit (block number on "physical volume"?). We  
still see the message there today, only much less frequent since we no  
longer use that large volume on the bcache device. Other volumes are  
there now, probably with a few data spaces at high block numbers,  
leading to the occasional error message (every few minutes) during  
writeback?

Even more puzzling, we have a third node, identical to the latter one  
- except that the bcache device is more filled with data and we see no  
such error (yet)...

So here we are - what are we facing? Is it a size limit regarding the  
backing store? Or does the error result from mixing block sizes, plus  
some other triggers?

If the former, where's the limit?

If it is about block sizes, questions pile up: Are the "dos" and  
"don'ts" documented anywhere? It's a rather common situation for us to  
run multiple backing devices on a single cache set, with both complete  
HDDs and logical volumes as backing stores. So it's very easy to come  
into a situation where we see either different block sizes between  
backing store and caching device or even differing block sizes between  
the various backing stores.

- using 512b for cache and 4k for backing device seems not to work,  
unless above is purely a size limit problem

- 512b for cache and 512b for backing store seems to work

- 4k for cache and 4k for backing store will probably work as well

- will 4k for cache and 512b for backing store work (sounds likely, as  
there will be no alignment problem in the backing store. OTOH, will  
bcache try to write 4k data (cache block) into 512b blocks (backing  
store) or will it write 8 blocks then, mapping the block size  
differences?)

- if the latter works, will using both 4k and 512b backing stores in  
parallel work if using a 4k cache?

Any insight and/or help tracking down the error are most welcome!

Regards,
Jens
