From: Michael Lyle <mlyle@lyle.org>
Subject: (unknown)
Date: Wed, 27 Sep 2017 10:41:17 -0700
Message-ID: <20170927174122.30341-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:43810 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdI0Rlc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 13:41:32 -0400
Received: by mail-pf0-f175.google.com with SMTP id y29so7609600pff.0
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2017 10:41:32 -0700 (PDT)
Received: from localhost.localdomain (68-189-67-104.dhcp.prtv.ca.charter.com. [68.189.67.104])
        by smtp.gmail.com with ESMTPSA id v22sm3000712pfd.113.2017.09.27.10.41.30
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Sep 2017 10:41:30 -0700 (PDT)
Subject: 
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hey everyone---

After the review comments from last night, I'm back to try again :)


Thanks everyone for your help-- comments on what's changed and how
#4 helps with future work (why it's slightly more complicated) are
below.

Mike

Changes from last night:

- Changed lots of comment formatting to match the rest of bcache-style.
- Fixed a bug noticed by Tang Junhui where contiguous I/O would not be
dispatched together.
- Changed the magic number '5' and '5000' to the macros
MAX_WRITEBACKS_IN_PASS and MAX_WRITESIZE_IN_PASS
- Slight improvements to patch logs.

The net result of all these changes is better IO utilization during
writeback.  More contiguous I/O happens (whether during idle times or
when there is more activity).  Contiguous I/O is sent in proper order
to the backing device.  The control system picks better writeback
rate targets and the system can better hit them.

This is what I plan to work on next, in subsequent patches:

- Add code to skip doing small I/Os when A) there are larger I/Os in
the set, and B) the end of disk wasn't reached when scanning.  In
other words, try writing out the bigger contiguous chunks of writeback
first; give the other blocks time to end up with a larger extent next
to them.  This depends on patch 4, because it understands the true
contiguous backing I/O size and isn't fooled by smaller extents.

- Adjust bch_next_delay to store the reciprocal of what it currently
does, and remove the bounds on maximum-sleep-time.  Instead, enforce
a maximum sleep time at the writeback loop.  This will allow us to go
a long time (hundreds of seconds) without writing to the disk at all,
while still being ready to respond quickly to any increases in requested
writeback rate.  This depends on patch 4, which slightly changes the
formulation of the delay.

- Add a "fast writeback" mode, that is for use when the disk is idle.
If enabled, and there has been no I/O, it will issue one (contiguous)
write at a time at IOPRIO_CLASS_IDLE, with no delay inbetween (bypassing
the control system).  The fact that there is only one I/O and they are
at minimum IOPRIO means that good latency for the first user I/O request
will be maintained-- because they only need to compete with one writeback
I/O in the queue which is set to low priority.  This depends on patch 4 in
order to correctly merge contiguous requests in this mode.

- Add code to plug the backing device when there are more contiguous
requests coming.  This requires patch 4 (to be able to mark requests
to expect additional contiguous requests after them) and patch 5
(to properly order the I/O for the backing device).  This will help
ensure the schduler will properly merge operations (it usually works
now, but not always).

- Add code to lower writeback IOPRIO when the rate is easily being met,
so that end-user IO requests "win".
