From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: bcache and hibernation
Date: Thu, 13 Nov 2014 14:52:02 +0100
Message-ID: <87h9y3xl6l.fsf@bluescreen303.nl>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63719 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaKMNwG (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Nov 2014 08:52:06 -0500
Received: by mail-wi0-f170.google.com with SMTP id r20so1944784wiv.5
        for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2014 05:52:04 -0800 (PST)
Received: from bluebook.local.bluescreen303.nl (bluebook.bluescreen303.nl. [2a01:7c8:aaad:310::b10e:b00c])
        by mx.google.com with ESMTPSA id dc8sm25827793wib.7.2014.11.13.05.52.02
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2014 05:52:03 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

Today, I lost most my data (don't worry, got backups) after the cache
got corrupted somehow. I suspected a recent suspend-to-disk to be the
cause. I checked how my distribution (NixOS) handles suspend/resume and
I have some concerns about how bcache fits into this.

Normally, the kernel and initrd get loaded. The initrd loads required
kernel modules, waits for udev to settle, activates luks&lvm, then
finally asks the kernel to resume from the resume device.

The kernel documentation on suspend is VERY clear you should NOT touch
anything on disk between suspend and resume. So activating luks and LVM
is probably risky already, but it apppears both luks and LVM do not make
any on-disk changes when activated and any in-memory state (within the
resumed image) is still valid. The benefit of activating luks and LVM
before resume seems to be that it allows resuming from encrypted/lvm
volumes. 

Now, with bcache added, things probably get a bit hairy. NixOS supports
bcache inside the initrd and uses udev rules to activate/attach. I
suspect this is probably unsafe. Probably bcache starts to see if any
dirty pages exist, to write them to the backing store. Even without
writeback caching, the activation of lvm will read some sectors, which
might trigger the cache to update. Then after resuming the image, the
in-memory state is corrupted and further damage occurs. 

- Does this sound plausible? 
- Is there any way to tell bcache to make absolutely no changes to
  either the backing device or the cache?
  Basically like a readaround+writearound which can be triggered on
  hibernate and switched off on resume.

Thanks,
Mathijs
