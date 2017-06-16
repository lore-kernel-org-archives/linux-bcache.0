From: =?UTF-8?B?5p6X5aSV?= <linuxcode2niki@gmail.com>
Subject: clean residual bcache devices when disk lost
Date: Fri, 16 Jun 2017 09:40:00 +0800
Message-ID: <CAJx_Wsp_=HAhVfgkRBTXUmWkrD_EjbxPRvrwDypJHXq1sQ0QFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:34857 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFPBkC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2017 21:40:02 -0400
Received: by mail-it0-f54.google.com with SMTP id m62so27410368itc.0
        for <linux-bcache@vger.kernel.org>; Thu, 15 Jun 2017 18:40:02 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache <linux-bcache@vger.kernel.org>

Hi , recently I did some research about bcache, I found a situation
when disks(backing devices or cache devices) went wrong or just lost
,I can=E2=80=99t find a method to clean the residual devices data, such as
/sys/block/bcache0 , bcache0/bcache not existed.  And I can see
bcache0 using lsblk.


And  I also read the source code of bcache kernel module, I create a
file named "unregisterall"  in dir /sys/fs/bcache/, when I did "echo 1
> unregisterall" ,I will  call bcache_reboot function manual.  But it
failed.


So, My Question is how to clean dead devices ( bcache0=E2=80=A6) purely?


Thanks!


Smaug.Jiao
