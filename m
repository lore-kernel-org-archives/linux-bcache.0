From: Coly Li <i@coly.li>
Subject: =?UTF-8?Q?Re:_Question_about=c2=a0hot-plug_of=c2=a0bcache?=
Date: Tue, 6 Jun 2017 09:22:58 +0800
Message-ID: <4f811814-d634-d024-e6d2-7b0b1b3fd5cb@coly.li>
References: <201706060916041857626@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59826 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdFFBXI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Jun 2017 21:23:08 -0400
In-Reply-To: <201706060916041857626@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/6 上午9:16, tang.junhui@zte.com.cn wrote:
> Hello Coly, Eric
> 
> 
> ＞ Does cache device of bcache support hot-plug?
> 
> ＞ If not, is it easy to support?
> 
> ＞ Please give me some suggestion to make bcache
> 
> ＞ supportting hot-plug.   
> 
> 
> Could you give me some suggestion for
> 
> this question?
> 

Hi Junhui,

I didn't care about hot-plug cache device so far. What I concern is, if
cache device or backing device failed, how bcache handles such situation
and tries best to avoid kernel panic. There should be a few things to
fix I guess.

Thanks for this interesting question :-)

-- 
Coly Li
