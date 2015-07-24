From: Jason Warr <jason@warr.net>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 24 Jul 2015 14:42:11 -0500
Message-ID: <55B29513.7080306@warr.net>
References: <20150714005825.GA24027@kmo-pixel>
 <468c161352fd5f77ec371ce256f27e14@de.mcbf.net> <55AEBF68.1060008@warr.net>
 <20150724193251.GC1928@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:51913 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754578AbbGXTmM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 24 Jul 2015 15:42:12 -0400
In-Reply-To: <20150724193251.GC1928@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org



On 7/24/2015 2:32 PM, Kent Overstreet wrote:
> On Tue, Jul 21, 2015 at 04:53:44PM -0500, Jason Warr wrote:
>>
>> On 7/21/2015 1:37 PM, David Mohr wrote:
>>> On 2015-07-13 18:58, Kent Overstreet wrote:
>>>> Short announcement, because I'm in the process of moving - but I wanted
>>>> to get
>>>> this out there because the code is up and I think it's reasonably stable
>>>> right
>>>> now.
>>>>
>>>> Bcachefs is a posix filesystem that I've been working towards for -
>>>> well, quite
>>>> awhile now: it's intended as a competitor/replacement for
>>>> ext4/xfs/btrfs.
>>>>
>>>> Current features
>>>> - multiple devices
>>>> - replication
>>>> - tiering
>>>> - data checksumming and compression (zlib only; also the code doesn't
>>>> work with
>>>>    tiering yet)
>>>> - most of the normal posix fs features (no fallocate or quotas yet)
>>>>
>>>> Planned features:
>>>> - snapshots!
>>>> - erasure coding
>>>> - more
>>>>
>>>> There will be a longer announcement on LKML/linux-fs in the near future
>>>> (after
>>>> I'm finished moving) - but I'd like to get it a bit more testing from a
>>>> wider
>>>> audience first, if possible.
>>> Hi Kent,
>>>
>>> one quick question about the roadmap at this point: As far as I understand
>>> bcachefs basically integrates bcache features directly in the filesystem.
>>> So does this deprecate bcache itself in your opinion? Bcache is obviously
>>> still useful for other FS, but I just want to know how things will get
>>> maintained in the future.
>>>
>> It would be rather disappointing if this were the case.  bcache is quite
>> useful for backing block devices that have no local filesystem, such as
>> devices exported via iSCSI, devices used directly by VMs, etc...
>   - bcachefs/bcache2 getting merged is a _long_ way off, and when it does it's
>     going to be more of an ext2/ext3 thing - the existing upstream bcache version
>     will stay there for the foreseeable future.
>
>   - bcachefs/bcache2 still has all the same functionality bcache has for caching
>     other block devices, and exporting thin provisioned block devices - that
>     functionality won't be going away any time soon, if ever - so you'll be able
>     to migrate to the new bcache code and on disk format without changing
>     anything about how you use it.
>   
>     The "backing device/cached dev" path _might_ eventually get deprecated in
>     favor of having bcache manage all the block devices directly and export thin
>     provisioned block devices - this is the existing "flash_vol_create"
>     functionality.
>
>     Reason being the thin provisioned/fully bcache managed block devices path is
>     quite a bit simpler and diverges less from the functionality bcachefs uses -
>     and also cache coherency is fundamentally easier with bcache managing all the
>     storage so performance should be better too.
>
>     However, if the backing device functionality ever gets removed it's a _long_
>     ways off, and I'll be asking for user feedback and making sure the thin
>     provisioned/bcache managed block devices functionality works for everyone
>     first.
As long as we get the same basic functionality in addition to the 
filesystem layer, it sounds like you plan on that, I'm happy.

Thank you for addressing this.
