From: Hans van den Bogert <hansbogert@gmail.com>
Subject: Re: Testing 4.14 rc8 kernel with bcache - cache device numbering
Date: Tue, 7 Nov 2017 12:00:55 +0100
Message-ID: <6DFC5618-56E8-4B5C-9887-FA210C8EAC4B@gmail.com>
References: <CAPerZE8dmu60sksC+hkk4E+GOht1F5nExPTvv4WRS=kRGO+GZA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:47921 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbdKGLA6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Nov 2017 06:00:58 -0500
Received: by mail-wm0-f43.google.com with SMTP id r196so2832291wmf.2
        for <linux-bcache@vger.kernel.org>; Tue, 07 Nov 2017 03:00:57 -0800 (PST)
In-Reply-To: <CAPerZE8dmu60sksC+hkk4E+GOht1F5nExPTvv4WRS=kRGO+GZA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Campbell Steven <casteven@gmail.com>
Cc: linux-bcache@vger.kernel.org

I thought this was fixed, but apparently  only on Ubuntu. See [1]; the =
state is still =E2=80=9CNEW"

Regards,

Hans

[1] https://patchwork.kernel.org/patch/9600121/

> On Nov 7, 2017, at 3:37 AM, Campbell Steven <casteven@gmail.com> =
wrote:
>=20
> Hi,
>=20
> I've been doing some testing so that we can move from a 4.7 kernel up
> to 4.14 at some point in the future.
>=20
> One thing I've noticed is that the numbering of the bcache devices is
> quite different, is there a reason it's going 0,16,32 etc.?
>=20
> [Tue Nov  7 13:41:54 2017] bcache: bch_cached_dev_attach() Caching
> sdb1 as bcache0 on set 030a5f1b-b314-482f-ba91-be1d712a4a33
> [Tue Nov  7 14:32:45 2017] bcache: bch_cached_dev_attach() Caching
> sda1 as bcache16 on set 07cd8359-1427-4446-9688-d67ceb4f4b4c
> [Tue Nov  7 14:36:36 2017] bcache: bch_cached_dev_attach() Caching
> sdc1 as bcache32 on set 030a5f1b-b314-482f-ba91-be1d712a4a33
>=20
> Thanks
>=20
> Campbell
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
