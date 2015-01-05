From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Mon, 5 Jan 2015 09:49:19 +0100
Message-ID: <20150105084919.GA11249@cuci.nl>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
 <20150104004621.GA4460@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:51225 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbbAEItV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 5 Jan 2015 03:49:21 -0500
Content-Disposition: inline
In-Reply-To: <20150104004621.GA4460@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

Kent Overstreet wrote:
>Yes, correct. The on disk format changes in bcache-dev are just too deep to
>feasibly write backwards compat code, unfortunately.

>And the on disk format is still in flux - for just a bit longer hopefully
>though, right now I'm working on a pretty major revamp that's getting close to

Any chance we could get a git url of the bcache-tools-in-flux as well?
-- 
Stephen.
