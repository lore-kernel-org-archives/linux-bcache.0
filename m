From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] Can't mount tiered fs. (after updating kernel?)
Date: Mon, 29 Aug 2016 16:11:23 +0200
Message-ID: <be10f037-e2e0-989a-164f-1bd70a4a7a2e@mejor.pl>
References: <8e67f156-a5b7-007a-9f5f-81ea11263e9e@mejor.pl>
 <20160829125756.ycu2mxwmvykhsrwl@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:65214 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756854AbcH2OMA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2016 10:12:00 -0400
In-Reply-To: <20160829125756.ycu2mxwmvykhsrwl@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 29.08.2016 o 14:57, Kent Overstreet pisze:
> On Mon, Aug 29, 2016 at 02:37:45PM +0200, Marcin Mirosław wrote:
>> Hi!
>> Today I've updated linux-bcache to
>> 58b5f01a443201c4b6c219fa14e6712a0dc08b06 . Changed some option in
> 
> That was a bug in a reserves patch - I backed it out, update again.

My bad, mentioned commit was commit of merge after git pull. I cloned
linux-bcache again. I'm at:
commit c820493652e830dc050e1418301e1bdec5691a1e
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Fri Aug 26 21:20:20 2016 -0800

    bcache: bch_extent refactoring



And it works. Git is magic for me.
Thanks.
