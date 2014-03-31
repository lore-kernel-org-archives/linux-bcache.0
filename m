From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 14:42:17 +0200
Message-ID: <CAHnuAey7Ox+2kFqEb5kXQxKUvr6j5WybFrx=1wma5UTxD49UMA@mail.gmail.com>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331120623.GA28637@sucs.org> <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
 <CAHnuAewV9d31DEcJ+NB_biX4GGTpiWkpBm2Xc0BNHEjd_VmMsA@mail.gmail.com> <20140331123757.GA9561@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35199 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaCaMm6 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 08:42:58 -0400
Received: by mail-ob0-f180.google.com with SMTP id wn1so8797589obc.25
        for <linux-bcache@vger.kernel.org>; Mon, 31 Mar 2014 05:42:57 -0700 (PDT)
In-Reply-To: <20140331123757.GA9561@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 31, 2014 at 2:37 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Mon, Mar 31, 2014 at 02:30:06PM +0200, Daniel Smedegaard Buus wrote:
>> Is the sequence incorrect? I.e. detach, then unregister? I actually
>> had it the other way around at first, but my debugging led me to try
>> to switch them.
>
> To the best of my knowledge you're not doing anything wrong - it's been
> flaky for me too. Offhand I think I could detach the front device, wait,
> then stop the backing device but I have a feeling doing it over and over
> always resulted in problems (such as the one described on
> https://bugzilla.redhat.com/show_bug.cgi?id=1074492 ) until the system
> was rebooted...
>

Cool enough then, all things considered ;)

If it's just about waiting a long time and doing an extra reboot, then
that's not an issue. I just need to figure out how to make it work
consistently. This is for disaster recovery anyway, so having to wait
and reboot is no bigge ;)

Thanks!

Daniel
