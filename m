From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 18:20:03 +0800
Message-ID: <CAPGwLLNTwZ1WrRVqwaLK5h8Ovj5SN5-Y-2qja843hwx2kJCAUQ@mail.gmail.com>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de> <CAPGwLLPmUiz-6xjur5jPAn1QLvkJY23QcsPCNvK+4+BVubWYnw@mail.gmail.com>
 <D393CD04-8C7A-4A8C-B23A-6C68D5544E34@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33112 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbdKQKUY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Nov 2017 05:20:24 -0500
In-Reply-To: <D393CD04-8C7A-4A8C-B23A-6C68D5544E34@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Coly Li <colyli@suse.de>, Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hi, Stefan

2017-11-17 16:28 GMT+08:00 Stefan Priebe - Profihost AG <s.priebe@profihost=
.ag>:
> I=E2=80=98m getting the same xfs error message under high load. Does this=
 patch fix
> it?
>
Did you applied the patch "bcache: only permit to recovery read error
when cache device is clean" ?
If you did, maybe this patch can fix it. And you'd better check
/sys/fs/bcache/XXX/internal/cache_read_races in your environment,
meanwhile, it should not be zero when you get that err message.
