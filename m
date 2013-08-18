From: Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: bcache: Fix a writeback performance regression
Date: Mon, 19 Aug 2013 00:09:24 +0200
Message-ID: <52114614.4070509@profihost.ag>
References: <20130814225904.GA6427@kmo-pixel> <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <520DFAB4.1050402-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


Vanilla 3.10.7 + bcache: Fix a writeback performance regression

http://pastebin.com/raw.php?i=LXZk4cMH

Stefan

Am 16.08.2013 12:11, schrieb Stefan Priebe - Profihost AG:
> Hi,
>
> bcache: Fix a writeback performance regression
>
> this one results in 3.10 into hung tasks in bcache_writeback read_dirty.
>
> Stefan
> Am 15.08.2013 08:43, schrieb Stefan Priebe - Profihost AG:
>> Am 15.08.2013 00:59, schrieb Kent Overstreet:
>>> Jens, here's the latest bcache fixes. Some urgent stuff in here:
>>>
>>>
>>> The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:
>>>
>>>    bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>    git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11
>>>
>>> for you to fetch changes up to 0434a516e99ee51ac2d0dfa71b2f56c89ac5db05:
>>>
>>>    bcache: Fix a flush/fua performance bug (2013-08-14 15:44:51 -0700)
>>>
>>> ----------------------------------------------------------------
>>> Gabriel de Perthuis (1):
>>>        bcache: Strip endline when writing the label through sysfs
>>>
>>> Geert Uytterhoeven (1):
>>>        bcache: Correct printf()-style format length modifier
>>>
>>> Kent Overstreet (4):
>>>        bcache: Fix a dumb journal discard bug
>>>        bcache: Fix for when no journal entries are found
>>>        bcache: Fix a writeback performance regression
>>>        bcache: Fix a flush/fua performance bug
>>>
>>>   drivers/md/bcache/bcache.h    |  7 +++----
>>>   drivers/md/bcache/btree.c     |  2 +-
>>>   drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
>>>   drivers/md/bcache/sysfs.c     |  9 +++++++--
>>>   drivers/md/bcache/util.c      | 11 ++++++++++-
>>>   drivers/md/bcache/util.h      | 12 +++++++++---
>>>   drivers/md/bcache/writeback.c | 37 ++++++++++++++++++-------------------
>>>   7 files changed, 68 insertions(+), 43 deletions(-)
>>> --
>>
>> As 3.10 is long term stable release. You might need CC the stable list
>> for patches which have to go to 3.10 as well.
>>
>> At least this one should go to 3.10:
>>> Gabriel de Perthuis (1):
>>>        bcache: Strip endline when writing the label through sysfs
>>
>> Thanks!
>>
>> Greets,
>> Stefan
>>
