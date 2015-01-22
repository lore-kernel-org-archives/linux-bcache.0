From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: patch (Re: 3.18.3 + latest bcache-dev)
Date: Thu, 22 Jan 2015 13:56:25 +0100
Message-ID: <20150122125625.GB23810@cuci.nl>
References: <20150121012424.GB5533@cuci.nl>
 <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
 <20150121110400.GA14729@cuci.nl>
 <20150121164553.GA15237@cuci.nl>
 <20150122123332.GA23810@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:42013 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbAVM40 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 22 Jan 2015 07:56:26 -0500
Content-Disposition: inline
In-Reply-To: <20150122123332.GA23810@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Stephen R. van den Berg wrote:
>d. Came back in a patched kernel, 100% CPU usage is gone.

I spoke too soon.  After some more copying, the 100% CPU is back, but
different:
Before I had four or five HDDs, but in both cases I had four bcache_writebac
processes running at 100%.
Now I have four HDDs, and also four bcache_writebac processes, but
only three of those run at 100% CPU.  The fourth one is idle (mostly).
-- 
Stephen.
