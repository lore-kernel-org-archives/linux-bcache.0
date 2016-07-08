From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: [dm-devel] [RFC] block: fix blk_queue_split() resource exhaustion
Date: Fri, 8 Jul 2016 19:24:24 +0600
Message-ID: <1189799501.20160708192424@pvgoran.name>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com> <871t36ggcr.fsf@notabene.neil.brown.name> <20160707081616.GH13335@soda.linbit> <87vb0hf6fb.fsf@notabene.neil.brown.name> <20160708080219.GT13335@soda.linbit> <877fcwfoyv.fsf@notabene.neil.brown.name> <20160708130035.GW13335@soda.linbit>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:59933 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbcGHN3d (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 8 Jul 2016 09:29:33 -0400
In-Reply-To: <20160708130035.GW13335@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: linux-bcache@vger.kernel.org

Hello Lars,

Friday, July 8, 2016, 7:00:35 PM, you wrote:

> On Fri, Jul 08, 2016 at 07:39:36PM +1000, NeilBrown wrote:

>> I think we just might be in violent agreement.

> I thought so, too :-)

> Should I merge both patches,
> rename to ".queue" and ".tmp",
> and submit for inclusion?

Could you please *not* use ".tmp"? I have a feeling it's even worse than "X"
and "Y". :)

I suggest to leave it as ".recursion", or maybe use something like
".downstream".

Pavel Goran
  
