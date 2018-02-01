From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] [PATCH v2] bcache: fix for allocator and register thread
 race
Date: Thu, 1 Feb 2018 13:55:41 -0800
Message-ID: <adcfc52c-95ab-d3da-5526-47b3c9b70f70@lyle.org>
References: <1516883456-4170-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:42265 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbeBAVzn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 16:55:43 -0500
Received: by mail-pg0-f42.google.com with SMTP id j16so11661847pgn.9
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2018 13:55:43 -0800 (PST)
In-Reply-To: <1516883456-4170-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hi Tang Junhui--

On 01/25/2018 04:30 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
[snip]
> The stack shows the register thread and allocator thread
> were getting stuck when registering cache device.

This looks good-- applying to my 4.16-related test branch.

Reviewed-by: Michael Lyle <mlyle@lyle.org>
