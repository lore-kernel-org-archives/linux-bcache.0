From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Sat, 29 Oct 2016 21:58:06 +0200
Message-ID: <073a6c5a-8c73-b808-e586-eccfdc62e778@pharaoh.uk>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com> <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
 <6ab21923-caa2-4706-e4dc-83729ff6d111@pharaoh.uk>
 <20161029005832.3iroclcaok7zy5p2@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:49906
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756345AbcJ2T6V (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 29 Oct 2016 15:58:21 -0400
In-Reply-To: <20161029005832.3iroclcaok7zy5p2@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-bcache@vger.kernel.org

Okay... So I think the situation is that:

- Currently there is no facility to atomically write out more than one 
block at a time.

- Mdraid orders writes to ensure that data blocks are updating 
atomically, and these are used for reads.

- If a data block is updated, but the parity is not, and there is a 
failure to any of the devices containing a data block with inconsistent 
parity, then the other blocks which share the parity block, effectively 
"random" blocks from the point of view of the filesystem, will be corrupted.

- Some kind of journal, and of course I'm proposing that bcache could 
serve this purpose, could potentially be able to close the write hole.

The main missing functionality is the first point above, namely that if 
the block layer could communicate that multiple block writes need to be 
made or not made, ie that multiple blocks could be written atomically, 
assuming there is a journal present, would fix this.

Has this been discussed before? As always, I find it hard to find good 
information about this kind of low-level stuff, and think that asking 
the people who have written it is the only way to get anywhere.

Obviously a change to the device mapper API is not something that would 
be done without significant consideration, although a POC would of 
course be welcomed, I think.

I think the gains to be made here are substantial, and that bcache is a 
very good candidate for the journal implementation. I also think that 
this implementation is relatively simple, compared to other options. I 
also have read many opinions on the problems of scaling up RAID5 and 
RAID6 as drives become larger, so I think there's definitely an urgent 
interest in finding a solution to this.

So, I would propose to add this kind of atomic write in the kernel's 
device mapper API, presumably with some way to detect if it is going to 
be honoured or not. I'm not familiar enough with it to know if this is 
more complicated than I make it sound...

The mdraid layer would need to use this API, perhaps as an option, but 
arguably if it can detect the presence of this facility, that it would 
be easy to recommend as the default, presumably after a period of testing.

Bcache would need to implement this API, and ensure that the "journal" 
atomically contains, or not, all of the atomically updated blocks.

I'm also assuming that the cache device is reliable, of course, and I've 
said I'm simply trusting a single SSD (or potentially a RAID0 array of 
backing devices with LVM), but I think that simply using RAID1 for the 
cache device would give a reasonable level of reliability for the bcache 
cache/journal.

I assume it uses some kind of COW tree with an atomic update at the 
root, and ordering, so that updates to the data can be ordered behind a 
single update which "commits" the changes, and that when this is read 
back, it is able to confirm if the critical commit has been made or not. 
Perhaps another API extension to the block layer, to perform a read 
which can check with a lower layer (RAID1 in this case) that the block 
is genuinely consistent.

In my main use case, where I am storing backups which are redundantly 
stored elsewhere, and my belief that an SSD array, even a RAID0 one, is 
quite reliable, I still think this is good enough. That said, SSDs are 
cheap enough for me to use RAID1 even in this case.

I also have other use cases, for example where I would RAID0 several 
bcache+RAID5 devices into a single LVM volume group. In this case, I'd 
definitely want the extra protection on the cache device, because an 
error would potentially affect a large filesystem built on top of it.

I think that there is a further opportunity for optimisation as well. 
If, as I am lead to believe, that mdraid is strictly ordering writes to 
data blocks then parity ones, to "partially" close the write hole, then 
being able to atomically write out all the blocks that change, ie two at 
minimum, could replace the strict ordering, and this would improve 
performance, because it takes a round trip of verifying the first write 
out then peforming the second, out of the consideration.

Does this all make sense? Is this interesting for anyone else? Is there 
any other work that attempts to solve this problem?

James

On 29/10/16 02:58, Kent Overstreet wrote:
> On Fri, Oct 28, 2016 at 06:07:21PM +0100, James Pharaoh wrote:
>> On 28/10/16 12:52, Kent Overstreet wrote:
>>
>>> That's not what the raid 5 hole is. The raid 5 hole comes from the fact that
>>> it's not possible to update the p/q blocks atomically with the data blocks, thus
>>> there is a point in time when they are _inconsistent_ with the rest of the
>>> stripe, and if used will lead to reconstructing incorrect data. There's no way
>>> to fix this with just flushes.
>>
>> Yes, I understand this, but if the kernel strictly orders writing mdraud
>> data blocks before parity ones, then it closes part of the hole, especially
>> if I have a "journal" in a higher layer, and of course ensure that this
>> journal is reliable.
>
> Ordering cannot help you here. Whichever order you do the writes in, there is a
> point in time where the p/q blocks are inconsistent with the data blocks, thus
> if you do a reconstruct you will reconstruct incorrect data. Unless you were
> writing to the entire stripe, this affects data you were _not_ writing to.
>
>>
>> I also think, however, that by putting bcache /under/ mdraid, and (again)
>> ensuring that the bcache layer is reliable, along with the requirement for
>> bcache to "journal" all writes, would provide an extremely reliable storage
>> layer, even at a very large scale.
>
> What? No, putting bcache under md wouldn't do anything, it couldn't do anything
> about the atomicity issue there.
>
> Also - Vojtech - btrfs _is_ subject to the raid5 hole, it would have to be doing
> copygc to not be affceted.
>
