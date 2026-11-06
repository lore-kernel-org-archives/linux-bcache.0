Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793935603;
	b=hYdCeta4+8ZqapB60PX5JZruRndwnGRCC4iIBSmnVS92+glzmFMEK/Sl0iglAi8g1qOE
	 qCS7UIujQNaVWtlISVv2rBYbNYBoyxJEFS8Q1ezFt9zI1nnOBsOAdwHdX4q07GEOIrXai
	 nTbAf2ccnGu0sNlCWgmpBD9yR+hdU0Ra/v0PW/rwVt7g3G8bn+QvGqoe54B5jHUC5rKyl
	 KiEmcOxEUvPNRAu+yXX5DN6Qvrvy90LVJX58He42Gt033HwvTmiG174agDyoZo2nRoL3y
	 Z62r5Uasp1kN+p+6VlWMX1kXqTLAzKM+HTGTu0ARp7FR02KR6E+i1FwssLZ5L6F+exA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793935603;
	h=DMARC-Filter:DKIM-Signature:User-Agent:Content-Type:Reply-To:Cc:Date:
	 Subject:Mime-Version:Content-Transfer-Encoding:In-Reply-To:
	 X-Lms-Return-Path:Received:To:From:Message-Id:References:
	 X-Original-From;
	bh=GicqH+O3H0yQelB/uFYofYeCG5YOTIFkaNOJy/Z44EM=;
	b=XpfuICcl5Hg4DLShSPomvDr5trMLXD5b4k95wul+iic3Wcw3Bqs6GlTZmHBJJWQKKTil
	 rg1JWE1jjMWT4CjMwYydeog504ysbMmErq2DwhIq5Su3usbO2UK6cLVWRz+EZgWk1DxCi
	 RuDqhNUxaOgtUWC3bak017sZTx5l3wAKGnAOQVLW3w9zcCoTVEGX89sJeV68gBP2Lb928
	 bi3FEtybhfVcpxtiqkKduvP+fB1Gom7DvoyGMC+8pqFG1+ZDkHm3ZWt1FSAT2+W3SWpjc
	 VBXDClfziUNNDMQ6E1CXkS8nUbsrtPMoZe3SUYEc6e/g4t8rrJf08Mfff9g776O/6qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Lww5u+Kk;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FD4606A32C
	for <linux-bcache@vger.kernel.org>; Fri,  6 Nov 2026 03:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5FD4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Lww5u+Kk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793935590;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GicqH+O3H0yQelB/uFYofYeCG5YOTIFkaNOJy/Z44EM=;
 b=Lww5u+KknIvOlBE7zUBEE9vMd4FsH0NAxwfvYYEm6v8gt1Nbf5G1yV/ElsyVkKlZ6u8x+f
 jZdQFZEHssGIg9E9pRIBC0l/EMqfjtxwSVHfC6Ny9gzwXy1J+6rLt8VhXwT8BgzstuZyiQ
 /ayu6Lgjfxq7uepXap0rJzd67lAgu8lnuvw6gg5gVB5n+Ji+kVo+CTX5i7FOouiwH0bvss
 1lRkBk7MqLxP0QWcr5TrOqJK8E6XSJGBn/x+mk6u98xFIhNL+MfpCvWLtpSTXfTiNvqgrV
 gslbthYDVijhXjSp2YQfVl+rx/a4PbUl5f9EGF6pLTCaOXddQ0tPdPUD7OWO7w==
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: <linux-bcache@vger.kernel.org>, <regressions@lists.linux.dev>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, 
	<song@kernel.org>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<colyli@fygo.io>, <kent.overstreet@linux.dev>
Date: Fri, 6 Nov 2026 11:26:23 +0800
Subject: Re: [PATCH] md/raid5: complete unsupported discards successfully
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <179299857972.12222.2729359466842183358@gmail.com>
X-Lms-Return-Path: <lba+26aed48e5+b08a0b+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 03:26:28 +0000
To: "Konstantin Nikiforov" <helllamer@gmail.com>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <770fdf93-4330-4094-9807-a0cb449ecb73@fygo.io>
References: <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com> <179299857972.12222.2729359466842183358@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>

=E5=9C=A8 2026/10/26 14:21, Konstantin Nikiforov =E5=86=99=E9=81=93:

> Since commit 90573092673c ("md/raid5: validate discard support at
> request time") raid5 advertises max_hw_discard_sectors =3D UINT_MAX no
> matter whether the member devices support discard or
> devices_handle_discard_safely is set, and make_discard_request() fails
> the discards it cannot handle with BLK_STS_NOTSUPP.
>
> Before that commit such arrays did not advertise discard at all, so
> upper layers never sent one. Now they do, and the failure is not
> harmless:
>
>   - bcache forwards discards to its backing device whenever
>     bdev_max_discard_sectors() is non-zero, and backing_request_endio()
>     treats every non-zero bi_status as a media error. After io_error_limi=
t
>     (64) of them bch_cached_dev_error() stops the cached device. On a
>     machine with root on LVM over bcache over a raid5 of three HDDs the
>     root filesystem disappeared a few minutes after every boot.
>
>   - btrfs enables discard=3Dasync by default on any device that advertise=
s
>     discard, which is what generated the discards in the first place.
>
> Discard is advisory: blkdev_issue_discard() already turns -EOPNOTSUPP
> into success for its callers, and md_submit_discard_bio() silently skips
> raid0/raid10 members without discard support. Do the same here and
> complete the bio successfully when the array cannot pass it down safely,
> so that callers submitting their own discard bios, like bcache, see the
> same behaviour.
>
> Fixes: 90573092673c ("md/raid5: validate discard support at request time"=
)
> Cc:stable@vger.kernel.org # 7.2
> Closes:https://lore.kernel.org/all/CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdq=
PDXKL8r8-kR9Q@mail.gmail.com/
> Signed-off-by: Konstantin Nikiforov<helllamer@gmail.com>
> ---
> Kuai, this is the raid5-side change you were fine with in the report
> thread. Reproducer: raid5 over three loop devices with a bcache backing
> device on top, four blkdiscard calls on the bcache device. On 7.2.11
> without the patch bcache's io_errors goes to 4 (bch_count_backing_io_erro=
rs
> in dmesg); with the patch applied to 7.2.11 it stays at 0, and the
> affected machine (root on LVM over bcache over raid5 of HDDs) boots and
> runs with the patched module without any backing-device errors.
> blkdiscard on the md device itself reports success either way because
> blkdev_issue_discard() masks EOPNOTSUPP.
>
> One correction to my report: the "discard_granularity is 0" observation
> was a side effect of my own workaround (writing 0 to discard_max_bytes
> makes the block layer report granularity 0); on a fresh array the
> granularity is the stripe size as expected.
>
>   drivers/md/raid5.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
Applied

--=20
Thanks,
Kuai
