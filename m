From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Thu, 16 Nov 2017 20:02:55 -0800
Message-ID: <1c715cc2-b656-36a8-4017-55052937df82@lyle.org>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Rui Hua <huarui.dev@gmail.com>, Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi, Rui Hua--

On 11/16/2017 07:51 PM, Rui Hua wrote:
> In this patch, we use s->read_dirty_data to judge whether the read
> request hit dirty data in cache device, it is safe to reread data from
> the backing device when the read request hit clean data. This can not
> only handle cache read race, but also recover data when failed read
> request from cache device.

I haven't read over all of this yet, to understand the read race.  But
this change can't be safe-- read_dirty_data only is set to true if the
metadata on the cache device is correctly read.  If that fails, the flag
may not be set and we could read stale data on the backing device.

Mike
