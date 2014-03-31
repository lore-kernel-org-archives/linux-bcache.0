From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 15:04:09 +0200
Message-ID: <CAHnuAexotRh_Se+zPtwcMEy=wJKMwnuRgOxW5FQqZni64Bxg8Q@mail.gmail.com>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331120623.GA28637@sucs.org> <CAHnuAeyRFa=9xxEDM-f798iYwjUWweUBYVqfUpVGJZgmY3sMFg@mail.gmail.com>
 <CAHnuAewV9d31DEcJ+NB_biX4GGTpiWkpBm2Xc0BNHEjd_VmMsA@mail.gmail.com>
 <20140331123757.GA9561@sucs.org> <CAHnuAey7Ox+2kFqEb5kXQxKUvr6j5WybFrx=1wma5UTxD49UMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55975 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaCaNEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 09:04:50 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so9074295oag.7
        for <linux-bcache@vger.kernel.org>; Mon, 31 Mar 2014 06:04:49 -0700 (PDT)
In-Reply-To: <CAHnuAey7Ox+2kFqEb5kXQxKUvr6j5WybFrx=1wma5UTxD49UMA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

Correction to the previous correction about it failing on detach, not
unregister. I think I may have been simply running the detach commands
twice in sequence without recreating the cache device and re-attaching
it in-between.

However, it seems that waiting isn't really going to help. 30 seconds
didn't help either =E2=80=94 it seems to die whenever some other proces=
s
fiddles with the detached cache device  =E2=80=94 be it the unregister
operation or my subsequent mdadm --stop (as this is a raid0 of two ssd
devices).

I'll try to work around it somehow. Thanks for your time :)
