From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/2] bcachefs: On disk data structures
Date: Sun, 13 May 2018 15:49:21 -0700
Message-ID: <3bf4a87c-20fc-0b9f-1c27-c43d1c194b47@infradead.org>
References: <20180508221800.2642-1-kent.overstreet@gmail.com>
 <20180508221800.2642-2-kent.overstreet@gmail.com>
 <dea41935-a52c-e720-0ca3-eef4367d3641@infradead.org>
 <20180513222948.GA20114@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180513222948.GA20114@kmo-pixel>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

On 05/13/2018 03:29 PM, Kent Overstreet wrote:
> On Sun, May 13, 2018 at 01:30:06PM -0700, Randy Dunlap wrote:
>> On 05/08/2018 03:17 PM, Kent Overstreet wrote:
> 
>>> + * various btrees. There are only a small number of btrees, they're not
>>> + * sharded - we have one btree for extents, another for inodes, et cetera.
>>
>>    or shared?
> 
> No, I mean sharded - we're e.g. not splitting up the extents btree into one
> btree per inode. 

Got it, thanks.

>> I know that you have already answered a few comments about endianness,
>> so maybe you answered this and I missed it.
>>
>> Can a bcachefs fs be shared, a la NFS?  I.e., can multiple different-endian
>> clients be accessing the same bcachefs?
> 
> NFS works. I haven't tested NFS to different endian clients, wasn't aware there
> was any reason to... are there potential issues there I'm not aware of?

Not that I know of.

thanks,
-- 
~Randy
