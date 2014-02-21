From: Ryan Tucker <rtucker@gmail.com>
Subject: Re: bcache deadlock with /dev/ramX + partition
Date: Fri, 21 Feb 2014 13:23:03 -0500
Message-ID: <CAN6-qxbAzS=LYf5cd5HucDx42CjO32ZhjkvvnJX0kC7NtkM4NQ@mail.gmail.com>
References: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
	<loom.20140221T180753-160@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64102 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaBUSXE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 21 Feb 2014 13:23:04 -0500
Received: by mail-qc0-f169.google.com with SMTP id e9so4378246qcy.0
        for <linux-bcache@vger.kernel.org>; Fri, 21 Feb 2014 10:23:03 -0800 (PST)
In-Reply-To: <loom.20140221T180753-160@post.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Max Kutsevol <max@kutsevol.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Feb 21, 2014 at 12:08 PM, Max Kutsevol <max@kutsevol.com> wrote:
> Hello.
>
> Try this patch: http://evilpiepirate.org/git/linux-bcache.git/commit/?
> h=bcache-for-3.14&id=947174476701fbc84ea8c7ec9664270f9d80b076

Hmm, from what I've seen, the problem fixed by that patch manifested
itself differently (bch_ptr_invalid at the top of the call trace, RIP
set to __bch_btree_mark_key), and I believe it was only present in
3.13.x where 0 <= x < 4.  Doesn't look like Vivek's runs with 3.13
lasted long enough to hit that bug, alas!  -rt

-- 
Ryan Tucker <rtucker@gmail.com>
