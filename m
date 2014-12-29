From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: Using vmalloc instead of get_free_pages?
Date: Mon, 29 Dec 2014 10:06:14 +0100
Message-ID: <20141229090614.GA521@cuci.nl>
References: <20141226142206.GA27239@cuci.nl>
 <CACHGV4LPBS1Y-9ciKBpPGeeF9yuF9zfPySYbBSM12m6s+8VmDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:60407 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaL2JG3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 29 Dec 2014 04:06:29 -0500
Content-Disposition: inline
In-Reply-To: <CACHGV4LPBS1Y-9ciKBpPGeeF9yuF9zfPySYbBSM12m6s+8VmDw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: linux-bcache@vger.kernel.org

Slava Pestov wrote:
>On Sat, Dec 27, 2014 at 2:52 AM, Stephen R. van den Berg <srb@cuci.nl> wrote:
>> - That the amount of memory being allocated for a single caching device
>> exceeds maximum the amount allocatable by get_free_pages(), so I changed

>As you've already noticed this is fixed in bcache-dev, but that brings in a

I already hoped it would have been, but since the ondisk format changed,
I couldn't fully confirm this yet.  I don't mind changing the on-disk format,
BTW, because I am still able to reformat the disks before the servers
go into production.

>Support for multiple cache devices is in bcache-dev, it requires changes
>to both make-bcache and the kernel. I'm not sure what the time frame for
>upstreaming this is, since the changes are more involved.

Well, I don't mind running a custom kernel and custom bcache userspace
tools for a while.  I have been rolling my own kernels since 1992.

I presume that eventually all changes will be upstreamed (including the
changes in the on-disk format)?  So, until then, I'll simply rebase bcache-dev
on top of the most recent kernels manually.

I *would* be interested in the new bcache userspace tools though then.
-- 
Stephen.
