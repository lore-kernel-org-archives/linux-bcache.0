From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Sun, 04 Jan 2015 15:11:40 +0100
Message-ID: <54A94A1C.9050906@rolffokkens.nl>
References: <20141228023534.GA25860@cuci.nl> <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com> <54A81B78.2070409@rolffokkens.nl> <20150104004621.GA4460@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39915 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbADOLn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 4 Jan 2015 09:11:43 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so1824504wiv.5
        for <linux-bcache@vger.kernel.org>; Sun, 04 Jan 2015 06:11:42 -0800 (PST)
In-Reply-To: <20150104004621.GA4460@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

Please let us know when this will be pushed to the kernel, do you have 
any thoughts on the planning of this?

As a bcache-tools packager for Fedora I think I should add some package 
dependencies which prevent users from accidentally upgrading to that 
(breaking) version in the future.

It may also affect other tools like util-linux: 
https://github.com/karelzak/util-linux/blob/master/libblkid/src/superblocks/bcache.c

Furthermore I think I should postpone integration of bcache in the 
Fedora installer until further notice: 
https://bugzilla.redhat.com/show_bug.cgi?id=1003208

Any information in advance is appreciated.

Rolf

On 01/04/2015 01:46 AM, Kent Overstreet wrote:
> Yes, correct. The on disk format changes in bcache-dev are just too 
> deep to feasibly write backwards compat code, unfortunately. And the 
> on disk format is still in flux - for just a bit longer hopefully 
> though, right now I'm working on a pretty major revamp that's getting 
> close to done (self describing and packed metadata). This revamp is 
> making the on disk format _much_ more flexible though, and cleaning up 
> a lot of stuff at the same time. 
