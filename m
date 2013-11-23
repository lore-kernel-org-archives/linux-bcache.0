From: "Paul B. Henson" <henson@acm.org>
Subject: RE: Another bcache hang
Date: Fri, 22 Nov 2013 18:14:25 -0800
Message-ID: <001f01cee7f1$bd65e7f0$3831b7d0$@acm.org>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org> <528FBFCE.7020104@warr.net> <001b01cee7dd$e82f5d90$b88e18b0$@acm.org> <528FFEB0.1050704@warr.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35603 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3KWCOa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 21:14:30 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so2025107pdj.39
        for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 18:14:30 -0800 (PST)
In-Reply-To: <528FFEB0.1050704@warr.net>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: 'Jason Warr' <jason@warr.net>
Cc: linux-bcache@vger.kernel.org

> From: Jason Warr
> Sent: Friday, November 22, 2013 5:03 PM
>
> Actually that is probably veering back on topic :)

Well, for the list maybe, but not for the thread, which has still not seen
any debugging/troubleshooting recommendations for the bcache hang originally
reported.

> At the moment I am using Fedora 20 Beta's version of 3.11.8.  I don't
> yet have enough time with it to say how useful/stable it is.  I try to
> stick with something that has a better chance of making it into an
> enterprise distro as that is my main focus.

I generally run Gentoo unless there is a proprietary commercial application
involved, in which case we use RHEL. I can't see this being backported to
RHEL6, but possibly it might show up in RHEL7. I guess there's no firm
release date on that yet, but scuttlebutt has it that they will be using
kernel 3.11 (although I don't think that's intended to be an upstream LTS
kernel), which matches the current development fedora version...
