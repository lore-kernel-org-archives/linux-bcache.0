From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 13:37:57 +0100
Message-ID: <20140331123757.GA9561@sucs.org>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331120623.GA28637@sucs.org>
 <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
 <CAHnuAewV9d31DEcJ+NB_biX4GGTpiWkpBm2Xc0BNHEjd_VmMsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37365 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaCaMh7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 08:37:59 -0400
Content-Disposition: inline
In-Reply-To: <CAHnuAewV9d31DEcJ+NB_biX4GGTpiWkpBm2Xc0BNHEjd_VmMsA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 31, 2014 at 02:30:06PM +0200, Daniel Smedegaard Buus wrote:
> On Mon, Mar 31, 2014 at 2:13 PM, Daniel Smedegaard Buus
> <danielbuus@gmail.com> wrote:
> > I actually tried sleeping for five seconds, I'll try upping it and see
> > what happens.
> 
> Hmmm, it's pretty flaky. At first, increasing the wait time to ten
> seconds seemed to work. I then tried again, and this time I got to get
> a (script-produced) message about /sys/fs/bcache/*/stop not existing,
> which means it actually doesn't fail on the unregister part, but some
> time after the detach part. It's not consistent, though.
> 
> Is the sequence incorrect? I.e. detach, then unregister? I actually
> had it the other way around at first, but my debugging led me to try
> to switch them.

To the best of my knowledge you're not doing anything wrong - it's been
flaky for me too. Offhand I think I could detach the front device, wait,
then stop the backing device but I have a feeling doing it over and over
always resulted in problems (such as the one described on
https://bugzilla.redhat.com/show_bug.cgi?id=1074492 ) until the system
was rebooted...

-- 
Sitsofe | http://sucs.org/~sits/
