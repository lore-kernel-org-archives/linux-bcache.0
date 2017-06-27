From: Coly Li <i@coly.li>
Subject: Re: Question about gc time
Date: Wed, 28 Jun 2017 01:08:35 +0800
Message-ID: <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li>
References: <OF3C6614C4.E95909E3-ON4825814C.004157B0-4825814C.004253A0@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:34998 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751919AbdF0RIu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 13:08:50 -0400
In-Reply-To: <OF3C6614C4.E95909E3-ON4825814C.004157B0-4825814C.004253A0@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/6/27 下午8:04, tang.junhui@zte.com.cn wrote:
> Hello Eric, Coly,
> 
> I use a 1400G SSD device a bcache cache device,
> and attach with 10 back-end devices,
> and run random small write IOs,
> when gc works, It takes about 15 seconds,
> and the up layer application IOs was suspended at this time,
> How could we bear such a long time IO stopping?
> Is there any way we can avoid this problem?
> 
> I am very anxious about this question, any comment would be valuable.

I encounter same situation too.
Hmm, I assume there are some locking issue here, to prevent application
to send request and insert keys in LSM tree, no matter in writeback or
writethrough mode. This is a lazy and fast response, I need to check the
code then provide an accurate reply :-)


-- 
Coly Li
