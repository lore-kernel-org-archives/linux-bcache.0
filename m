From: "Paul B. Henson" <henson@acm.org>
Subject: RE: Another bcache hang
Date: Thu, 21 Nov 2013 17:07:02 -0800
Message-ID: <14da01cee71f$28d233f0$7a769bd0$@acm.org>
References: <20131121135604.GA26424@professorx.home.zettazebra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38414 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3KVBHI (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 21 Nov 2013 20:07:08 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so550731pbb.36
        for <linux-bcache@vger.kernel.org>; Thu, 21 Nov 2013 17:07:06 -0800 (PST)
Received: from leela (host-134-71-248-24.allocated.csupomona.edu. [134.71.248.24])
        by mx.google.com with ESMTPSA id hu10sm49004974pbc.11.2013.11.21.17.07.04
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Nov 2013 17:07:05 -0800 (PST)
In-Reply-To: <20131121135604.GA26424@professorx.home.zettazebra.com>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

> From: David H. Rhodes Clymer
> Sent: Thursday, November 21, 2013 5:56 AM
>
> I have two bcache devices with different backing devices, but with shared
> cache. The backing devices are LVM logical volumes on top of an RAID1
> software raid device (/dev/md2). The filesystem is ext4.

Off-topic, sorry, but if I understand you your layering is:

disks - mdraid - lvm - bcache - filesystem?

So you created an lv which is the backing device for bcache?

I've been looking at using bcache, but I was planning on switching the
ordering and putting bcache on top of the mdraid, then creating a pv for lvm
on the bcache device:

disks - mdraid - bcache - lvm - filesystem

Out of curiosity, I was wondering why you layered the other way.

Thanks.
