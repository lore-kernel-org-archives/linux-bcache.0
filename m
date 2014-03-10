From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Slow writing of dirty data (bcache)
Date: Mon, 10 Mar 2014 11:34:45 -0500
Message-ID: <531DE9A5.90801@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:50594 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbaCJRHV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Mar 2014 13:07:21 -0400
Received: from [IPv6:2601:e:1200:c80:52e5:49ff:febe:9a2b] ([IPv6:2601:e:1200:c80:52e5:49ff:febe:9a2b])
	(authenticated bits=0)
	by mail.nuclearwinter.com (8.14.4/8.14.4) with ESMTP id s2AGYgYn015143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-bcache@vger.kernel.org>; Mon, 10 Mar 2014 11:34:43 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm seeing an odd behavior after updating to kernel
3.13.5-202.fc20.x86_64 from 3.12.7-300.fc20.x86_64.

I have a bcache device (bcache2) which backs a raid5 array (md2) that
has 160+MB of dirty data. The dirty data is being written at a rate of 1
page per second (8 sectors). At this rate it'll take 11 hrs to finish. I
like to keep this array spun down when inactive but the drives can't
spin down since they're being written to once a second.

# cat /sys/block/bcache2/bcache/writeback_rate
512

# cat /sys/block/bcache2/bcache/writeback_rate_debug
rate:           512/sec
dirty:          161M
target:         40.8G
proportional:   -35.2M
derivative:     0
change:         -35.2M/sec
next io:        624ms

This never happened when running 3.12.7. Is there anything I can do
about this?

--Larkin
