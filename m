From: Coly Li <i@coly.li>
Subject: =?UTF-8?Q?Re:_Question_about=c2=a0hot-plug_of=c2=a0bcache?=
Date: Tue, 6 Jun 2017 10:23:13 +0800
Message-ID: <48ee35aa-baa2-e707-c6b2-d061c6118ede@coly.li>
References: <201706060949503158946@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:60086 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdFFCX2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Jun 2017 22:23:28 -0400
In-Reply-To: <201706060949503158946@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/6 上午9:49, tang.junhui@zte.com.cn wrote:
> Hello Coly,
> 
> 
> ＞ I didn't care about hot-plug cache device so far. What I concern is, if
> 
> ＞ cache device or backing device failed, how bcache handles such situation
> 
> ＞ and tries best to avoid kernel panic. There should be a few things to
> 
> ＞ fix I guess.
> 
> 
> When can you work out this patch? Please let me known
> 
> as soon as possible.

It is in my todo list, but I need to find a time to work on it, not on
my schedule yet....

> I think  hot-plug is also important, can we have any plane to support
> 
> it in the future?

I don't have such a plan currently. If there is another layer between
bache and real disk, e.g. raid1 as cache device, then hot-plug is
transparent to bcache code. A general hot-plug support to bcache code is
too difficult to me ...


-- 
Coly Li
