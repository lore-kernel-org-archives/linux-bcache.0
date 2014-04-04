From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Performance testing with bcache
Date: Fri, 4 Apr 2014 12:10:53 -0700
Message-ID: <CALJ65zm2C5xX0am76ZNK4N2Uai+3U8bQENHcfjU_KOOb4+1iAw@mail.gmail.com>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com>
	<2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com>
	<20140313205259.GA28293@sucs.org>
	<216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com>
	<1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com>
	<20140315175212.GA20197@sucs.org>
	<459660524.313506.1396631210130.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50706 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaDDTKx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 4 Apr 2014 15:10:53 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so4051140oag.13
        for <linux-bcache@vger.kernel.org>; Fri, 04 Apr 2014 12:10:53 -0700 (PDT)
In-Reply-To: <459660524.313506.1396631210130.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

How much data is being bypassed?

On Fri, Apr 4, 2014 at 10:06 AM, Andrew Martin <amartin@xes-inc.com> wrote:
> Sitsofe,
>
> ----- Original Message -----
>> From: "Sitsofe Wheeler" <sitsofe@yahoo.com>
>> To: "Andrew Martin" <amartin@xes-inc.com>
>> Cc: linux-bcache@vger.kernel.org
>> Sent: Saturday, March 15, 2014 12:52:15 PM
>> Subject: Re: Performance testing with bcache
>>
>> On Fri, Mar 14, 2014 at 04:16:27PM -0500, Andrew Martin wrote:
>> >
>> > Do you have an example fio job file that has worked well for testing
>> > bcache?
>>
>> Try these as a starting point:
>> benchmark-seq.fio:
>> ; Script to gather general sequential write performance statistics
>> ; Basic usage:
>> ; BS="4k" DEV="sdf" RT=90 SEED=21 TYPE="ssd" fio benchmark-seq.fio
>
> I ran the example job files with the commands you posted, but the output
> bandwidth seems extremely low:
> http://pastebin.com/13RBYwwp
> http://pastebin.com/bsp9KbDq
>
> fio job file:
> http://pastebin.com/zfVJdjMQ
>
> Am I doing something wrong when running fio?
>
> Thanks,
>
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
