From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH 2/3] bcache: writeback: properly order backing
 device IO
Date: Wed, 27 Dec 2017 18:38:59 -0800
Message-ID: <f0aff580-97a1-00d8-9a94-be8e38fce690@lyle.org>
References: <1514424646-3221-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514424646-3221-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Tang Junhui--

On 12/27/2017 05:30 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> LGTM, and I tested it, it promotes the write-back performance.
> [Sorry for the wrong content in the previous email]
> 
> Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
> Tested-by: Tang Junhui <tang.junhui@zte.com.cn>

Thank you very much for the review.  Does this also apply to 1/3 (which
is needed for this patch to apply)?

Mike
