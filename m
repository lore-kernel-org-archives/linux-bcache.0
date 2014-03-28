From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Missing cache prevents AWS instance from booting
Date: Fri, 28 Mar 2014 13:55:57 +0100
Message-ID: <CAHnuAex13kMyRmbuCR4EVtf5zTd8f2gFp--7oc98fsey1RyrJw@mail.gmail.com>
References: <CAHnuAezfCLEC5oxi7FxyC2qjCtEB5=Yc2ztfRb7uXrq1Hr7bdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49655 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaC1M4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 28 Mar 2014 08:56:37 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so6080978oag.12
        for <linux-bcache@vger.kernel.org>; Fri, 28 Mar 2014 05:56:37 -0700 (PDT)
In-Reply-To: <CAHnuAezfCLEC5oxi7FxyC2qjCtEB5=Yc2ztfRb7uXrq1Hr7bdQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Fri, Mar 28, 2014 at 1:25 PM, Daniel Smedegaard Buus
<danielbuus@gmail.com> wrote:
> [Stupid things]

Nevermind, once again it was my own retardation. It was, in fact, the
entry in fstab which caused the kernel to halt when /dev/bcache0 was
missing =E2=80=94 which of course it is when the cache device goes miss=
ing :)
