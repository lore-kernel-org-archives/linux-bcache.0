From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation failure:
 order:4, mode:0x2040d0
Date: Mon, 15 Feb 2016 16:45:40 +0100
Message-ID: <56C1F2A4.4090208@evilazrael.de>
References: <20160215060410.GA30802@merlins.org>
 <20160215121104.GA30514@kmo-pixel> <20160215060410.GA30802@merlins.org>
 <20160215120255.GE18134@c203.arch.suse.de>
 <20160215153236.GI4115@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from evilazrael.net ([5.10.172.2]:44560 "EHLO mail.evilazrael.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbcBOPxw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Feb 2016 10:53:52 -0500
In-Reply-To: <20160215153236.GI4115@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

Hello Marc,
Am 15.02.2016 um 16:32 schrieb Marc MERLIN:
>>> and it fails:
>>> bash: page allocation failure: order:4, mode:0x2040d0
>> You want CONFIG_COMPACTION=y
> Good suggestion, but I already have it:
> gargamel:~# grep CONFIG_COMPACTION /boot/config-4.3.3-amd64-i915-volpreempt-20150421
> CONFIG_COMPACTION=y
>
> Thanks for the replies,
> Marc
Maybe increasing vm.min_free_kbytes helps you.

Regards

Christoph
