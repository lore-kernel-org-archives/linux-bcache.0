From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 03 Jan 2015 20:32:12 +0100
Message-ID: <54A843BC.608@profihost.ag>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:39317 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbACTbo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 3 Jan 2015 14:31:44 -0500
In-Reply-To: <54A819A0.9010501@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>

Hi Rolf,
Am 03.01.2015 um 17:32 schrieb Rolf Fokkens:
> I've been using discard for a while, but I ran a few times in serious FS
> corruptions. After disabling discard bcache was stable again.
>
> So far I tributed the corruptions to a low-cost SSD which probably
> didn't handle discard very well. But this was only an assumptions.
>
> I didn't experience specific reboot problems like you describe.

Reboot just triggers it faster and even fs crashes can occur the errors 
are just examples.

I've now disabled discards in my kernel code.

Kent may you have a look at the 3.18 kernel code regading discards?

Greets,
Stefan
