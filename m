From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Testing bcachefs - beginners questions
Date: Wed, 16 Mar 2016 19:26:42 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603161917400.19675@mail.ewheeler.net>
References: <56E97827.6090203@mejor.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-640555867-1458156402=:19675"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:52165 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965623AbcCPT0p (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Mar 2016 15:26:45 -0400
In-Reply-To: <56E97827.6090203@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-640555867-1458156402=:19675
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT


On Wed, 16 Mar 2016, Marcin Mirosław wrote:

> Hello!
> 
> I'd like to try to use and test how bcachefs works. I've found page
> https://lkml.org/lkml/2015/8/21/22 where are described working and
> planned features. What changed since mentioned email? Do I see correctly
> that web page with documentation is rather outdated?
> How can I check bcachefs without using all kernel from
> https://evilpiepirate.org/git/linux-bcache.git ? Is it enough to copy
> directory drivers/md/bcache to currently used kernel sources and compile
> or I've to use kernel from mentioned git repo?

I think you want this branch:

https://evilpiepirate.org/git/linux-bcache.git/log/?h=bcache-dev

It looks like Kent's tree is up to date (4.5.0) so you could use it 
directly.  I wouldn't copy directory trees around to a different kernel 
unless you are ready for some backporting work.  Perhaps bcachefs can be 
backported to earlier stable kernels when Kent is ready to call it stable.  

He was working on endianness compatability last I heard.  It would be neat 
to hear some feedback on its status, maybe benchmarks against btrfs/zfs, 
too.

-Eric

> 
> Thank you for any answer,
> Marcin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-640555867-1458156402=:19675--
