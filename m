From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] bcache: set max writeback rate when I/O request is
 idle
Date: Sat, 15 Dec 2018 12:37:31 +0800
Message-ID: <8f646cbf-38b8-f3fe-5c62-8e269357e99b@suse.de>
References: <20180724040310.1590-1-colyli@suse.de>
 <CAJ+L6qcyR2nqdTJAPwi_hKx+BtDjzX+K0guJJK7xLtBU0w64eg@mail.gmail.com>
 <8046b547-d59d-2764-90f9-27698b1011f7@suse.de>
 <CAJ+L6qfVM+uSE5UbN8jtBM3F4JwYYsnZ1_R5YFkaa0Q_-J3LFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qfVM+uSE5UbN8jtBM3F4JwYYsnZ1_R5YFkaa0Q_-J3LFQ@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org, stable <stable@vger.kernel.org>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
List-Id: linux-bcache@vger.kernel.org

On 12/15/18 12:22 PM, Michael Lyle wrote:
> On Fri, Dec 14, 2018 at 8:08 PM Coly Li <colyli@suse.de> wrote:
>> Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>> just looks at single bcache device. If there are I/Os for other bcache
>> device on the cache set, and a single bcache device is idle, a faster
>> writeback rate for this single idle bcache device will happen, I/O to
>> read dirty data on cache for writeback will have negative impact to I/O
>> requests of other bcache devices.
> 
> Yes, but this will potentially fill the queue on the idle device.  If
> you have an application that is intermittently doing I/O every few
> seconds, the latency of the individual I/Os will be high.  I was told
> during review that this was unacceptable, and revised my patch.  But
> now we have merged a change that is more like my first patch that was
> rejected...

The original patch only looks at a single bcache, this fix looks at all
bcache devices.

If only a single bcache attached on cache set, by default it will be
idle for 30 seconds before the writeback rate to be set to a high rate.
And if more bcache devices attached, longer threshold required. For 4
bcache devices attached the default idle threshold will be about 120
seconds. If I/O comes between more than 30 seconds (even minutes), I
will not take it as an online system, most cases the latency should not
be sensitive, or bcache is not proper for such workload.


Coly Li
