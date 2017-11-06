From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Enabling discard rendered caching device unuseable
Date: Mon, 6 Nov 2017 11:04:35 +0100
Message-ID: <CAFvQSYTrzA=i6Xww3vGRs+Wu3sHg_hjXMY1JmEdfNb8hD2Phxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:55876 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbdKFKEg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Nov 2017 05:04:36 -0500
Received: by mail-it0-f41.google.com with SMTP id l196so4430298itl.4
        for <linux-bcache@vger.kernel.org>; Mon, 06 Nov 2017 02:04:36 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

After using bcache for 9 months without any issues, I discovered the
"discard" flag for the caching device.
Running 4.13.5 I gave it a try, however after reboot the caching
device failed to register with:

At reboot bcache failed with:
prio_read() bad csum reading priorities
prio_read() bad magic reading priorities

The SSD used as caching device was a OCZ-OCTANE with the latest
firmware, which worked (and works) flawlessly for years and has no
SMART issues.

Best regards, Clemens
