From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?YmNhY2hlIHBlcmZvcm1hbmNl?=
Date: Sun, 11 Jan 2015 22:16:27 +0800
Message-ID: <544e0c43-6081-4360-8153-3391caf1582a@aliyun.com>
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpcm9-112.freemail.mail.aliyun.com ([115.124.18.12]:41080
	"EHLO smtpcm9-112.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbbAKOd0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 11 Jan 2015 09:33:26 -0500
References: 19072dac-785e-404a-9a47-f9649de83311@aliyun.com
In-Reply-To: 19072dac-785e-404a-9a47-f9649de83311@aliyun.com
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, linux-bcache <linux-bcache@vger.kernel.org>

when I test bcache on linux 3.10 kernel, use writeback cache mode, the capability of the ssd cache is 240G.
 
fio -filename=/dev/bcache0 -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=4k -size=80G -numjobs=8 -runtime=30000 -group_reporting -name=mytes 
 
the performance can reach to 1.2w. after two hours running, the performance drop to 500. what is the reason?
when stop fio,  iostat show results:
 
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sde            2697.00         0.00        10.54          0         10
sdc               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sda               0.00         0.00         0.00          0          0
sdb            2715.00        10.55         0.06         10          0
dm-0              0.00         0.00         0.00          0          0
dm-1              0.00         0.00         0.00          0          0
dm-2              0.00         0.00         0.00          0          0
dm-3              0.00         0.00         0.00          0          0
dm-4              0.00         0.00         0.00          0          0
bcache0           0.00         0.00         0.00          0          0
