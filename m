From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: replacing cache device "live"
Date: Fri, 10 Feb 2017 12:10:45 +0100
Message-ID: <20170210121045.Horde.-fJa4QkH3OMcVtzM7lqMtr-@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:14716 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdBJLKs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 06:10:48 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
        by post.strato.de (RZmta 39.12 AUTH)
        with ESMTPA id j0bce6t1ABAjc1A
        for <linux-bcache@vger.kernel.org>;
        Fri, 10 Feb 2017 12:10:45 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 633361C068
        for <linux-bcache@vger.kernel.org>; Fri, 10 Feb 2017 12:10:45 +0100 (CET)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi *,

I'd like to change the cache device setup of my servers, with a  
minimum of downtime (if at all).

https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev describes the steps required to replace the caching  
device:

- detach the caching device (echo 1 > /sys/block/bcacheX/bcache/detach)

- unregister the cache set (echo 1 > /sys/fs/bcache/<uuid>/stop)

I believe that issuing that second step will break access to  
/dev/bcacheX, so cannot be done without interrupting the service  
(description for cset "stop" in bcache.txt: "Write to this file to  
shut down the cache set - waits until all attached backing devices  
have been shut down.").

What I'm actually looking for is to change the sectors per block value  
of the caching device, without having to shut down operations on the  
according bcache device (cache_mode=none at that time). Is there any  
way to do so?

Regards,
Jens
