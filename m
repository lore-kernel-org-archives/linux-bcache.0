From: Jason Warr <jason@warr.net>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 21 Jul 2015 16:53:44 -0500
Message-ID: <55AEBF68.1060008@warr.net>
References: <20150714005825.GA24027@kmo-pixel>
 <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:35048 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933673AbbGUWCt (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 21 Jul 2015 18:02:49 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 0C5AD2112B3
	for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2015 21:53:47 +0000 (UTC)
In-Reply-To: <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: David Mohr <david@mcbf.net>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com



On 7/21/2015 1:37 PM, David Mohr wrote:
> On 2015-07-13 18:58, Kent Overstreet wrote:
>> Short announcement, because I'm in the process of moving - but I 
>> wanted to get
>> this out there because the code is up and I think it's reasonably 
>> stable right
>> now.
>>
>> Bcachefs is a posix filesystem that I've been working towards for - 
>> well, quite
>> awhile now: it's intended as a competitor/replacement for 
>> ext4/xfs/btrfs.
>>
>> Current features
>>  - multiple devices
>>  - replication
>>  - tiering
>>  - data checksumming and compression (zlib only; also the code 
>> doesn't work with
>>    tiering yet)
>>  - most of the normal posix fs features (no fallocate or quotas yet)
>>
>> Planned features:
>>  - snapshots!
>>  - erasure coding
>>  - more
>>
>> There will be a longer announcement on LKML/linux-fs in the near 
>> future (after
>> I'm finished moving) - but I'd like to get it a bit more testing from 
>> a wider
>> audience first, if possible.
>
> Hi Kent,
>
> one quick question about the roadmap at this point: As far as I 
> understand bcachefs basically integrates bcache features directly in 
> the filesystem. So does this deprecate bcache itself in your opinion? 
> Bcache is obviously still useful for other FS, but I just want to know 
> how things will get maintained in the future.
>
It would be rather disappointing if this were the case.  bcache is quite 
useful for backing block devices that have no local filesystem, such as 
devices exported via iSCSI, devices used directly by VMs, etc...

> I wanted to suggest / possibly start implementing bcache support for 
> the debian installer - obviously that only makes sense if I can expect 
> it to be in the mainline kernel for the foreseeable future :-).
>
> Thanks,
> ~David
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
