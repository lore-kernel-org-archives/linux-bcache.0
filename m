From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: set max writeback rate when I/O request is idle
Date: Fri, 14 Dec 2018 20:22:14 -0800
Message-ID: <CAJ+L6qfVM+uSE5UbN8jtBM3F4JwYYsnZ1_R5YFkaa0Q_-J3LFQ@mail.gmail.com>
References: <20180724040310.1590-1-colyli@suse.de> <CAJ+L6qcyR2nqdTJAPwi_hKx+BtDjzX+K0guJJK7xLtBU0w64eg@mail.gmail.com>
 <8046b547-d59d-2764-90f9-27698b1011f7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8046b547-d59d-2764-90f9-27698b1011f7@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org, stable <stable@vger.kernel.org>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
List-Id: linux-bcache@vger.kernel.org

On Fri, Dec 14, 2018 at 8:08 PM Coly Li <colyli@suse.de> wrote:
> Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
> just looks at single bcache device. If there are I/Os for other bcache
> device on the cache set, and a single bcache device is idle, a faster
> writeback rate for this single idle bcache device will happen, I/O to
> read dirty data on cache for writeback will have negative impact to I/O
> requests of other bcache devices.

Yes, but this will potentially fill the queue on the idle device.  If
you have an application that is intermittently doing I/O every few
seconds, the latency of the individual I/Os will be high.  I was told
during review that this was unacceptable, and revised my patch.  But
now we have merged a change that is more like my first patch that was
rejected...

Mike
