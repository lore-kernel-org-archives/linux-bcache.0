From: Lucas Clemente Vella <lvella@gmail.com>
Subject: Extreme slowdown
Date: Fri, 8 May 2015 12:05:40 -0300
Message-ID: <CAGCathwwYPfTCzQMQHH+hE4antbjfZZYEoPY7SYcb1Cp_q9XUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33706 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbbEHPGD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 8 May 2015 11:06:03 -0400
Received: by iepj10 with SMTP id j10so62363049iep.0
        for <linux-bcache@vger.kernel.org>; Fri, 08 May 2015 08:06:01 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I don't know what is causing it, maybe the poor SSD quality, but I am
downloading a game on Steam with rate of 2.2 MB/s, and it is clogging
the filesystem access. Opening a new website halts for several seconds
on checking the local cache. Same thing on opening applications and
even clicking the XFCE menu.

My home and root partitions shares the same backing SSD device,
configured in writeback mode. Is there any configuration I could make
to mitigate the issue?

-- 
Lucas Clemente Vella
lvella@gmail.com
