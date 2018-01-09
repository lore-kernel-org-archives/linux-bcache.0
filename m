From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix inaccurate io state for detached bcache
 devices
Date: Tue, 9 Jan 2018 10:35:59 +0800
Message-ID: <6aefd70d-7ca2-c1ec-a6c7-1d2c299b9946@suse.de>
References: <1515464831-20866-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1515464831-20866-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 09/01/2018 10:27 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> When we run IO in a detached device,  and run iostat to shows IO status,
> normally it will show like bellow (Omitted some fields):
> Device: ... avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdd        ... 15.89     0.53    1.82    0.20    2.23   1.81  52.30
> bcache0    ... 15.89   115.42    0.00    0.00    0.00   2.40  69.60
> but after IO stopped, there are still very big avgqu-sz and %util 
> values as bellow:
> Device: ... avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> bcache0   ...      0   5326.32    0.00    0.00    0.00   0.00 100.10
> 
> The reason for this issue is that, only generic_start_io_acct() called
> and no generic_end_io_acct() called for detached device in
> cached_dev_make_request(). See the code:
> //start generic_start_io_acct()
> generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
> if (cached_dev_get(dc)) {
> 	//will callback generic_end_io_acct()
> }
> else {
> 	//will not call generic_end_io_acct()
> }
> 
> This patch calls generic_end_io_acct() in the end of IO for detached
> devices, so we can show IO state correctly.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

It looks good to me. Reviewed-by: Coly Li <colyli@suse.de>

I also modify the backing device bi_end_io to catch I/O status in my
backing device failure patches, so I am thinking of pick this patch into
my device failure patch set, then Mike does not need to merge the conflict.

Coly Li

[code snipped]
