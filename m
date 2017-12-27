From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: fix wrong return value in bch_debug_init()
Date: Wed, 27 Dec 2017 14:22:49 -0800
Message-ID: <4f2a250e-d185-c53e-7d98-013fda58f7f3@lyle.org>
References: <1514201980-30595-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514201980-30595-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 12/25/2017 03:39 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> in bch_debug_init(), ret is always 0, and the return value is useless,
> change it to return 0 if be success after calling debugfs_create_dir(),
> else return a non-zero value.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

LGTM, applied to my staging branch.  (Still line ending issues but
easily fixed with checkpatch.pl --fix)

Thanks,

Mike
