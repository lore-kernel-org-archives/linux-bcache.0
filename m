From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: caching device setup
Date: Mon, 6 Apr 2015 17:44:39 +0200
Message-ID: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34762 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbbDFPok (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Apr 2015 11:44:40 -0400
Received: by lboc7 with SMTP id c7so22440513lbo.1
        for <linux-bcache@vger.kernel.org>; Mon, 06 Apr 2015 08:44:39 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Here is my overall plan:

root filesystem & OS on a SSD
DB and other stuff on HD.
Use ssd as caching device and HD as backing.

Shall I partition the SSD with : one partition for OS and one empty
for bcache? Or install the OS on the whole SSD and use the whole SSD
as caching device?

Thank you for hint.

-- 

google.com/+arnaudgabourygabx
