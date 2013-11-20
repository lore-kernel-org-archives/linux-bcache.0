From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Net-snmp module?
Date: Wed, 20 Nov 2013 13:17:42 -0600
Message-ID: <528D0AD6.3080002@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:41645 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754428Ab3KTTRm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 20 Nov 2013 14:17:42 -0500
Received: from [10.0.0.100] ([10.0.0.100])
	(authenticated bits=0)
	by mail.nuclearwinter.com (8.14.4/8.14.4) with ESMTP id rAKJHedu011501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-bcache@vger.kernel.org>; Wed, 20 Nov 2013 13:17:41 -0600
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I've googled around and haven't seen any discussions of SNMP monitoring
for bcache. I would like to volunteer to write a net-snmp module for
bcache. Has any work (or discussions, thoughts, etc) been done in this
area? Any objections?

My intent is to produce a module for inclusion in net-snmp if they will
permit it, or as a dynamically loadable module (.so) if they do not.

--Larkin
