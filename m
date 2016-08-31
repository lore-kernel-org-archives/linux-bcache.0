From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: clang doesn't like bcache-tools: libbcache.c:79:39: error:
 function definition is not allowed here
Date: Wed, 31 Aug 2016 13:30:52 +0200
Message-ID: <a9dcce02-2bef-c6c2-b8d1-c0ba7d2d6ad0@mejor.pl>
References: <b8e1ee15-da4a-a5d3-3717-96b9286d9571@mejor.pl>
 <20160831003203.amfuaozybcvewuuv@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:12904 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755315AbcHaLbF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2016 07:31:05 -0400
In-Reply-To: <20160831003203.amfuaozybcvewuuv@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 31.08.2016 o 02:32, Kent Overstreet pisze:
> On Tue, Aug 30, 2016 at 10:42:29AM +0200, Marcin Mirosław wrote:
>> Hi!
>> Compilation of bcache-tools (branch: dev) fails due to:
> 
> oh yeah, clang doesn't like nested functions. fixed.


Clang chilled out, thank you.
