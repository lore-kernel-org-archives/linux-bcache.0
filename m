From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: bcache and btrfs linux 4.7
Date: Mon, 19 Sep 2016 15:56:46 +0300
Message-ID: <CACaajQuG=b=PeLwh8z+Ls0J83xU-UjLzXtw893tpFpUkBkS4Gw@mail.gmail.com>
References: <CACaajQuRxPe_+-Pt+_LA2dYDRMtNNF+hgpi1w7OzpeJopGy8Xw@mail.gmail.com>
 <bd0555bb-69ce-845e-54ea-3f4a3e842d60@coly.li> <alpine.LRH.2.11.1609181539230.5413@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34880 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935328AbcISM5I (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2016 08:57:08 -0400
Received: by mail-wm0-f46.google.com with SMTP id l132so150390929wmf.0
        for <linux-bcache@vger.kernel.org>; Mon, 19 Sep 2016 05:57:08 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1609181539230.5413@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <i@coly.li>, linux-bcache <linux-bcache@vger.kernel.org>

2016-09-19 1:41 GMT+03:00 Eric Wheeler <bcache@lists.ewheeler.net>:
> General use stability patches go back to at least v4.1.  There is an OOM
> blkdev_put that missed 4.7, but you shouldn't hit that unless you OOM at
> registration time.


Thanks, so i can take any kernel > 4.1 ?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
