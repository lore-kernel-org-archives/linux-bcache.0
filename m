Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7457A493622
	for <linux-bcache@vger.kernel.org>; Fri,  4 Sep 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788531640; cv=none; b=eRIwJDSbzyrdeEgZgpI7NBtLv7VcwG67qFMn9Ou9z0Omxd8cApnoEMOEMLAH0hnDh94g47VS/Hfs8b4jmA4U37rqxXBasg6wcibana2wzDMVbd7+lUfOQCjoI4bmjbL2bR8oUceRJCfNmWrZOdyNviW6XGJir7A8g5i6SoJ8yP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788531640; c=relaxed/simple;
	bh=XMOxL1c0A94oZSLcygUZbFVd7X6Zt3RyopugXAxLBoE=;
	h=References:In-Reply-To:To:Cc:Subject:Mime-Version:Content-Type:
	 From:Date:Message-Id; b=L+tsgP1ioepPHR5ZON4rHUmMGYDB9uqNmS2K1El+YMVENeGyxZoSuGn80IudTLQp6uh8SbQpFblwHFF/v41tvyUquuXhn1ZajtOe58Qhxzm1GCnlDoGsvKD4HW4M8x0abr2t42NeAW+TAJLaQQzt7nMT55XmusYQyYSn2SDyTbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Egvxi66X; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Egvxi66X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788531634;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=baCydwiONp911QmibUtX1HsIKgihZFpyLW4M1bykxT8=;
 b=Egvxi66XxNMA6b/1wMf1vQbLUcIryoWnMZrssD1N2WCi7BPKbFsNQ3yi3ybllNuiZ6Q0Iq
 qEwI95gkUP/7lQG/JajHpLR2941nxQIpFc0ZWyac91VDo/h3zlvg4um6nXmZX3Ho5TbAEM
 EInJ97M+rxKQknv8MNWBd3eZCWLVk/CRphE4kruSB8wlOZ3af7ZLkwnV8RfyZkw7MEoILG
 5TIThIaFTq6dZKVNeP3xXdzX1MdkQ9eLu+oJexLaBnQwtP/thxlqqcWLJgYPcbHukI0uuv
 3A9TtPLlR27EiPbRi0hidXxJVLQLaZzRseOZLUoWbnNBZQxVSM2C0WNCCio29g==
References: <20260904123730.39849-1-hemanth.selam@gmail.com>
In-Reply-To: <20260904123730.39849-1-hemanth.selam@gmail.com>
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-kernel@vger.kernel.org>, <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] md: bcache: fix typo "idel" in comment
Received: from smtpclient.apple ([120.245.64.136]) by smtp.larksuite.com with ESMTPS; Fri, 04 Sep 2026 14:20:32 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a9ad3b1+d6fc04+vger.kernel.org+colyli@fygo.io>
From: "Coly Li" <colyli@fygo.io>
Date: Fri, 4 Sep 2026 22:20:20 +0800
X-Original-From: Coly Li <colyli@fygo.io>
Message-Id: <C3B46A2F-C85E-4CB6-8093-D1E184FF1DC9@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Mailer: Apple Mail (2.3864.700.51.1.1)

> 2026=E5=B9=B49=E6=9C=884=E6=97=A5 20:37=EF=BC=8CHemanth Selam <hemanth.se=
lam@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Correct "idel" to "idle", reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>=20
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>


Take it into my for-next.

Thanks.

Coly Li

> ---
> drivers/md/bcache/writeback.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.=
c
> index 4b237074f453..7734fe0dd429 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -162,7 +162,7 @@ static bool idle_counter_exceeded(struct cache_set *c=
)
> int counter, dev_nr;
>=20
> /*
> - * If c->idle_counter is overflow (idel for really long time),
> + * If c->idle_counter is overflow (idle for really long time),
> * reset as 0 and not set maximum rate this time for code
> * simplicity.
> */
> --=20
> 2.48.1
>
