From: Michael Lyle <mlyle@lyle.org>
Subject: Re: best way to get the bdev of a bcache block device
Date: Mon, 22 Jan 2018 14:20:28 -0800
Message-ID: <120a1d62-87bf-c9c5-81aa-254e619c7398@lyle.org>
References: <3f40cbd2-46cd-d3d5-f43d-3e305da8ca6b@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35723 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAVWUb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jan 2018 17:20:31 -0500
Received: by mail-pf0-f178.google.com with SMTP id t12so8175240pfg.2
        for <linux-bcache@vger.kernel.org>; Mon, 22 Jan 2018 14:20:31 -0800 (PST)
In-Reply-To: <3f40cbd2-46cd-d3d5-f43d-3e305da8ca6b@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 01/22/2018 01:59 PM, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> what's the best way to get the correct bcache backing device (bdev) form
> a known dev (f.e. /dev/bcache2)?
> 
> I haven't found an easy reliable way through /sys/block.
> 
> Thanks!
> 
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

/sys/block/bcache0/slaves

/sys/block/bcache0/bcache/cache/bdev0
