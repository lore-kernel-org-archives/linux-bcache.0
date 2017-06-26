From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Add Bcache to an existing Filesystem
Date: Mon, 26 Jun 2017 13:12:10 -0300
Message-ID: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33973 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdFZQMO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 12:12:14 -0400
Received: by mail-qt0-f179.google.com with SMTP id 32so5099729qtv.1
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jun 2017 09:12:13 -0700 (PDT)
Received: from ?IPv6:2804:2870:3:0:bfdc:c1f1:6101:b5c6? ([2804:2870:3:0:bfdc:c1f1:6101:b5c6])
        by smtp.gmail.com with ESMTPSA id w28sm416115qth.8.2017.06.26.09.12.11
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Jun 2017 09:12:12 -0700 (PDT)
Content-Language: pt-BR
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello folks.

I have been using Bcache in a server in production with pretty good 
results so far.

Now I am looking to add it also to another server that is suffering from 
disk I/O. However this server in question has a fairly large storage 
running (circa 8TB of used data) and therefore stopping it for a long 
period becomes difficult.

Question is: Can I add an SSD and Bcache to this server and use it for 
the existing 8TB filesystem ? If so when I run make-bcache -B /dev/sdx1 
to create the backing device will it not overwrite what is currently on 
/dev/sdx1 ?

Thanks
Fernando
