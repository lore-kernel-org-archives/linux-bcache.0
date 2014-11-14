From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
Subject: Why is writeback_percent capped at 40?
Date: Fri, 14 Nov 2014 09:07:47 +0000
Message-ID: <01E9BC45-EACD-4042-A8D2-7E297D6108B8@cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([188.184.36.50]:10655 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaKNJNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 14 Nov 2014 04:13:17 -0500
Content-Language: en-US
Content-ID: <AD4A6A252525FB42A5615184DCD11443@cern.ch>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

Apologies if this is obvious, but why is writeback_percent capped at 40%?

To always have some free space to cache reads from the backing device?
To protect the user and limit the impact of an SSD failure (at least to some
degree)?
The vm subsystem seems to have had similar values in the past (10 to start
background writeback, 40 to make the writer synchronous), was bcache maybe
inspired by these values?

Thanks!
 Arne


--
Arne Wiebalck
CERN IT
