From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: =?utf-8?B?562U5aSNOiBhIHN0cmFuZw==?= =?utf-8?Q?e?= bcache0 100%
 busy with no IO rw and no cpu consumption
Date: Sun, 14 May 2017 15:53:49 +0200
Message-ID: <20170514135349.GA28395@xoff>
References: <002a01d2cc61$1c249820$546dc860$@ecloudtech.com.cn>
 <20170514084515.GA23435@xoff>
 <000e01d2cc95$1b81cad0$52856070$@ecloudtech.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:36928 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751603AbdENNzN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 09:55:13 -0400
Content-Disposition: inline
In-Reply-To: <000e01d2cc95$1b81cad0$52856070$@ecloudtech.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?utf-8?B?5pyx6I+B?= <zhujing@ecloudtech.com.cn>
Cc: linux-bcache@vger.kernel.org

On Sun, May 14, 2017 at 05:33:12PM +0800, 朱菁 wrote:
> Hi:
> 	Thx for your reply.
> 	/dev/sdb on esxi-node  equal bcache0 on stor-node.

sorry, it just looked too easy :-)

I have also seen suspiciously high iostat values on bcache devices,
where extreme values of "wkB/s" go together with high "avgrq-sz"
(probably a derived value), but never on two consecutive measurements,
always several days in between. But "%util" always looked ok.

Since iostat is just reading /proc/diskstat, I would rather suspect some
(bcache related) bug there.

Sometimes I also see funny numbers in writeback_rate_debug, e.g.
increasing "dirty" values like this: 
   2.8M .. 2.9M .. 2.10M .. 3.0M

Matthias
