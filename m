From: Marcin <marcin@mejor.pl>
Subject: [bcachefs] problem with `bcache fsck`
Date: Thu, 16 Mar 2017 16:16:29 +0100
Message-ID: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:38986 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdCPPTT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Mar 2017 11:19:19 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
It's good to hear that silence on mailinglist doesn't mean that there is 
no changes in developing bcachefs!

I found some problems with bcache tools.
bcache fsck errors:

a) if I creat4e filesystem and run fsck before first mount I'm getting:
# bcache fsck /dev/sdd1
initializing new filesystem
error opening /dev/sdd1: cannot allocate new btree root

b) After first mount%umount fsck still doesn't work:
# bcache fsck /dev/sdd1
no journal entries found
filesystem contains errors, but repair impossible
error opening /dev/sdd1: fsck error

bcachefs-tools at commit d4e6736e59c96

Is bcache fsck able to do fsck on tiered devices?
I know that there is some stability problem with tiered devices because 
when I mounted tiered fs and started to copy files on it the host 
rebooted after some time. I have to run netconsole to catch what kernel 
says, then I post it on ML.

And I'm still missing compression saves free space on disk:)

Marcin
