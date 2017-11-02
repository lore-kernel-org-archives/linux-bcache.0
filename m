From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: add a comment in journal bucket reading
Date: Thu, 2 Nov 2017 09:31:30 -0700
Message-ID: <af5a9d9c-9088-6b1e-c72f-cb1f6e02174b@lyle.org>
References: <1509592094-26115-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1509592094-26115-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Tang--

On 11/01/2017 08:08 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Journal bucket is a circular buffer, the bucket
> can be like YYYNNNYY, which means the first valid journal in
> the 7th bucket, and the latest valid journal in third bucket, in
> this case, if we do not try we the zero index first, We
> may get a valid journal in the 7th bucket, then we call
> find_next_bit(bitmap,ca->sb.njournal_buckets, l + 1) to get the
> first invalid bucket after the 7th bucket, because all these
> buckets is valid, so no bit 1 in bitmap, thus find_next_bit()
> function would return with ca->sb.njournal_buckets (8). So, after
> that, bcache only read journal in 7th and 8the bucket,
> the first to the third buckets are lost.
> 
> So, it is important to let developer know that, we need to try
> the zero index at first in the hash-search, and avoid any breaks
> in future's code modification.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Fixed a small whitespace error at end of line.

Reviewed-by: Michael Lyle <mlyle@lyle.org>

Thank you for making this much more clear.

Mike
