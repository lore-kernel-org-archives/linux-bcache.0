From: Kai Krakow <hurikhan77@gmail.com>
Subject: Reasoning of exposing queue/rotational=0
Date: Thu, 4 May 2017 23:24:57 +0200
Message-ID: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52788 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdEDVZG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2017 17:25:06 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d6OF8-0002ci-Uf
        for linux-bcache@vger.kernel.org; Thu, 04 May 2017 23:24:58 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello!

What's the reasoning for exposing bcache devices as being
non-rotational? Currently, it fools btrfs into using ssd allocation
scheme on the underlying harddisks which isn't really what I expected
to get. So I used a udev rule to change this:

ACTION=="add|change", KERNEL=="bcache*", ATTR{queue/rotational}="1"

Wouldn't it make more sense to set this to the same value as the
underlying backing device by default?

Because in reality, the bcache is still what the backing device is: A
rotational medium. A cache doesn't make this non-rotational.

Thoughts?

-- 
Regards,
Kai

Replies to list-only preferred.
