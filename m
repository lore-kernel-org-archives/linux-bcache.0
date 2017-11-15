From: Alexandr Kuznetsov <progmachine@xenlab.one>
Subject: Re: bcache failure hangs something in kernel
Date: Wed, 15 Nov 2017 11:44:01 +0300
Message-ID: <eb504de7-d457-0404-585c-6b51aaeaf185@xenlab.one>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
 <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
 <87r2t1xa6w.fsf@esperi.org.uk>
 <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from forward105j.mail.yandex.net ([5.45.198.248]:38702 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755010AbdKOIoM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Nov 2017 03:44:12 -0500
In-Reply-To: <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org

> I have not experienced bcache corruption yet, though that doesn't say
> there's not an issue.  This doesn't sound at all like what Alexandr
> experienced, either.
By the way, i discovered cause of lvm hangups - it's not a bugs in lvm. 
I use lvcreate command in fully automated mode in shell script with 
suppression of any output (> /dev/null 2>&1), but when lvcreate detects 
filesystem superblock in a new volume, it ask user wether to wipe it out 
or not. User interaction is impossible in that scenario, so lvm hangs 
infinitely, leaving global lvm lock as acquired. This lock causes any 
lvm operation to hangup (sigterm or even sigkill do not help), and even 
entire system can not reboot gracefully. When i met this situation, only 
reset button, was the last thing i was able to do, and i think exactly 
this hard reset caused corruption on bcache caching device.
