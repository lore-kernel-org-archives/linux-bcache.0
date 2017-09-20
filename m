From: Coly Li <colyli@suse.de>
Subject: Re: [PATCHv2] bcache: option for allow stale data on read failure
Date: Wed, 20 Sep 2017 12:28:29 +0200
Message-ID: <db997d70-9d0d-fd27-1c7c-7f602499aea4@suse.de>
References: <20170919222433.24336-1-colyli@suse.de>
 <CAJ+L6qeLMsCAVsdNkertg2BzwVHcq4ZZ==E8gojo9O2cutWrVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qeLMsCAVsdNkertg2BzwVHcq4ZZ==E8gojo9O2cutWrVQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/9/20 上午8:59, Michael Lyle wrote:
> Coly--
> 
> It's an interesting changeset.

Hi Mike,

Yes it's interesting :-) It fixes a silent database data corruption in
our product kernel. The most dangerous point is, it happens silent even
in-data checksum is used, this issue is detected by out-of-data checksum.

> I am not positive if it will work in practice-- the most likely
> objects to be cached are filesystem metadata.  Won't most filesystems
> fall apart if some of their data structures revert back to an earlier
> point of time?

For database workload, most of data cached on SSD is data blocks of
database file which are replied from binlog (for example mysql). File
system won't complain for such situation, and an early version means all
transactions information since last update are all lost, in *silence*.

Even the read request failed on file system meta data, because finally a
stale data will be provided to kernel file system code, it is probably
file system won't complain as well. Because,
- file system reports error when I/O failed, if a stale data from
recovery provided to file system, file system just uses the stale data
until a worse failure detected by file system code.
- if file system use a metadata checksum, and the checksum is inside
metadata block (it is quite common), because the stale data is also
checksum consistent, file system won't report error as well.

So the data corruption happens in application level, even file system
kernel code still thinks everything is consistent on disk ....

Thanks.

Coly Li


> On Tue, Sep 19, 2017 at 3:24 PM, Coly Li <colyli@suse.de> wrote:
>> When bcache does read I/Os, for example in writeback or writethrough mode,
>> if a read request on cache device is failed, bcache will try to recovery
>> the request by reading from cached device. If the data on cached device is
>> not synced with cache device, then requester will get a stale data.
>>
>> For critical storage system like database, providing stale data from
>> recovery may result an application level data corruption, which is
>> unacceptible. But for some other situation like multi-media stream cache,
>> continuous service may be more important and it is acceptible to fetch
>> a chunk of stale data.
>>
>> This patch tries to solve the above conflict by adding a sysfs option
>>         /sys/block/bcache<idx>/bcache/allow_stale_data_on_failure
>> which is defaultly cleared (to 0) as disabled. Now people can make choices
>> for different situations.
>>
>> With this patch, for a failed read request in writeback or writethrough
>> mode, recovery a recoverable read request only happens in one of the
>> following conditions,
>>  - dc->has_dirty is zero. It means all data on cache device is synced to
>>    cached device, the recoveried data is up-to-date.
>>  - dc->has_dirty is non-zero, and dc->allow_stale_data_on_failure is set
>>    to 1. It means there is dirty data not synced to cached device yet, but
>>    option allow_stale_data_on_failure is set, receiving stale data is
>>    explicitly acceptible for requester.
>>
>> For other cache modes in bcache, read request will never hit
>> cached_dev_read_error(), they don't need this patch.
>>
>> Please note, because cache mode can be switched arbitrarily in run time, a
>> writethrough mode might be switched from a writeback mode. Therefore
>> checking dc->has_data in writethrough mode still makes sense.
>>
>> Changelog:
>> v2: rename sysfs entry from allow_stale_data_on_failure  to
>>     allow_stale_data_on_failure, and fix the confusing commit log.
>> v1: initial patch posted.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Reported-by: Arne Wolf <awolf@lenovo.com>
>> Cc: Nix <nix@esperi.org.uk>
>> Cc: Kai Krakow <hurikhan77@gmail.com>
>> Cc: Eric Wheeler <bcache@lists.ewheeler.net>
>> Cc: Junhui Tang <tang.junhui@zte.com.cn>
>> Cc: stable@vger.kernel.org

[snip]
