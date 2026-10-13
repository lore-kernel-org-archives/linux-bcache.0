Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D493164D6
	for <linux-bcache@vger.kernel.org>; Tue, 13 Oct 2026 07:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876158; cv=none; b=j/wpkwkf3GYnTwiPPi+va7w79jHgitowIknAQItvBZ519w7Vl9TqULCzLCVwQB2N6C93U5kccsD0RGpd14mR2704CNuOiCZJR6Xur2+VR10aGQtx7NCKnWch6CR65979vu/yFCcwAnfSFobUIon4zeIzEUI9PkkCfPb7l6/o83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876158; c=relaxed/simple;
	bh=nVAJEoSS8PlphChubRScNChoZm621k/YJR9H6u5dHSM=;
	h=From:References:Date:Message-Id:In-Reply-To:Content-Type:To:Cc:
	 Subject:Mime-Version; b=VoEzvqYPdfN+/TF+HfT7IUIm0NqPSlAP74VuXLepMWAVbTkMkSjWSroolfFrOYayCOnHT+oHFgHFXIMIj54vBFCJtt7MoV9IqFo5mVP4n36TufF1qtNduQ059Dq84CJeG7CGtD4mrweGaL53CT9YfEcVofsOLTjb7rQUlGkiQFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NpsSrSub; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NpsSrSub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791876141;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nVAJEoSS8PlphChubRScNChoZm621k/YJR9H6u5dHSM=;
 b=NpsSrSubeYHzNSsCiEsa+nn1bIpaTTk5Zp3m2ukeNHJTzNbomHS1yGkwgwEcHQQ7h3ptCu
 8FWlmlmR0Ah4wSjvU8abTMUsiqHY/4B95uz3P+2QypOHwewWOCK3eiNn777YpViF8pOoIC
 cFXZX3F3mqMMQKuXBkKRrssZQJZ1ZY9g3Ml/VGUZhEXN4FBOQNtWgZg3FqQIGlI7K7y4gt
 7cvDj3wfxgvMQnVk/pPISfpdVJhQsleFspZL/0+e2WAs9VYAqp/eoNu2BYUVZbRqzu4MA+
 M2j7ZAqW0CUyApuK0pxTFRsNlPdfulAxkwA0lrExs8TRDNO9R+fx2Cg4b9X/YA==
From: "Coly Li" <colyli@fygo.io>
References: <20261013-bcache-super-v1-1-7bf7e6930eac@gmail.com>
X-Original-From: Coly Li <colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 15:22:07 +0800
Message-Id: <9A9C7397-F7A3-4E56-A94A-71FF1EE18265@fygo.io>
In-Reply-To: <20261013-bcache-super-v1-1-7bf7e6930eac@gmail.com>
X-Lms-Return-Path: <lba+26acddc2c+c46e7c+vger.kernel.org+colyli@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from smtpclient.apple ([120.245.64.82]) by smtp.larksuite.com with ESMTPS; Tue, 13 Oct 2026 07:22:19 +0000
To: "Subasri S" <subasris1210@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Kent Overstreet" <koverstreet@google.com>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com>
Subject: Re: [PATCH RESEND] bcache: validate sb->keys before computing checksum
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi Subasri,

> 2026=E5=B9=B410=E6=9C=8813=E6=97=A5 10:09=EF=BC=8CSubasri S <subasris1210=
@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> csum_set() checksums the superblock from just past the csum field up to
> &s->d[s->keys], so the length it hands to bch_crc64() comes straight off
> disk. d[] only has SB_JOURNAL_BUCKETS (256) entries, but keys is __le16
> and can be up to 65535, so a bogus value makes the crc walk far past the
> end of the 4k superblock buffer.

How can a bogus sb->keys value walk through the checksum?

>=20
> syzbot hit this with a superblock that has a valid offset and
> magic and garbage everywhere else:
>=20
> BUG: KASAN: use-after-free in crc64_be_generic lib/crc/crc64-main.c:47 [i=
nline]
> BUG: KASAN: use-after-free in crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
> Read of size 1 at addr ffff0000dd543000 by task syz.0.33/4986
> Call trace:
> kasan_report+0x8c/0xc4 mm/kasan/report.c:595
> __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
> crc64_be_generic lib/crc/crc64-main.c:47 [inline]
> crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
> bch_crc64 drivers/md/bcache/util.h:529 [inline]
> read_super drivers/md/bcache/super.c:208 [inline]
>=20

I doubt whether the above warning is valid, where the use-after-free condit=
ion?


> Add a bound check on sb->keys before calculating checksum.
>=20
> Reported-by: syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcb5b32abe226710cdd8a
> Tested-by: syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Subasri S <subasris1210@gmail.com>
> ---
> drivers/md/bcache/super.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 97d9adb0bf96b..71929576ab89e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -204,6 +204,10 @@ static const char *read_super(struct cache_sb *sb, s=
truct block_device *bdev,
> if (memcmp(sb->magic, bcache_magic, 16))
> goto err;
>=20
> + err =3D "Too many journal buckets";
> + if (sb->keys > SB_JOURNAL_BUCKETS)
> + goto err;
> +
> err =3D "Bad checksum";
> if (s->csum !=3D csum_set(s))
> goto err;
>=20


Other bogus field can also goes through a on-purpose built checksum.

Thanks.

Coly Li


> ---
> base-commit: 15ef2f78c49d20d53ec7c0f1c9b40b02e089f2d6
> change-id: 20260815-bcache-super-5e48eebfc4ad
>=20
> Best regards,
> --=20
> Subasri S <subasris1210@gmail.com>
>
