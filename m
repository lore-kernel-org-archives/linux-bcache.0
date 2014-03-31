From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 14:13:56 +0200
Message-ID: <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331120623.GA28637@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57787 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaCaMOh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 08:14:37 -0400
Received: by mail-ob0-f169.google.com with SMTP id va2so9114467obc.0
        for <linux-bcache@vger.kernel.org>; Mon, 31 Mar 2014 05:14:37 -0700 (PDT)
In-Reply-To: <20140331120623.GA28637@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 31, 2014 at 2:06 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Mon, Mar 31, 2014 at 01:47:21PM +0200, Daniel Smedegaard Buus wrote:
>>
>> I'm trying to figure out what the correct way of taking down a bcache
>> cache device is.
>>
>> If I echo 1 to /sys/block/BACKING_DEVICE/bcache/detach, and then to
>> /sys/fs/bcache/*/unregister, the system will hang. The detach part
>> goes well, but immediately after unregistering, it will crash.
>
> Try sleeping at least two seconds between the operations.
>

Hi Sitsofe, thanks for replying :)

I actually tried sleeping for five seconds, I'll try upping it and see
what happens.
