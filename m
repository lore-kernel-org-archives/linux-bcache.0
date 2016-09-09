From: Christopher James Halse Rogers <chris@cooperteam.net>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Fri, 09 Sep 2016 12:07:18 +1000
Message-ID: <1473386838.30693.4@mail.cooperteam.net>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
        <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
        <20160909015629.356sy3q4gg35szbn@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:60322 "EHLO
        mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbcIICHY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2016 22:07:24 -0400
Received: from [192.168.188.40] (unknown [192.168.1.1])
        (using TLSv1 with cipher ECDHE-ECDSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: chris)
        by mail.cooperteam.net (Postfix) with ESMTPSA id 9B93A787063
        for <linux-bcache@vger.kernel.org>; Fri,  9 Sep 2016 12:07:18 +1000 (AEST)
In-Reply-To: <20160909015629.356sy3q4gg35szbn@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org



On Fri, Sep 9, 2016 at 11:56 AM, Kent Overstreet 
<kent.overstreet@gmail.com> wrote:
> On Wed, Sep 07, 2016 at 01:12:12PM -0800, Kent Overstreet wrote:
>>  So, right now we're checking i_nlinks on every mount - mainly the 
>> dirents
>>  implementation predates the transactional machinery we have now. 
>> That's almost
>>  definitely what's taking so long, but I'll send you a patch to 
>> confirm later.
> 
> I just pushed a patch to add printks for the various stages of 
> recovery: use
> mount -o verbose_recovery to enable.
> 
> How many files does this filesystem have? (df -i will tell you).
> 
> As another data point, on my laptop mounting takes half a second - 
> smallish
> filesystem though, 47 gb of data and 711k inodes (and it's on an 
> SSD). My
> expectation is that mount times with the current code will be good 
> enough as
> long as you're using SSDs (or tiering, where tier 0 is SSD) - but I 
> could use
> more data points.

FWIW, I've got a tier 0 SSD in front of two 3TB HDDs, 1.8M inodes and 
150GB used, and that takes 380ms to mount if systemd-analyse is to be 
trusted.
