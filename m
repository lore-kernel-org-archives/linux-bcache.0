From: Mariusz Paradowski <indianin@indianin.net>
Subject: Re: bcache: btree_split() couldn't split
Date: Tue, 13 May 2014 22:41:35 +0200
Message-ID: <20140513224135.1ecd1fd7eb26f1b4f7b17c73@indianin.net>
References: <58691644935d03855d2edb9c71c6dfb0@indianin.eu.org>
	<5370F366.7030505@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from byf58.internetdsl.tpnet.pl ([83.19.9.58]:54563 "EHLO
	mail.vaxvms.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaEMUlm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 13 May 2014 16:41:42 -0400
Received: from indianin (89-68-162-103.dynamic.chello.pl [89.68.162.103])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(Client did not present a certificate)
	(Authenticated sender: indianin@indianin.eu.org)
	by mail.vaxvms.net (Postfix) with ESMTPSA id 3gSrXK5D2dz13gwZb
	for <linux-bcache@vger.kernel.org>; Tue, 13 May 2014 22:41:37 +0200 (CEST)
In-Reply-To: <5370F366.7030505@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Mon, 12 May 2014 18:14:30 +0200,
in 5370F366.7030505@rolffokkens.nl,
Rolf Fokkens <rolf@rolffokkens.nl> wrote:

> So far no problems here, I have been using bcache since october. But
> I'm currently running kernel 3.14.3, so I might be at risk?

You might. Independently of this error it may be even riskier if you
are using bcache in writeback mode.


> Is this issue there since a specific kernel version?

I'm not sure. My previous kernel was 3.13.11 and it was even worse -
bcache in writeback mode destroyed my filesystem. I escaped from
3.13.11 to 3.14.3 with bcache in writethrough mode, but with this
version the split error occurs. Slava wrote more info on this.
-- 
Mariusz Paradowski
