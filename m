From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 17:58:37 +0100
Message-ID: <765af26a-6258-6623-2532-b285527970a7@pharaoh.uk>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com> <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
 <20161028130720.GA31703@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:54558
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965911AbcJ1Q7A (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 12:59:00 -0400
In-Reply-To: <20161028130720.GA31703@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 28/10/16 14:07, Vojtech Pavlik wrote:
> On Fri, Oct 28, 2016 at 03:52:49AM -0800, Kent Overstreet wrote:

> Indeed. However, together with the write intent bitmap, and filesystems
> ensuring consistency through barriers, it's still greatly mitigated.
 >
> Mdraid will mark areas of disk dirty in the write intent bitmap before
> writing to them. When the system comes up after a power outage, all
> areas marked dirty are scanned and the xor block written where it
> doesn't match the rest.
>
> Thanks to the strict ordering using barriers, the damage to the
> consistency of the RAID can only be in request since the last
> successfully written barrier.

Ok so, without posting to mdraid, you are confident that, assuming the 
disk (etc) is correctly ordering writes, that the RAID5 write hole, as 
implemented by a modern Linux kernel, does not suffer from a write hole, 
then this is great news.

I understand that there is a clear issue in the case of a drive failure, 
but that's specifically why I think that bcache can be of use, because 
it should be able to mitigate some of this.

I have a feeling I would need to bcache the backing devices, rather than 
the array itself, to make this work, since, in the case of a drive 
failure, specifically the loss of a data-stripe as opposed to a parity 
one, is not possible to be ordered to avoid corruption. But I think that 
a bcache layer on the backing device, assuming of course that the bcache 
cache device is consistent, would provide this level of assurance.

> The only situation where data damage can happen is a power outage that
> comes together with a loss of one of the drives. In such a case, the
> content of any blocks written past the last barrier is undefined. It
> then depends on the filesystem whether it can revert to the last sane
> state. Not sure about others, but btrfs will do so.

Yes, and of course I've mentioned this above. But... I feel that this is 
something that bcache could help with, and I also have several redundant 
backups so that, in the unlikely event of a drive failure which causes 
corruption, I can easily restore the files in question.

I do feel like I would like to understand a little more about how Linux 
mdraid behaves in this respect, but it sounds like it does a pretty good 
job, and that my bcache layer, and redundant backups, provide a good 
layer of data security.

I am mostly using this to store zbackup respositories, which store the 
majority of data in 256 directories, which I currently map to 16 backing 
devices, and could, of course, easily map to as many as 256. In this use 
case, with the redundant backups, and of course some automatic testing 
and verification of the data, I am fairly confident that I won't be 
losing any backups.

James
