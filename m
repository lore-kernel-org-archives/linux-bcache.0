From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: Fwd: Bcache Status
Date: Mon, 12 Oct 2015 19:51:18 +0300
Message-ID: <CACaajQstmczA8_R+brQF2Jd4=LCTVi+ogWwPk4JZtshpf2-52A@mail.gmail.com>
References: <CAEC_uJOv7gmb3ddTa0yNHDXHPbX_0Mr2uZsDGM2iNMSrPKex4A@mail.gmail.com>
 <CAEC_uJM_CZbxdMyPct0=Mc4CMzY5u4HYhzQA48dtG7kqfSi_Pg@mail.gmail.com> <561BE17C.5020402@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34302 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbJLQve (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 12 Oct 2015 12:51:34 -0400
Received: by lbbck17 with SMTP id ck17so28858614lbb.1
        for <linux-bcache@vger.kernel.org>; Mon, 12 Oct 2015 09:51:33 -0700 (PDT)
In-Reply-To: <561BE17C.5020402@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Andrew Thrift <andrew@networklabs.co.nz>, linux-bcache@vger.kernel.org, Greg KH <greg@kroah.com>, Jens Axboe <axboe@kernel.dk>

2015-10-12 19:36 GMT+03:00 Peter Kieser <peter@kieser.ca>:
> Backports of critical bug fixes not being done was brought to attention of
> Greg KH in September 2014, where Jens and myself mentioned that bcache
> stable patches (data corruption, stability, etc.) were not being backported
> to the Linux stable branches. The response from the author of bcache was
> "This kind of unnecessary hostility is why I don't bother with stable much
> anymore. I get enough of this bullshit at work, thank you."
>
> Unfortunately, the situation hasn't cahnged. bcache still will eat your data
> under certain use cases, and there is no warning and bcache still doesn't
> have a testing/experimental flag set on it. I guess the ultimate answer was
> "backport and submit a pull request yourself" but I'm not sure this is
> appropriate.


Sometimes ago i'm using bcache, but i'm lucky and dont loose my data=)
But now i'm prefer to check lvm cache status and wait for stabilization.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
