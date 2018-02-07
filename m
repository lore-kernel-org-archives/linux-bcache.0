From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Bcache patches for inclusion in 4.16
Date: Wed, 7 Feb 2018 13:33:36 -0700
Message-ID: <35326bbb-0a35-3f0b-c83b-0b81864d1728@kernel.dk>
References: <20180207194146.5095-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180207194146.5095-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2/7/18 12:41 PM, Michael Lyle wrote:
> Hi Jens---
> 
> Here are a few more changes for 4.16 from Coly Li and Tang Junhui.
> 
> Probably the most "functional" is 2/8, which makes a change to improve a
> performance bug under sustained small writes.  Still, it's a small, safe
> change that seems good to take.  The rest are small bugfixes.
> 
> All have seen some degree of test (which is, of course, always ongoing).
> 
> Note that there's one checkpatch error in this, but it was already present
> and is just triggered by altering an adjacent line.
> 
>  9 files changed, 111 insertions(+), 36 deletions(-)
> 
> Coly Li (3):
>       bcache: properly set task state in bch_writeback_thread()
>       bcache: set error_limit correctly
>       bcache: set writeback_rate_update_seconds in range [1, 60] seconds
> 
> Tang Junhui (5):
>       bcache: add journal statistic
>       bcache: fix high CPU occupancy during journal
>       bcache: fix for allocator and register thread race
>       bcache: return attach error when no cache set exist
>       bcache: fix for data collapse after re-attaching an attached device

Applied, thanks.

-- 
Jens Axboe
