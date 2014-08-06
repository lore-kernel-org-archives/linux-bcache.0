From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: (unknown)
Date: Wed, 6 Aug 2014 14:06:36 +0200
Message-ID: <CAHnuAey8g7OUZPS6QQP_4h6P07=6q8r3J6kZr8D=DJ67fwFhfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57386 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHFMHR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 6 Aug 2014 08:07:17 -0400
Received: by mail-oa0-f52.google.com with SMTP id o6so1720959oag.25
        for <linux-bcache@vger.kernel.org>; Wed, 06 Aug 2014 05:07:16 -0700 (PDT)
Subject: 
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi :)

I just tried upgrading a server of mine from mainline kernel 3.15.4 to
3.16, and upon reboot no bcache device in sight. Grepping dmesg for
bcache yielded an empty output, and besides the dmesg was full of
oopses.

This is a live server, so I immediately remove kernel 3.16, and upon
reboot, bcache was back and happy.

I know this isn't very useful for anything debugging, but as a very
general question, I'm just wondering if there's something I should
have done prior to upgrading, or if this might be a bug of some sort?

Cheers,
Daniel
