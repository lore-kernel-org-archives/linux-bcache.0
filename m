From: Simon Herter <sim.herter@gmail.com>
Subject: Re: Btrfs on bcache device: mount options?
Date: Thu, 15 Oct 2015 23:27:32 +0200
Message-ID: <871tcvhlff.fsf@gmail.com>
References: <87mvvk4718.fsf@gmx.de> <20151015142945.GA10162@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58661 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbJOV1a (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 Oct 2015 17:27:30 -0400
In-reply-to: <20151015142945.GA10162@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org


Vojtech Pavlik writes:

> On Thu, Oct 15, 2015 at 03:04:35PM +0200, Simon Herter wrote:
>
>> I'm using btrfs on a bcache device and I'm a bit confused about mount
>> options. For example, bcache may (if I understood correctly) bypass the
>> cache completely for sequential access. So should I use "ssd" mount
>> option or not? Are there any general recommendations?
>
> No, you should not. It modifies the data layout behavior to ignore seek
> times. These may be present when reading from the backing media.

Sounds reasonable. A short note on that: _not_ specifying 'ssd' is not
enough, one has to specify 'nossd' explicitly. Btrfs enables 'ssd'
automatically by checking /sys/block/bcache0/queue/rotational to be
zero - which is true. (Though I'm not sure whether bcache got that right.
One could argue that returning the backing device's rotational value
would be better, especially to get the defaults right for btrfs.)

> You likely want to enable compression and autodefragmentation, too.

When I read 'autodefrag' I was worried about my ssd at first, but I found
some discussion about that on the btrfs mailing list, so that seems to
be fine. Thanks for the suggestions.

-Simon
