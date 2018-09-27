From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Thu, 27 Sep 2018 22:18:55 +0200
Message-ID: <b5a258f4-2d58-04ad-96f7-22cd42588a3c@profihost.ag>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
 <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Eddie Chapman <eddie@ehuk.net>
Cc: Coly Li <colyli@suse.de>, guoju <fangguoju@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Coly,

is this the deadlock I reported some weeks ago?

Greets,
Stefan

Excuse my typo sent from my mobile phone.

Am 27.09.2018 um 17:53 schrieb Eddie Chapman <eddie@ehuk.net
<mailto:eddie@ehuk.net>>:

> On 27/09/18 16:23, Coly Li wrote:
>> On 9/27/18 9:45 PM, guoju wrote:
>>> After write SSD completed, bcache schedule journal_write work to
>>> system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM
>>> flag. system_wq is also a bound wq, and there may be no idle kworker on
>>> current processor. Creating a new kworker may unfortunately need to
>>> reclaim memory first, by shrinking cache and slab used by vfs, which
>>> depends on bcache device. That's a deadlock.
>>>
>>> This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
>>> flag. It's rescuer thread will work to avoid the deadlock.
>>>
>>> Signed-off-by: guoju <fangguoju@gmail.com <mailto:fangguoju@gmail.com>>
>> Nice catch, this fix is quite important. I will try to submit to Jens
>> ASAP.
>> Thanks.
>> Coly Li
>
> Once this goes into 4.19, would this be a candidate for backporting to
> any stable kernels, or does it only fix something introduced in this
> cycle?
>
> thanks,
> Eddie
