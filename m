From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 13/16] bcache: fix fifo index swapping condition in
 btree_flush_write()
Date: Sat, 20 Apr 2019 21:20:35 +0800
Message-ID: <9100e2d9-16bb-3632-c931-890f2ee0f5d4@suse.de>
References: <20190419160509.66298-14-colyli@suse.de>
 <20190419231642.90AB82171F@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190419231642.90AB82171F@mail.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/4/20 7:16 上午, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.0.8, v4.19.35, v4.14.112, v4.9.169, v4.4.178, v3.18.138.
> 
> v5.0.8: Build OK!
> v4.19.35: Build OK!
> v4.14.112: Failed to apply! Possible dependencies:
>     a728eacbbdd2 ("bcache: add journal statistic")
>     c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
> 
> v4.9.169: Failed to apply! Possible dependencies:
>     a728eacbbdd2 ("bcache: add journal statistic")
>     c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
> 
> v4.4.178: Failed to apply! Possible dependencies:
>     a728eacbbdd2 ("bcache: add journal statistic")
>     c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
> 
> v3.18.138: Failed to apply! Possible dependencies:
>     a728eacbbdd2 ("bcache: add journal statistic")
>     c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
> 
> 
> How should we proceed with this patch?

This patch will go into Linux v5.2. We can have them in stable after
they being upstream.

Thanks.

-- 

Coly Li
