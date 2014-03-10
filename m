From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Slow writing of dirty data (bcache)
Date: Mon, 10 Mar 2014 16:14:41 -0500
Message-ID: <531E2B41.5030605@nuclearwinter.com>
References: <531DE9A5.90801@nuclearwinter.com> <CALJ65zm4O8KeA1vjhupAFoqh+07qH5OaLMCbm-fShkZk6nf9MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:51436 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751231AbaCJVOn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Mar 2014 17:14:43 -0400
In-Reply-To: <CALJ65zm4O8KeA1vjhupAFoqh+07qH5OaLMCbm-fShkZk6nf9MA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

This solved my immediate problem. Thank you very much.

Should I keep this array at 0 from now on if I want it to spin down when
idle?

--Larkin

On 3/10/2014 12:12 PM, Kent Overstreet wrote:
>
> echo 0 > writeback_percent...
>
> On Mar 10, 2014 6:07 PM, "Larkin Lowrey" <llowrey@nuclearwinter.com
> <mailto:llowrey@nuclearwinter.com>> wrote:
>
>     I'm seeing an odd behavior after updating to kernel
>     3.13.5-202.fc20.x86_64 from 3.12.7-300.fc20.x86_64.
>
>     I have a bcache device (bcache2) which backs a raid5 array (md2) that
>     has 160+MB of dirty data. The dirty data is being written at a
>     rate of 1
>     page per second (8 sectors). At this rate it'll take 11 hrs to
>     finish. I
>     like to keep this array spun down when inactive but the drives can't
>     spin down since they're being written to once a second.
>
>     # cat /sys/block/bcache2/bcache/writeback_rate
>     512
>
>     # cat /sys/block/bcache2/bcache/writeback_rate_debug
>     rate:           512/sec
>     dirty:          161M
>     target:         40.8G
>     proportional:   -35.2M
>     derivative:     0
>     change:         -35.2M/sec
>     next io:        624ms
>
>     This never happened when running 3.12.7. Is there anything I can do
>     about this?
>
>     --Larkin
>
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-bcache" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
