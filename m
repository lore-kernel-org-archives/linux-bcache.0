Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FA32F8E80
	for <linux-bcache@vger.kernel.org>; Sat, 13 Jun 2026 15:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781363611; cv=none; b=gJe9H2BefwEVVvtuYXSTwLg4OGPJpIhTyzfA4mwFCEkacrECPTPRzDKRNfCvut4fq2L1xCzXpMA40SVStf+QeLmHl+NVmoppUoy3zlhtxf/drRiC4m2GaHcm8eh0zH25t2jWVfq0nIuKM3vEBj4DJXO+OwO1YhZsin5HvN9MdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781363611; c=relaxed/simple;
	bh=jqyoUf0sWqcVtfTEhleA2mWENowet0ntymfg+Nj8aQg=;
	h=To:From:Message-Id:References:Cc:Mime-Version:In-Reply-To:Subject:
	 Date:Content-Type; b=m5FQJc4c2hrtgSRFbIad87qsfJBPxdF9CZcSfqDoOUFiVXLAAuMOpv+NYSihRbl6PyPkU86Z0r0x848i788rTcKokPanl/ZdYhSLwnQrm0Q5rJfz8OcwBgU0Rvfd7vIOsyuvluXTrgd0w+7Wb8vONIRnA7O/kU6LIuIV9gf0FE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=pULOiyRg; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="pULOiyRg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781363485;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jqyoUf0sWqcVtfTEhleA2mWENowet0ntymfg+Nj8aQg=;
 b=pULOiyRgs+tiZqo6M8XbGNO4i1GFIbxC2IQRZwNVoUXnqMSGfqM5xMuzxHZjjMStoj0nD9
 x+vUaLmDcIHSg/nNIuZJrBznuIFmIJrmSCF8HGEGUwWDvNFPHhVSnegb0m8urhF9lKqFYd
 ukdp7nK9iQzpEzWrZJo2nViiHouy8e977AjuXhFpbMbrhPZKEy5Jz9LFuhH4UQhggZbjG/
 b1fb3EO0FmtK2bJwetNhoX80lHCwA1h/nVMb6ZAxOYRlEMsWrpMwZz1gwMYP8LO7dhlIVu
 v4MC7irvap8/FosR0nvMZ4ww4eARpSUCgG4wjuLnkRSma0HIXz5+bOrjeIY+Jw==
To: <axboe@kernel.dk>
From: "Coly Li" <colyli@fygo.io>
Message-Id: <05943978-E925-46D1-AC7D-AC36CF6DE3E5@fygo.io>
References: <20260613150458.682707-1-colyli@fygo.io>
Cc: <linux-bcache@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fygo.io>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
In-Reply-To: <20260613150458.682707-1-colyli@fygo.io>
Subject: Re: [PATCH Resend] MAINTAINERS: Update Coly Li's email address
Date: Sat, 13 Jun 2026 23:11:11 +0800
X-Lms-Return-Path: <lba+26a2d731c+5500f6+vger.kernel.org+colyli@fygo.io>
Received: from smtpclient.apple ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Sat, 13 Jun 2026 15:11:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi Jens,

I assume this patch goes into the spam box again (due to the DKIM issue). I=
 use my personal email address to gently notice you.
Could you please take this patch to update my current employer email addres=
s.

Thanks in advance.

Coly Li

> 2026=E5=B9=B46=E6=9C=8813=E6=97=A5 23:04=EF=BC=8Ccolyli@fygo.io =E5=86=99=
=E9=81=93=EF=BC=9A
>=20
> From: Coly Li <colyli@fygo.io>
>=20
> I switch to colyli@fygo.io as my current email address.
>=20
> Signed-off-by: Coly Li <colyli@fygo.io>
> ---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8856f10a72bd..d2aaa7dacf90 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4446,11 +4446,11 @@ F: Documentation/networking/batman-adv.rst
> F: include/uapi/linux/batadv_packet.h
> F: include/uapi/linux/batman_adv.h
> F: net/batman-adv/
>=20
> BCACHE (BLOCK LAYER CACHE)
> -M: Coly Li <colyli@fnnas.com>
> +M: Coly Li <colyli@fygo.io>
> M: Kent Overstreet <kent.overstreet@linux.dev>
> L: linux-bcache@vger.kernel.org
> S: Maintained
> W: http://bcache.evilpiepirate.org
> C: irc://irc.oftc.net/bcache
> --=20
> 2.47.3
>=20
>
