From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Debug cache miss
Date: Fri, 14 Apr 2017 17:32:46 +0200
Message-ID: <20170414173246.024c0049@jupiter.sol.kaishome.de>
References: <CANM5d8cpE55Wi_Dj2Ah-EG2_cHneDX9iNJpYMTsFr1pYV9s1jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34951 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdDNPfN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Apr 2017 11:35:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1cz3FZ-00052w-9P
        for linux-bcache@vger.kernel.org; Fri, 14 Apr 2017 17:35:05 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Fri, 14 Apr 2017 16:21:00 +0300
schrieb Shay Gover <govershay@gmail.com>:

> Hi everyone,
> 
> Recently I'm getting complete I/O freezes (mouse still working).
> I think, it's a cache miss.
> Sometimes I see on dmesg this error:
> kernel: perf: interrupt took too long (2575 > 2500), lowering
> kernel.perf_event_max_sample_rate to 77400
> (Numbers change)
> 
> How can I debug this? Where should I look?
> Currently I'm watching cache_bypass_misses

Are you using VirtualBox somewhere? I only see such messages when
running VirtualBox guests with high IO load. But the IO stack is not
the problem here.

-- 
Regards,
Kai

Replies to list-only preferred.
