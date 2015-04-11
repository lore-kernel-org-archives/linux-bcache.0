From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 11 Apr 2015 02:31:37 -0400
Message-ID: <CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com>
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
	<CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com>
	<5a1mvb-6k.ln1@hurikhan77.spdns.de>
	<3k5mvb-c14.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33048 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbDKGbh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Apr 2015 02:31:37 -0400
Received: by ignm3 with SMTP id m3so26446052ign.0
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 23:31:37 -0700 (PDT)
In-Reply-To: <3k5mvb-c14.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Fri, Apr 10, 2015 at 8:14 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> There are reports about endurance tests that say you can write petabytes
>> of data to SSD before they die. Samsung's drives belong to the best
>> performers here with one downside: If they die, in those tests they took
>> all your data with them and without warning. Most other drives went into
>> read-only mode first so you could at least get your data off those drives,
>> but after a reboot those drives were dead, too.
>>
>> http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead

This has what to do with bcache eating my data, again?

>> From those reports, I conclude: If your drive suddenly slows down, it's a
>> good idea to order a replacement and check the SMART stats (if you didn't
>> do that before).

This as well.  The drive didn't die, all sectors are still readable.
No errors at all on SMART.

>> I'm also not sure to instead call it a general bug or problem of bcache.
>> The TRIM implementation seems to be correct, at least it doesn't show
>> problems for me. I have TRIM enabled for btrfs, bcache, and the kernel
>> claims it to be supported. So I'd rather call it an incompatibility or
>> firmware flaw which needs to be worked around.

Please explain why no other filesystem, windows OR linux, has errors
with TRIM on this drive.

The other part I don't understand is that nothing should have been
discarded yet - I took the time
to flush the cache to disk (echo none > cache_mode), waited for
writeback to complete, detach the cdev,
waited for the detach to complete, recreate it with the correct
blocksize and discard enabled, then re-attach.  I ran for maybe 15
minutes like this before rebooting, for perhaps a dozen GB written out
of the 200gb cache partition.
