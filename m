From: feng D <fengidri@gmail.com>
Subject: disk gone
Date: Fri, 2 Jun 2017 17:31:25 +0800
Message-ID: <C081436D-3227-4388-A1DF-9764FB693924@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37379 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdFBJbe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 2 Jun 2017 05:31:34 -0400
Received: by mail-it0-f44.google.com with SMTP id m47so12179634iti.0
        for <linux-bcache@vger.kernel.org>; Fri, 02 Jun 2017 02:31:33 -0700 (PDT)
Received: from [10.0.1.131] ([157.119.232.29])
        by smtp.gmail.com with ESMTPSA id y2sm39582605pfk.1.2017.06.02.02.31.31
        for <linux-bcache@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 02 Jun 2017 02:31:32 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

hi:

Some time, the online machine will appear disk gone situation, although =
this is not very common, but we have too many machines, so still will =
encounter it.

That in the case of disk gone, /sys/block/bcache0/bcache/stop is not =
found, this case how to delete the bcache0?

There is if it is SSD gone, and how should deal with it?

We have multiple SATA disks under an SSD.=
