From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 18:54:30 +0200
Message-ID: <20150831165430.GA10258@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
 <20150831144949.GA3276@suse.com>
 <20150831150429.GA27538@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbbHaQyc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 12:54:32 -0400
Content-Disposition: inline
In-Reply-To: <20150831150429.GA27538@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 07:04:29AM -0800, Kent Overstreet wrote:

> I suspect there's two different bugs here.
> 
>  - I'm starting to suspect there's a bug in the dirty data accounting, and it's
>    getting out of sync - i.e. reading 2.8 GB or whatever when it's actually 0.
>    that would explain it spinning when there actually isn't any work for it to
>    do.
> 
>  - with a large enough amount of data, the 30 second writeback_delay may be
>    insufficient; if it takes longer than that just to scan the entire keyspace
>    it'll never get a chance to sleep. try bumping writeback_delay up and see if
>    that helps.
> 
>    the ratelimiting on scanning for dirty data needs to be changed to something
>    more sophisticated, the existing fixed delay is problematic.

Is there any difference regarding writeback problems between using 4.1.6
and your bcache-dev git branch?

It may take a bit of effort, but I should be able to get bcache-dev
installed on my system.

-- 
Vojtech Pavlik
Director SuSE Labs
