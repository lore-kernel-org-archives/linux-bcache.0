From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Commits for 4.15-- bcache
Date: Fri, 24 Nov 2017 16:23:56 -0700
Message-ID: <ba0a4e01-e130-08ca-ea9b-28a15c79f94a@kernel.dk>
References: <20171124231427.9563-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171124231427.9563-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 11/24/2017 04:14 PM, Michael Lyle wrote:
> Hi Jens,
> 
> We have a few more small things:
> 
> Huacai Chen (1):
>       bcache: Fix building error on MIPS
> 
> Michael Lyle (1):
>       bcache: check return value of register_shrinker
> 
> Rui Hua (1):
>       bcache: recover data from backing when data is clean
> 
> Tang Junhui (1):
>       bcache: add a comment in journal bucket reading
> 
> Most important is Rui Hua's change, which prevents EINTR from being
> returned to users unexpectedly (and is cc'd stable).  All changes are
> reviewed and have had a moderate degree of test.

Thanks, all look fine for this series, applied.

-- 
Jens Axboe
