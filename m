From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 18:07:21 +0100
Message-ID: <6ab21923-caa2-4706-e4dc-83729ff6d111@pharaoh.uk>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com> <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:55440
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S942447AbcJ1RHg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 13:07:36 -0400
In-Reply-To: <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

On 28/10/16 12:52, Kent Overstreet wrote:

> That's not what the raid 5 hole is. The raid 5 hole comes from the fact that
> it's not possible to update the p/q blocks atomically with the data blocks, thus
> there is a point in time when they are _inconsistent_ with the rest of the
> stripe, and if used will lead to reconstructing incorrect data. There's no way
> to fix this with just flushes.

Yes, I understand this, but if the kernel strictly orders writing mdraud 
data blocks before parity ones, then it closes part of the hole, 
especially if I have a "journal" in a higher layer, and of course ensure 
that this journal is reliable.

I think that, in the case of a drive failure, which contains data blocks 
which have been written, but which the parity blocks have not been, then 
this will fail.

I also think, however, that by putting bcache /under/ mdraid, and 
(again) ensuring that the bcache layer is reliable, along with the 
requirement for bcache to "journal" all writes, would provide an 
extremely reliable storage layer, even at a very large scale.

James
