From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: Re: [bcachefs-testing] missing inode 6502 (nlink 1) (repair
 unimplemented)
Date: Thu, 22 Dec 2016 16:45:35 +0100
Message-ID: <f92920ef-77c5-b314-292f-528e8eaf2055@mejor.pl>
References: <850720fc-0d61-1f10-8e2a-39e644fb79e0@mejor.pl>
 <20161220025613.lm6mzkloodtknwol@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:40064 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932546AbcLVPp6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Dec 2016 10:45:58 -0500
In-Reply-To: <20161220025613.lm6mzkloodtknwol@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 20.12.2016 o 03:56, Kent Overstreet pisze:
> On Tue, Dec 13, 2016 at 10:29:47AM +0100, marcin@mejor.pl wrote:
>> Hi Kent, all!
>>
>> Yesterday I was testing bcacefs mounted at /home on desktop. Next I
>> hibernated box. Today I resumed OS, upgraded kernel to:
>> commit ee9f55a7cd209a821f79c1092b5c53959ab1bc47
>> Author: Kent Overstreet <kent.overstreet@gmail.com>
>> Date:   Thu Dec 8 17:28:02 2016 -0900
>>
>>     bcache: don't flush journal unnecessarily
>>
>> commit 125312566ed797bc0c8b87ae9dbf694a68ddef33
>> Author: Kent Overstreet <kent.overstreet@gmail.com>
>> Date:   Mon Dec 12 12:53:56 2016 -0900
>>
>>     bcache: short circuit bch_prio_write() and journal flush when possible
>>
>>
>> and next I rebooted. Now I can't mount /home because of error (it's not
>> problem, I've got backup). Error is:
> 
> I _think_ this one is fixed in bcache-dev now - I found some bugs in the
> journalling code thanks to Josef Bacik's dm log-writes tool, and the new torture
> test isn't finding any new bugs.
> 
> Let me know if you see it again, once you grab the latest code.

Hi!
To be clear, should I format filesystem? I'm asking because on both
branches (bcache-dev and bcachefs-testing I see this error while
mounting). Should I still sit at bcachefs-testing?
Regards,
Marcin
