From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: bcachefs with cache device and backing device
Date: Thu, 12 May 2016 18:50:26 -0700
Message-ID: <573532E2.1040201@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42045
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbcEMB4J (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 12 May 2016 21:56:09 -0400
Received: from [10.94.141.27] (daytank.gemtalksystems.com [10.94.141.27])
	by office-ns.gemtalksystems.com (Postfix) with ESMTP id 2DB782283C
	for <linux-bcache@vger.kernel.org>; Thu, 12 May 2016 18:50:26 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm trying out bcachefs for the first time. I can follow the
instructions (format a cache device, mount it type bcache) and it works.

What I'd like to do, however, is to have an SSD cache device, and a
rotating-disk backing device, as a bcachefs filesystem. Is this
something that bcachefs can do at present? If so, what's the basic
procedure?

Thanks,

-Martin
