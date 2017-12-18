From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: deadlock in bcache, kernel or xfs?
Date: Mon, 18 Dec 2017 08:52:01 +0100
Message-ID: <7be57cd8-f82b-3304-b26b-ec178982465c@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39841 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750792AbdLRHwD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Dec 2017 02:52:03 -0500
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello,

today crashed a server with the following traces. Can somebody tell me
whether it's a bug in bcache or some other code?

https://pastebin.com/raw/HepE1z3v

Greets,
Stefan
