From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: stable bcache-tools?
Date: Sat, 23 Nov 2013 17:05:37 -0800
Message-ID: <20131124010537.GF20624@moria.home.lan>
References: <002001cee7f2$0868a260$1939e720$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57199 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3KXBEf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 23 Nov 2013 20:04:35 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so3222443pde.20
        for <linux-bcache@vger.kernel.org>; Sat, 23 Nov 2013 17:04:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <002001cee7f2$0868a260$1939e720$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org

On Fri, Nov 22, 2013 at 06:16:23PM -0800, Paul B. Henson wrote:
> Is there going to be a release cut of bcache-tools at some point so
> distributions could have a stable version to package? Is the current git
> head pretty much considered production ready and bug free?

The current git head should be completely fine for production usage -
there's not really anything complicated enough (save the udev stuff,
maybe) to merit tagging a specific version as stable. I suppose
distributions could use some kind of hint that useful changes have gone
in and they should package a new version - anything in particular you
want there?
