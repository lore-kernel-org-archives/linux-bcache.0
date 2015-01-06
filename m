From: Slava Pestov <sp@datera.io>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Tue, 6 Jan 2015 14:47:26 -0800
Message-ID: <CACHGV4J5mMzRZE_R1s0CNV32ScbzUaVHHUWxBDYxtQb+cPjh_g@mail.gmail.com>
References: <20141228023534.GA25860@cuci.nl>
	<CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
	<54A81B78.2070409@rolffokkens.nl>
	<20150104004621.GA4460@kmo-pixel>
	<54A94A1C.9050906@rolffokkens.nl>
	<CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
	<54AC5F22.6040200@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:46514 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbAFWr1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 6 Jan 2015 17:47:27 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so382570lab.13
        for <linux-bcache@vger.kernel.org>; Tue, 06 Jan 2015 14:47:26 -0800 (PST)
In-Reply-To: <54AC5F22.6040200@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Kent Overstreet <kmo@daterainc.com>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Tue, Jan 6, 2015 at 2:18 PM, Rolf Fokkens <rolf@rolffokkens.nl> wrote:
> On 01/05/2015 08:47 AM, Slava Pestov wrote:
>>
>> The plan is to incrementally backport bug fixes and optimizations from
>> bcache-dev to upstream for the foreseeable future.
>
> I assume (hope) this won't break bcache w.r.t. the current block device
> layout?

Correct.

Slava
