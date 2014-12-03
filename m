From: Thomas Stein <himbeere@meine-oma.de>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Wed, 03 Dec 2014 12:25:04 +0100
Message-ID: <547EF310.6080202@meine-oma.de>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>  <20141101204447.GB22219@kmo-pixel>  <546FC2B4.5020201@message-id.invalid.com>  <CALJ65znHdPCoYLKuGXrRtg9aUkoKgxmOVn=Bw04WP5f=Vt_DxA@mail.gmail.com> <1416615728.4084.325.camel@geekdesk.ewheeler.net> <5470858B.9090900@message-id.googlemail.com> <alpine.DEB.2.02.1411241049410.18167@ware.dreamhost.com> <547ED8A1.5050706@message-id.googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from meine-oma.de ([5.9.56.57]:58340 "EHLO meine-oma.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbaLCLZE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 3 Dec 2014 06:25:04 -0500
Received: from [151.252.43.186] (helo=Messages-MacBook-Pro-2.local)
	by meine-oma.de with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.84)
	(envelope-from <himbeere@meine-oma.de>)
	id 1Xw83K-0002iU-Vl
	for linux-bcache@vger.kernel.org; Wed, 03 Dec 2014 12:25:03 +0100
In-Reply-To: <547ED8A1.5050706@message-id.googlemail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Am 03.12.14 10:32, schrieb Stefan Seyfried:

> It's not two weeks yet, but getting close.
> 
> Load average never goes below 1 (with 3 bcache-backed mounts).

Ah. I see. So the load bug is still there. Thanks for the info.

best regards
t.
