From: Coly Li <i@coly.li>
Subject: Re: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Fri, 14 Jul 2017 23:07:28 +0800
Message-ID: <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:37720 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754176AbdGNPHi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jul 2017 11:07:38 -0400
In-Reply-To: <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eddie Chapman <eddie@ehuk.net>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>

On 2017/7/14 下午7:40, Eddie Chapman wrote:
> On 25/05/17 20:10, Eric Wheeler wrote:
>> Hi Jens,
>>
>> Please pull these updates and bugfixes from the bcache community when you
>> have a minute.  If you need a rebase against something else then please
>> let me know and I would be happy to update for you.
>>
>> Thank you for your help!
> 
> <snip>
> 
> Hi all,
> 
> (replying to all but as a subscriber to stable only)
> 
> I'm not a kernel coder but have several 4.4 (kernel.org stable series)
> servers using bcache, so I'd love to see (possibly some of?) these in
> 4.4 if they are relevant and apply without any significant work needed.
> 
> This series was CC'd to stable but I don't see any info of how far back
> any of them might be applicable, if at all.
> 
> If any of you guys are able to give a hint with this series just along
> the lines of "this one is/is not applicable to 4.4" then I'm happy to
> apply them, resolve any simple context issues, use, and report back with
> clean patches.

(remove many unnecessary email receivers)

Hi Eddie,

I think some patches from Junhui Tang are important stable fixes.
After all the patches get reviewed, and accepted in mainline kernel, you
may find them in 4.4 stable tree (any way it won't be very soon for
these fixes show up in stable tree).

Thanks.

-- 
Coly Li
