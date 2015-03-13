From: Sameer Naik <sameer.subscriptions@damagehead.com>
Subject: Improving the performance of my secondary HDD
Date: Fri, 13 Mar 2015 14:46:35 +0530
Message-ID: <CAJ5s_igfWQCUfzJ11OC-8uJ_DUc5s95sHYTfKN9Pp6L4LKrp6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:32863 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbbCMJQ4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Mar 2015 05:16:56 -0400
Received: by ykt10 with SMTP id 10so9930628ykt.0
        for <linux-bcache@vger.kernel.org>; Fri, 13 Mar 2015 02:16:56 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Recently I purchased an SSD and started using bcache to speed up my
secondary HDD. My entire linux installation and home directory is
setup on the SSD and I have set aside a 20GB partition for bcache.

My secondary storage has multiple partitions all of which are setup as
backing devices and are used to store various types of file,
virtualbox disk images, etc. which are seldom accessed.

I would like to know if bcache would really be effective in my setup,
say for example to speed up the virtual machines since the HDD
partitions are being cached using bcache? Considering that my virtual
machine image sizes would be between 8 - 16 GB, would I need to
perform some level of tuning to achieve a noticeable performance
improvement.

Lastly, should I be noticing a marked improvement in the HDD write
operations or would I need to turn on "write back" mode?

Please do share your inputs.

Thanks and Regards
