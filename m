From: Stefan Priebe <s.priebe@profihost.ag>
Subject: bcache deadlock
Date: Sat, 1 Aug 2015 08:08:40 +0200
Message-ID: <55BC6268.3060407@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:18522 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbHAGIh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 1 Aug 2015 02:08:37 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

any ideas about this deadlock:
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task xfsaild/bcache4:2433 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:683 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:679 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:675 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:671 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:667 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task bcache_writebac:654 blocked for more 
than 120 seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task kswapd0:79 blocked for more than 120 
seconds.
2015-08-01 00:05:05     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
2015-08-01 00:05:05     INFO: task kthreadd:2 blocked for more than 120 
seconds.

Stefan
