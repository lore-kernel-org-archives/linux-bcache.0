From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Re: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 15:06:54 -0300
Message-ID: <02d7b0af-6bf7-43ca-334b-dee67dbbb553@upx.com>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
 <alpine.LRH.2.11.1706261752580.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36835 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdFZSHA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 14:07:00 -0400
Received: by mail-qk0-f176.google.com with SMTP id p21so7666489qke.3
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2017 11:07:00 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1706261752580.17052@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Thanks for reply Eric.

That sounds quiet dangerous to risk 8TB of production data. I guess the 
only safe way is re-formating the partition and therefore it would mean 
8TB copied-out then copied back in which imposes a longer downtime to 
the server.

Best regards
Fernando


On 26/06/2017 14:58, Eric Wheeler wrote:
> On Mon, 26 Jun 2017, FERNANDO FREDIANI wrote:
>
>> Hello folks.
>>
>> I have been using Bcache in a server in production with pretty good results so
>> far.
>>
>> Now I am looking to add it also to another server that is suffering from disk
>> I/O. However this server in question has a fairly large storage running (circa
>> 8TB of used data) and therefore stopping it for a long period becomes
>> difficult.
>>
>> Question is: Can I add an SSD and Bcache to this server and use it for the
>> existing 8TB filesystem ? If so when I run make-bcache -B /dev/sdx1 to create
>> the backing device will it not overwrite what is currently on /dev/sdx1 ?
>
> Not officially.  The bcache superblock is in the first 8k of disk (by
> default, but can align the payload) so 8TB would need shifted right
> assuming the right-hand-side has room to grow.
>
> Disclaimer: this could be dangerous, so at your own risk:
>
> While I've not tried this, theoretically you could put dm-linear atop of
> the bcache bdev and prepend some metadata area, using the `--data-offset`
> parameter in make-bcache as the start of your data area.  Be sure to test
> on something non-critical if you go this route and make sure the sector
> math is correct or risk damaging the front of your 8TB volume.  If you go
> this route and it works, please report back with what you did!
>
> --
> Eric Wheeler
>
>
>
>> Thanks
>> Fernando
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
