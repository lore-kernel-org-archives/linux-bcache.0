From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache_writebac task 100% CPU
Date: Tue, 20 May 2014 21:38:35 +0200
Message-ID: <537BAF3B.2020607@rolffokkens.nl>
References: <53786E02.8060300@rolffokkens.nl> <20140519165550.GD2276@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38667 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaETTij (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 20 May 2014 15:38:39 -0400
Received: by mail-ee0-f42.google.com with SMTP id d49so876180eek.15
        for <linux-bcache@vger.kernel.org>; Tue, 20 May 2014 12:38:37 -0700 (PDT)
In-Reply-To: <20140519165550.GD2276@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

On 05/19/2014 06:55 PM, Kent Overstreet wrote:
> ...Changing it back to 25% doesn't do anything? _that_ is odd...
>
> Can you send me the output of writeback_rate_debug? Check it once before you've
> done anything, when things are working normally (after a fresh boot when
> writeback_percent is nonzero, probably), then grab it again after you've set
> writeback_percent to 0 and then back to 25, when it's still spinning.
I collected the requested data by logging both writeback_percent and 
writeback_rate_debug every second. Every second also the cumulative CPU 
usage of the bcache_writebac task is logged (as shown by ps -efw), 
showing that the task is burning CPU cycles.

Both the collecting script and the log file can be found here: 
https://bugzilla.kernel.org/show_bug.cgi?id=76391
> Also, what kernel are you running?
As mentioned before, the kernel is Fedora kernel 
kernel-3.14.4-200.fc20.x86_64
