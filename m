From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs]  BUG: soft lockup - CPU#0 stuck for 22s!
 [bch_copygc_read:5328]
Date: Sat, 03 Sep 2016 23:57:19 +0200
Message-ID: <256aaa48ace54e681c8692fe3a3f65a9@mejor.pl>
References: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:20930 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754538AbcICV5r (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 3 Sep 2016 17:57:47 -0400
In-Reply-To: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 2016-09-03 23:29, Marcin napisał(a):
> Hi!
> Kernel at commit c820493652e830dc050e1418301e1bdec5691a1e

It looks that I was messing with bcache-encryption and this bug appears 
on bcache-encryption branch.
