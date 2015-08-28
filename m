From: Ansgar Jazdzewski <a.jazdzewski@googlemail.com>
Subject: use bcache with /dev/zram as caching device
Date: Fri, 28 Aug 2015 07:47:43 +0200
Message-ID: <CAEMVdVwOqXeL38fMghAHJ1OBMq3CDZv7FxfPvrN2DM1gv++fdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:32909 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbH1Frp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 28 Aug 2015 01:47:45 -0400
Received: by labns7 with SMTP id ns7so25895815lab.0
        for <linux-bcache@vger.kernel.org>; Thu, 27 Aug 2015 22:47:43 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

hi,

we like to use bcache with a ramdrive as cache but during the
configuration i received some errors possibly be timing related.

some one of you tryed to have a ram device as chache? before you ask:
we like to try to speed up a elasticsearch cluster so a server fail is
not an issue.

Best,
Ansgar
