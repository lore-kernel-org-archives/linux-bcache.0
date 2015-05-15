From: Ming Lin <mlin@kernel.org>
Subject: Re: bcache and load average
Date: Fri, 15 May 2015 15:47:43 -0700
Message-ID: <CAF1ivSb32U+KGfe1EAUsM04ASjYp=qFB8wD+sxqx2-7PJOYuEA@mail.gmail.com>
References: <20150515185032.6b129595@harpe.intellique.com>
	<alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
	<20150515203736.GB24997@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58069 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934155AbbEOWrr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 15 May 2015 18:47:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9C1A62058E
	for <linux-bcache@vger.kernel.org>; Fri, 15 May 2015 22:47:46 +0000 (UTC)
Received: from mail-vn0-f53.google.com (mail-vn0-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id A65E420584
	for <linux-bcache@vger.kernel.org>; Fri, 15 May 2015 22:47:44 +0000 (UTC)
Received: by vnbf1 with SMTP id f1so8345231vnb.0
        for <linux-bcache@vger.kernel.org>; Fri, 15 May 2015 15:47:43 -0700 (PDT)
In-Reply-To: <20150515203736.GB24997@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Emmanuel Florac <eflorac@intellique.com>, linux-bcache@vger.kernel.org

On Fri, May 15, 2015 at 1:37 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, May 15, 2015 at 10:55:32AM -0700, Eric Wheeler wrote:
>> > Going through various forum messages and bug reports (for Debian:
>> > https://lists.debian.org/debian-kernel/2015/03/msg00060.html for Arch:
>> > https://bugs.archlinux.org/task/38843 for some other distro:
>> > https://groups.google.com/forum/#!msg/esos-users/NXp8tG7sVE8/QXZyPdZ2saIJ
>> > ) it looks like the bcache_writeback kernel thread, being in
>> > uninterruptible sleep, keeps the load average at 1.0 (or maybe more)
>> > always. Could you please confirm this ?
>>
>> Try the attached patches that I've been collecting over the past year or
>> two. I do not believe they have been merged into mainline (BUT SOMEONE
>> NEEDS TO).
>>
>> I am not sure that these address the load bug, but if the load is being
>> increased by a large amount of dmesg output caused by rcu traces, then the
>> patches will help.
>
> I just put all five of them into a 4.0.3 kernel, but sadly they don't
> fix the load average bug.  That said, they look like pretty reasonable
> bugfixes to me.  Maybe someone should just send them to Linus, if the
> maintainer hasn't otherwise objected?

I have put the patches here.
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=bcache

I'm new to bcache code.
I'll read these patches and run some tests.

Ming
