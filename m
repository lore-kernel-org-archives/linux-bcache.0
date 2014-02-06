From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: Md stripe on top of bcache (using EC2 SSDs + EBS)
Date: Thu, 6 Feb 2014 15:28:55 +0100
Message-ID: <CAHnuAewNTwGvqLK2kj_C5v1WVjiWeQT=N1+YBZLtztJTwAMdAQ@mail.gmail.com>
References: <CAHnuAezjBnitV_wQiPF7SS-2PgrYTPxw4CG+kTox-a8J-uG8mg@mail.gmail.com>
 <1391695680.94835.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41027 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaBFO3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Feb 2014 09:29:36 -0500
Received: by mail-ob0-f182.google.com with SMTP id wm4so2267947obc.41
        for <linux-bcache@vger.kernel.org>; Thu, 06 Feb 2014 06:29:35 -0800 (PST)
In-Reply-To: <1391695680.94835.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: matthew patton <pattonme@yahoo.com>, linux-bcache@vger.kernel.org

Hi Matthew, and thanks for responding :)

On Thu, Feb 6, 2014 at 3:08 PM, matthew patton <pattonme@yahoo.com> wrote:
> EBS is dog-ass SLOW! so unless your data happens to be in the locally attached SSD you won't see a benefit. Plus as you are using ephemeral SSD you have to use write-thru to have a prayer of having your data survive so once more you won't see a performance increase on writes.
>

Well, about the slowness, that's why I'd want to use bcache on top of
it :) With 32GB of SSD, I imagine the hot set of data (cassandra db)
would easily fit for the very foreseeable future. Plus, switching from
standard EBS to IO prioritized would be very easy.

Since it's cassandra, I'm not concerned about the survival of any one
node, and so writeback mode would be perfectly fine for my needs.

> What exactly are you MDRAID'ing across? Your chunk size should be AT LEAST 64K and I would suggest 256K as a better value.
>

Since I have two SSDs, and bcache supports only one cache device for a
bcache device, I'm looking at joining two bcache devices with md in
stripe mode, hence my questions about chunk size in this setup. That
is,

EBS 1 as backing device 1 + SSD 1 as cache device 1 = bcache0
EBS 2 as backing device 2 + SSD 2 as cache device 2 = bcache1

mdadm stripe of bcache0 and bcache1 = storage device

> Don't MD raid bcache devices but rather md raid some number of EBS volumes (simple stripe is sufficient) and attach THAT to the ephemeral SSDs.
>

Okay, if that's the way to go, that's what I'll do. It'd just be
really nice if I could utilize both SSDs. Does it make sense to mdadm
the two SSDs in stripe and use the array as the cache device or would
that also negatively impact performance?

> What hardware type are you using? The SSDs should be of very good quality (Intel DC3500 or Samsung's not publicly available enterprise) at least that's the setup we were using for S3 nodes. EC2 should be using the same hardware configuration.

I'm currently testing on a c3.large. Not sure what hardware is behind that.

Thank you for your time :)

Daniel
