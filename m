From: Ming Lin <mlin@kernel.org>
Subject: Re: [bcachefs] Mounting the same device multiple times now works
Date: Wed, 12 Aug 2015 21:57:25 -0700
Message-ID: <CAF1ivSY_iCd7W-WH7AdnnLtwhnNdtvAj67OQADPNdOeHuK6Vew@mail.gmail.com>
References: <20150811083453.GA29708@kmo-pixel>
	<1439315982.19144.7.camel@ssi>
	<20150812013853.GA2192@kmo-pixel>
	<1439364962.5775.4.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbHME5a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 00:57:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1C55D206CB
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 04:57:29 +0000 (UTC)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com [209.85.213.43])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id AC405207A6
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 04:57:26 +0000 (UTC)
Received: by vkfi73 with SMTP id i73so13936820vkf.2
        for <linux-bcache@vger.kernel.org>; Wed, 12 Aug 2015 21:57:25 -0700 (PDT)
In-Reply-To: <1439364962.5775.4.camel@hasee>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, Aug 12, 2015 at 12:36 AM, Ming Lin <mlin@kernel.org> wrote:
> On Tue, 2015-08-11 at 17:38 -0800, Kent Overstreet wrote:
>> On Tue, Aug 11, 2015 at 10:59:42AM -0700, Ming Lin wrote:
>> > On Tue, 2015-08-11 at 00:34 -0800, Kent Overstreet wrote:
>> > > Like in other filesystems, you can now do
>> > >
>> > > mount /dev/sda1 /foo
>> > > mount /dev/sda1 /bar
>> > >
>> > > What this really means is that if the udev hook has registered the bcache device
>> > > via the old style sysfs interface for caching, you'll still be able to mount the
>> > > device like normal.
>> >
>> > Thanks!
>> >
>> > BTW, could you share the bcachefs long term development plans and short
>> > term high priority tasks?
>>
>> Right now, my main priority is stabilizing it and making it usable - fixing all
>> the things that people are going to trip over when they try it out. I want to
>> get it somewhat more polished before I announce on linux-fsdevel.
>>
>> The big thing I'm working on at the moment is debugging atomic renames, I had to
>> back that code out at the last minute.
>>
>> > I'd like to pick something to work on. Probably the debugfs tool you
>> > mentioned or other things?
>>
>> One thing that would actually be really helpful is more benchmarking vs.
>> ext4/xfs - identifying areas where there's still more performance work to do.
>>
>> The debugfs tool is definitely important but that's a longer term thing. If
>> you're feeling productive like that feel free to keep going with it.
>>
>> Really though right now the main thing we need is more testing and debugging.
>
> I have run xfstests. Here is the results for generic tests.
> http://minggr.net/pub/bcachefs/xfstests.log
>
> One thing is fallocate not supported yet. Is it known?

Yes, fallocate is not implemented in bch_file_operations.

>
> root@bee:~# mount |grep bcache
> /dev/sda on /mnt/test type bcache (rw,relatime)
>
> root@bee:~# fallocate -l 4096 /mnt/test/hello.c
> fallocate: /mnt/test/hello.c: fallocate failed: Operation not supported
>
