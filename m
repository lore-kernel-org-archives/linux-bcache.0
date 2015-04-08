From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 8 Apr 2015 18:02:23 -0400
Message-ID: <CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com>
References: <54A66945.6030403@profihost.ag>
	<54A66C44.6070505@profihost.ag>
	<54A819A0.9010501@rolffokkens.nl>
	<54A843BC.608@profihost.ag>
	<loom.20150105T010336-763@post.gmane.org>
	<tcfnqb-u59.ln1@hurikhan77.spdns.de>
	<CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
	<alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com>
	<55257303.8020008@profihost.ag>
	<alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com>
	<3ldgvb-het.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34348 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbbDHWCY (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 18:02:24 -0400
Received: by iedfl3 with SMTP id fl3so97451933ied.1
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 15:02:24 -0700 (PDT)
In-Reply-To: <3ldgvb-het.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

You can't always use the correct eraseblock size with BCache, since it
doesn't (didn't, at least at the time I created my cache) support
non-powers-of-two that TLC drives use.  That said, TRIM is not
supposed to blow away entire eraseblocks, just let the drive know the
mapping between presented LBA and internal address is no longer
needed, allowing it to do what it wishes with that knowledge
(generally reclaim multiple partial blocks to create fully empty
blocks).

I can't find any reports of errors with TRIM support in the 840-EVO
series.  They had/may still have a problem reading old data that was a
big deal in the fall, and there was an 850 firmware that bricked some
drives.  Nothing about TRIM erasing unintended data, though.

There were no problems with bcache at all in the year+ I've used it,
until I enabled bcache discard. Before that, I put on over 100
terabytes of writes to the bcache partition with no interface errors.
 I've also never seen a TRIM failure in other filesystems using the
same model in my other systems.  There was no powerloss, the system
went through a software reboot cycle before the failure.  I'm
therefore *extremely* hesitant about allowing this to be written off
as a hardware failure.
