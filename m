From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache removal: ida_remove called for id=64 which is not
 allocated.
Date: Sat, 25 Nov 2017 15:40:44 -0800
Message-ID: <86f09bf6-0953-4345-43e6-1f61bd7cef14@lyle.org>
References: <20171125231127.7kv7uypcj3pbddqo@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:41670 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdKYXkr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Nov 2017 18:40:47 -0500
Received: by mail-pf0-f173.google.com with SMTP id j28so15789354pfk.8
        for <linux-bcache@vger.kernel.org>; Sat, 25 Nov 2017 15:40:47 -0800 (PST)
In-Reply-To: <20171125231127.7kv7uypcj3pbddqo@merlins.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, linux-bcache@vger.kernel.org

Marc--

Thanks for the report.

On 11/25/2017 03:11 PM, Marc MERLIN wrote:
> Howdy,
> 
> This has been an issue for a while, but it's not fatal.
> Nonetheless, I guess I should report it.
> 
> I trigger it like this:
> echo 1 > /sys/block/md5/bcache/stop
> sleep 5
> mdadm --stop /dev/md5
> (this was backed by bcache64)
> 
> bcache: bcache_device_free() bcache64 stopped
> ida_remove called for id=64 which is not allocated.

I believe this is fixed by 1dbe32ad0a82f39c6 which is in Linus's tree
for 4.15.  Unfortunately it's not a candidate for -stable because it
changes device numbering.

Can you easily try a 4.15 RC to see if this is fixed for you?

Thanks,

Mike
