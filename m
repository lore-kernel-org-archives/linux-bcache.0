From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: Re: [bcachefs-testing] BUG: unable to handle kernel paging request at
 0000005780540006
Date: Mon, 12 Dec 2016 11:26:08 +0100
Message-ID: <ac5b11bb-20e7-2a32-f317-0545a9e50e78@mejor.pl>
References: <b66c17f1-19d0-702f-f09e-acd6e5116587@mejor.pl>
 <20161209232557.elip24quin24awq5@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:25066 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754111AbcLLK1C (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Dec 2016 05:27:02 -0500
In-Reply-To: <20161209232557.elip24quin24awq5@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 10.12.2016 o 00:25, Kent Overstreet pisze:
> On Fri, Dec 09, 2016 at 11:08:05AM +0100, marcin@mejor.pl wrote:
>> Hi all!
>>
>> Kernel at:
>> commit a3cccb56d861c0092be2b58cbaf7b44e298f59bc
>> Author: Kent Overstreet <kent.overstreet@gmail.com>
>> Date:   Thu Dec 8 14:41:14 2016 -0900
>>
>>     bcache: increase default journal write delay for spinning rust
>>
>>
>> Today I tried to use bcachefs as /home. After sometime, when I do backup
>> of /home I got:
>>
>>> Dec  9 10:44:09 localhost kernel: [ 3517.194588] BUG: unable to handle kernel paging request at 0000005780540006
> 
> Ok, I see what's wrong - fix is up in bcachefs-testing


Hi!
Now it works stable. Thank you.
Btw,
# cat cache_available_percent
108

Shouldn't it be equal or below 100?

Marcin
