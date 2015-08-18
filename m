From: Emmanuel Florac <eflorac@intellique.com>
Subject: Why bcachefs?
Date: Tue, 18 Aug 2015 13:29:21 +0200
Message-ID: <20150818132921.7ef7db8b@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36810 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbbHRL3T (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Aug 2015 07:29:19 -0400
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id D6A78D48037
	for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2015 13:29:17 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

After toying a bit with it, I'm wondering: why bcachefs? I understand
that integrating the filesystem with the cache layer probably makes the
job easier but overall ...  we already have several excellent
filesystems; developing a reliable filesystem is DAMN HARD; building a
feature-complete FS is CRAZY HARD (see btrfs); because FTL sucks anyway
and we'd rather wait for ways to move ahead of it... 

So Kent, please, tell us, why? :)


-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
