From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache and btrfs linux 4.7
Date: Sun, 18 Sep 2016 15:41:36 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609181539230.5413@mail.ewheeler.net>
References: <CACaajQuRxPe_+-Pt+_LA2dYDRMtNNF+hgpi1w7OzpeJopGy8Xw@mail.gmail.com> <bd0555bb-69ce-845e-54ea-3f4a3e842d60@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-226316104-1474238497=:5413"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:48133 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932263AbcIRWli (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2016 18:41:38 -0400
In-Reply-To: <bd0555bb-69ce-845e-54ea-3f4a3e842d60@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>, linux-bcache <linux-bcache@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-226316104-1474238497=:5413
Content-Type: TEXT/PLAIN; charset=gbk
Content-Transfer-Encoding: 8BIT

On Sat, 17 Sep 2016, Coly Li wrote:

> ÔÚ 16/9/16 ÏÂÎç11:45, Vasiliy Tolstov Ð´µÀ:
> > Hi! I'm use bcache long time ago from 3.10 kernel and it works fine for me.
> > Now i'm use fedora and want to try btrfs with bcache. Does it work?
> > Does bcache have development or Kent switched to bcachefs ?
> > 
> > (I need btrfs because want to use incremental backups and want snapshots)
> 
> Kent is busy on bcachefs, currently bcache is in table status. If you
> find any bug during your usage, please raise your voice here.
> 
> IMHO, I suggest to use 4.8 kernel, if that's possible in your situation.

General use stability patches go back to at least v4.1.  There is an OOM 
blkdev_put that missed 4.7, but you shouldn't hit that unless you OOM at 
registration time.


--
Eric Wheeler


> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-226316104-1474238497=:5413--
