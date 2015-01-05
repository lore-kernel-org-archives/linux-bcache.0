From: Slava Pestov <sp@datera.io>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Sun, 4 Jan 2015 23:47:30 -0800
Message-ID: <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
References: <20141228023534.GA25860@cuci.nl>
	<CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
	<54A81B78.2070409@rolffokkens.nl>
	<20150104004621.GA4460@kmo-pixel>
	<54A94A1C.9050906@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34751 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbAEHrb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 5 Jan 2015 02:47:31 -0500
Received: by mail-la0-f44.google.com with SMTP id gd6so18047541lab.3
        for <linux-bcache@vger.kernel.org>; Sun, 04 Jan 2015 23:47:30 -0800 (PST)
In-Reply-To: <54A94A1C.9050906@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Kent Overstreet <kmo@daterainc.com>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Sun, Jan 4, 2015 at 6:11 AM, Rolf Fokkens <rolf@rolffokkens.nl> wrote:
> Please let us know when this will be pushed to the kernel, do you have any
> thoughts on the planning of this?
>
> As a bcache-tools packager for Fedora I think I should add some package
> dependencies which prevent users from accidentally upgrading to that
> (breaking) version in the future.

The plan is to incrementally backport bug fixes and optimizations from
bcache-dev to upstream for the foreseeable future.

The development branch is going through major changes to support
dynamically adding/removing cache devices and storing data in the
btree instead of using it as a cache, enabling usage without any
backing devices. We're actively working on this code and doing a lot
of stress testing of both the new stuff and backing device support.
However, it's its too early to tell what the new features will look
like by the time they're ready to go upstream, or what a transition
plan will look like for existing installs.

I wish we had more time for upstreaming stuff, but I can assure you
its not Kent's intent to just dump bcache-dev as one huge pull request
:-)

>
> It may also affect other tools like util-linux:
> https://github.com/karelzak/util-linux/blob/master/libblkid/src/superblocks/bcache.c
>
> Furthermore I think I should postpone integration of bcache in the Fedora
> installer until further notice:
> https://bugzilla.redhat.com/show_bug.cgi?id=1003208
>
> Any information in advance is appreciated.
>
> Rolf
>
>
> On 01/04/2015 01:46 AM, Kent Overstreet wrote:
>>
>> Yes, correct. The on disk format changes in bcache-dev are just too deep
>> to feasibly write backwards compat code, unfortunately. And the on disk
>> format is still in flux - for just a bit longer hopefully though, right now
>> I'm working on a pretty major revamp that's getting close to done (self
>> describing and packed metadata). This revamp is making the on disk format
>> _much_ more flexible though, and cleaning up a lot of stuff at the same
>> time.
>
>
