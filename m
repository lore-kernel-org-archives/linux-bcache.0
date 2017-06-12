From: Tony Asleson <tasleson@redhat.com>
Subject: Having option for make-bcache to wait until udev is done
Date: Mon, 12 Jun 2017 16:31:46 -0500
Message-ID: <0fe6a6f0-40f6-0bd1-b957-80f8e24141fd@redhat.com>
Reply-To: tasleson@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752756AbdFLVcH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Jun 2017 17:32:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2470F285CF
        for <linux-bcache@vger.kernel.org>; Mon, 12 Jun 2017 21:31:47 +0000 (UTC)
Received: from tasleson.remote.csb (ovpn-116-136.phx2.redhat.com [10.3.116.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECA6F52FD6
        for <linux-bcache@vger.kernel.org>; Mon, 12 Jun 2017 21:31:46 +0000 (UTC)
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

When you run `make-bcache -B <backing-dev> -C <cache-dev>` the utility
writes the super block(s) of all the devices specified and exits.  Then
udev in conjunction with the bcache udev rules file will do the register
etc. as needed to bring the device up.  Thus if someone scripts bcache
creation there is a race condition between when make-bcache runs and
when the user that issued the command can use the newly created device.

I think it might be better to have an option to wait until done with the
tool or make the default behavior to wait until everything is actually
done?  Otherwise, people need to either do explicit udev settles,
sleeps, sysfs polling, etc. to ensure operation is fully completed.

Thoughts, suggestions?

Thanks!
-Tony
