From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Sat, 03 Jan 2015 17:40:24 +0100
Message-ID: <54A81B78.2070409@rolffokkens.nl>
References: <20141228023534.GA25860@cuci.nl> <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51894 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbACQk1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 3 Jan 2015 11:40:27 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so5775371wes.15
        for <linux-bcache@vger.kernel.org>; Sat, 03 Jan 2015 08:40:26 -0800 (PST)
In-Reply-To: <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>
Cc: linux-bcache@vger.kernel.org

Hi Slava,

Sounds like the kernel (using bcache-dev) is not able to handle the 
current format. If so, bcache-tools may help in "reformatting" bcache 
devices, but that's no solution for existing systems.

So is my understanding correct that there's no easy kernel upgrade path 
(to bcache-dev) ?

Rolf

On 12/29/2014 05:05 AM, Slava Pestov wrote:
> Hi Stephen,
>
> The bcache-dev branch has on-disk format changes that require a new
> bcache-tools. I'm not sure where Kent posts the source for that.
>
> On Sat, Dec 27, 2014 at 6:35 PM, Stephen R. van den Berg <srb@cuci.nl> wrote:
>> Now I tried this:
>> Combine 3.18.1 and rebase all the patches from bcache-dev onto that.
>> But, in trying that, I get a consistent:
>>
>> register_bcache() error opening /dev/sdb3: Invalid superblock: member info area missing
>>
>> Anything I overlooked?   The bcache-tools are straight from git too.
>> --
>> Stephen.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
