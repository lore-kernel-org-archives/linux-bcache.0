From: Coly Li <i@coly.li>
Subject: Re: bcache and btrfs linux 4.7
Date: Sat, 17 Sep 2016 03:04:46 +0800
Message-ID: <bd0555bb-69ce-845e-54ea-3f4a3e842d60@coly.li>
References: <CACaajQuRxPe_+-Pt+_LA2dYDRMtNNF+hgpi1w7OzpeJopGy8Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:41718 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753513AbcIPTFJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 15:05:09 -0400
In-Reply-To: <CACaajQuRxPe_+-Pt+_LA2dYDRMtNNF+hgpi1w7OzpeJopGy8Xw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>, linux-bcache <linux-bcache@vger.kernel.org>

ÔÚ 16/9/16 ÏÂÎç11:45, Vasiliy Tolstov Ð´µÀ:
> Hi! I'm use bcache long time ago from 3.10 kernel and it works fine for me.
> Now i'm use fedora and want to try btrfs with bcache. Does it work?
> Does bcache have development or Kent switched to bcachefs ?
> 
> (I need btrfs because want to use incremental backups and want snapshots)

Kent is busy on bcachefs, currently bcache is in table status. If you
find any bug during your usage, please raise your voice here.

IMHO, I suggest to use 4.8 kernel, if that's possible in your situation.

-- 
Coly Li
