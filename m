From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: tuning for mixed rate 800 stream write application
Date: Sat, 04 Oct 2014 21:30:05 +0200
Message-ID: <teu5gb-oed.ln1@hurikhan77.spdns.de>
References: <542F59FC.1080806@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJFLUG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Oct 2014 07:20:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Xb6Kh-00076w-Vq
	for linux-bcache@vger.kernel.org; Mon, 06 Oct 2014 13:20:04 +0200
Received: from ip4d17fce2.dynamic.kabel-deutschland.de ([77.23.252.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 06 Oct 2014 13:20:03 +0200
Received: from hurikhan77 by ip4d17fce2.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 06 Oct 2014 13:20:03 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Stan Hoeppner <stan@hardwarefreak.com> schrieb:

> Hello fellow bcache users/developers,
> 
> A couple of questions.
> 
> 1.  How do I disable write caching?
> 2.  How do I increase the sequential IO tracking window from 128 IOs to
> say 4096 IOs or nmore?

I don't know which of the various knobs bcache considers but you can tune 
the IO window for the kernel IO scheduler with something like this:

#!/bin/sh

for nr_requests in 
/sys/bus/scsi/devices/[012]:0:0:0/block/*/queue/nr_requests; do
        echo -n 4096 >$nr_requests
done

I suggest switching to deadline also if you haven't done so yet.

Please note that my script tunes my SATA devices. I don't use bcache yet. 
You may want to adjust the line to work for the bcache devices.

-- 
Replies to list only preferred.
