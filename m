From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 14:30:06 +0200
Message-ID: <CAHnuAewV9d31DEcJ+NB_biX4GGTpiWkpBm2Xc0BNHEjd_VmMsA@mail.gmail.com>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331120623.GA28637@sucs.org> <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57198 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaMaq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 08:30:46 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so9306348oag.0
        for <linux-bcache@vger.kernel.org>; Mon, 31 Mar 2014 05:30:46 -0700 (PDT)
In-Reply-To: <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 31, 2014 at 2:13 PM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> I actually tried sleeping for five seconds, I'll try upping it and see
> what happens.

Hmmm, it's pretty flaky. At first, increasing the wait time to ten
seconds seemed to work. I then tried again, and this time I got to get
a (script-produced) message about /sys/fs/bcache/*/stop not existing,
which means it actually doesn't fail on the unregister part, but some
time after the detach part. It's not consistent, though.

Is the sequence incorrect? I.e. detach, then unregister? I actually
had it the other way around at first, but my debugging led me to try
to switch them.
