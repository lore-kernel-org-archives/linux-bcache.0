From: "Paul B. Henson" <henson@acm.org>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 16:43:50 -0800
Message-ID: <20131123004350.GA5195@bender.unx.csupomona.edu>
References: <20131121135604.GA26424@professorx.home.zettazebra.com>
 <14da01cee71f$28d233f0$7a769bd0$@acm.org>
 <20131122034919.GA25040@professorx.home.zettazebra.com>
 <528F6BAD.7080703@warr.net>
 <156301cee7bc$3b7fc420$b27f4c60$@acm.org>
 <528FBFCE.7020104@warr.net>
 <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
 <op.w6y712vgf3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42811 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3KWAn6 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 19:43:58 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so1927052pdj.8
        for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 16:43:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <op.w6y712vgf3gqgg@desktop.patton.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthew Patton <pattonme@yahoo.com>
Cc: linux-bcache@vger.kernel.org

On Fri, Nov 22, 2013 at 07:38:16PM -0500, Matthew Patton wrote:

> > Ah, that's true; using raid at the lvm layer allows you to selectively
> > choose redundancy as opposed to dropping the entire pv on top of an  
> > mdraid.
> 
> Not sure I understood that passage...

If you take two physical disks, use mdraid, and then create a single pv
on top, every lv is redundant. If you take two physical disks, make two
separate pv's, you can either have a non-redundant lv, or use lvm raid
and have a redundant lv, and you can mix and match as you wish. This is
based on my understanding of lvm raid, which is not guaranteed correct
;), and as such should be taken as an opinion only :).
