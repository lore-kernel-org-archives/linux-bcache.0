From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache_writebac task 100% CPU
Date: Mon, 19 May 2014 20:01:46 +0200
Message-ID: <537A470A.7080808@rolffokkens.nl>
References: <53786E02.8060300@rolffokkens.nl> <20140519165550.GD2276@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64253 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaESSBt (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 19 May 2014 14:01:49 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so3895958eek.30
        for <linux-bcache@vger.kernel.org>; Mon, 19 May 2014 11:01:47 -0700 (PDT)
In-Reply-To: <20140519165550.GD2276@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

On 05/19/2014 06:55 PM, Kent Overstreet wrote:
> ...Changing it back to 25% doesn't do anything? _that_ is odd...

I was wrong on this one. At first the CPU usage stayed the same, but 
after a while (as in > 10 minutes) CPU usage dropped to normal 
behaviour. Sorry, I was too impatient.

> Can you send me the output of writeback_rate_debug? Check it once before you've
> done anything, when things are working normally (after a fresh boot when
> writeback_percent is nonzero, probably), then grab it again after you've set
> writeback_percent to 0 and then back to 25, when it's still spinning.
I will do so, probably tomorrow.
> There seems to be two separate bugs here, the one I'm particularly concerned
> about is why setting writeback_percent back to 25 doesn't restore the old
> behaviour.
>
> Also, what kernel are you running?
I am using Fedora kernel version kernel-3.14.4-200.fc20.x86_64
