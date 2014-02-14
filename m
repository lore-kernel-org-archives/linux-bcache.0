From: Andrew Martin <amartin@xes-inc.com>
Subject: Use md RAID or DRBD device as cache device?
Date: Fri, 14 Feb 2014 09:31:26 -0600 (CST)
Message-ID: <2007303220.15775.1392391886349.JavaMail.zimbra@xes-inc.com>
References: <1984991001.15726.1392391813633.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:6442 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaBNPb1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 14 Feb 2014 10:31:27 -0500
Received: from zimbra.xes-mad.com (zimbra.xes-mad.com [10.52.0.127])
	by xes-mad.com (8.13.8/8.13.8) with ESMTP id s1EFVQtR011174
	for <linux-bcache@vger.kernel.org>; Fri, 14 Feb 2014 09:31:26 -0600
In-Reply-To: <1984991001.15726.1392391813633.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

Is it possible to use any block device, e.g a md RAID1 or DRBD device, as the cache device with bcache? This would allow for redundancy of the cache device even though multiple, distinct caches per set are not supported yet.

Thanks,

Andrew Martin
