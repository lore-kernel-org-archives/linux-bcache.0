From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Tue, 6 Jan 2015 03:10:13 -0800
Message-ID: <CALJ65zm9yxpbH49Z64H3e4GPM2-e0XEmUL+J1=ac4Zph3OeJOg@mail.gmail.com>
References: <20141228023534.GA25860@cuci.nl>
	<CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
	<54A81B78.2070409@rolffokkens.nl>
	<20150104004621.GA4460@kmo-pixel>
	<20150105084919.GA11249@cuci.nl>
	<20150105110602.GA31622@kmo-pixel>
	<20150106091625.GA8154@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44375 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAFLdV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 6 Jan 2015 06:33:21 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so5125709wib.16
        for <linux-bcache@vger.kernel.org>; Tue, 06 Jan 2015 03:33:20 -0800 (PST)
In-Reply-To: <20150106091625.GA8154@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

http://evilpiepirate.org/git/bcache-tools.git

On Tue, Jan 6, 2015 at 1:16 AM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> Kent Overstreet wrote:
>>On Mon, Jan 05, 2015 at 09:49:19AM +0100, Stephen R. van den Berg wrote:
>>> Kent Overstreet wrote:
>>> >Yes, correct. The on disk format changes in bcache-dev are just too deep to
>>> >feasibly write backwards compat code, unfortunately.
>
>>> >And the on disk format is still in flux - for just a bit longer hopefully
>>> >though, right now I'm working on a pretty major revamp that's getting close to
>
>>> Any chance we could get a git url of the bcache-tools-in-flux as well?
>
>>Yeah, I just pushed the current (very much WIP) stuff to the bcache-dev branch
>>under the main bcache-tools repo
>
> Maybe I'm not looking in the right spot, but I do not see that branch.
> What is the main bcache-tools repo?
> --
> Stephen.
