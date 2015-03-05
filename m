From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Fwd: bcache memory footprint
Date: Thu, 5 Mar 2015 15:01:05 +0000
Message-ID: <CAM2wQBtzFrZ9Zwx6tNv0aOXMtLXAw-dX09PodE1QUdSyoS0A5w@mail.gmail.com>
References: <CAM2wQBuQeSS_pJeDsCkA24nr16km+ecrsqXf_Ac4G9SCxH951g@mail.gmail.com>
	<CAM2wQBu8cTjv=moA5MzwbYsccowsoy0UAiAT+G4FXfCp0xJ8cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36341 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbbCEPBF (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Mar 2015 10:01:05 -0500
Received: by ierx19 with SMTP id x19so77154872ier.3
        for <linux-bcache@vger.kernel.org>; Thu, 05 Mar 2015 07:01:05 -0800 (PST)
In-Reply-To: <CAM2wQBu8cTjv=moA5MzwbYsccowsoy0UAiAT+G4FXfCp0xJ8cQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Is there a simple way to determine the memory footprint of bcache for
a given cache? I had a look at http://bcache.evilpiepirate.org/Design/
but it doesn't seem to clearly mention the memory footprint of bcache.

I'd expect the metadata to play a major role in the memory footprint,
but is there anything else that affects it (e.g. bucket size, block
size, write through vs. write back, size of the SSD and HDD)? Does
bcache's memory usage fluctuate depending on the work load or is it
static?

Is this information readily available or do I have to dive into the code?
