From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [branch: =?utf-8?Q?bcachefs-performanc?=
 =?utf-8?B?ZV0gLi9pbmNsdWRlL3RyYWNlL3RyYWNlX2V2ZW50cy5oOjMyNzoyNzogZXJy?=
 =?utf-8?B?b3I6IGV4cGVjdGVkIGV4cHJlc3Npb24gYmVmb3JlIOKAmCnigJk=?= token
Date: Mon, 5 Dec 2016 22:49:44 -0900
Message-ID: <20161206074944.eyarkvg3zyevem74@kmo-pixel>
References: <ea208bad-525d-949d-2b01-337ec46f53ce@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35764 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbcLFHts (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2016 02:49:48 -0500
Received: by mail-pg0-f65.google.com with SMTP id p66so19071931pga.2
        for <linux-bcache@vger.kernel.org>; Mon, 05 Dec 2016 23:49:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <ea208bad-525d-949d-2b01-337ec46f53ce@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Mon, Dec 05, 2016 at 10:55:24AM +0100, marcin@mejor.pl wrote:
> Hi!
> I'm getting compilation error:
> commit 1aae41c06651f0bffedba1a29a59afac3717d315

That branch has my WIP, known broken stuff :) Can you just test bcachefs-testing
for now? I'll merge those patches into bcachefs-testing soon, but for now it's
the whiteouts optimizations currently in bcachefs-testing I'm much more
concerned about.
