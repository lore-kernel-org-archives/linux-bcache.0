Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36639F162
	for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 10:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693063; cv=none; b=tmgOF5gRbxcPV6eoV7nJQfvzUfqv1fK0TiX5i6g61fjemfMWPp4p4CdqTB0QVM7jxZqV+pAplUZsC7BcOFJ2pfDE4jMMh1flpJZewxcD45zvZiX2zFyn/vpZIYP7EdfSkT1S5KUzHMHMuhr6d8clk/9QRUCCEbUkAovThnzS5sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693063; c=relaxed/simple;
	bh=vVP+dT2ebeQR3Vq5SjrpH/10DN5R2Z+EVP12UaI/Myg=;
	h=Mime-Version:Cc:Date:In-Reply-To:Content-Type:Subject:From:
	 Message-Id:References:To; b=UUbjXZU18CJWhB7PIX70/xN6cjkTcXqP/zZ+sjSQJGMxWrPjqQdeO8k0gLbvefknt17gKUoCAvEfvreor84fUFrqSSxvkLCx3SL6hzRmP3UXATB4jhXZwvVwXDS7bqdcAT+paC7Ac3jfw09yJ39g4V+ULBGI/2W0iT8v3rGJzoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bMIju67A; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bMIju67A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781692920;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vVP+dT2ebeQR3Vq5SjrpH/10DN5R2Z+EVP12UaI/Myg=;
 b=bMIju67AGEr1CWJVwMYU25KupTrMp6icq86hxcAzlvesT8Ylp4nLPuyX8tvXOSZQiVgsEL
 GJb3tAeKdkjg5Wfm4zK0Cy4GA9+QMzDBfY89LvkrRYz7nZSF9iG5UJ2OLIZbSB+56eRAk7
 /cbVc0Rm8FUyGGloFZIR2ky2hCm9UUH0kJ8qG/Xanf48qqmpqD7JCbL8k+D969GcWCyFAd
 GpsVsdtf+Qa3RG4iGev/agcyII1GIE7bdwQjvxA0XaHTPX8nVX+a5m16E/v5j00LTKKrd4
 BDnJU+kdEaouX2uFP0GJi4OEiqkpKwGb0ROvbf5Z9Is8KO+x4mqng+vkcBOU+g==
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Original-From: Coly Li <colyli@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-bcache@vger.kernel.org>, <kent.overstreet@linux.dev>, 
	<linux-kernel@vger.kernel.org>
Date: Wed, 17 Jun 2026 18:41:46 +0800
In-Reply-To: <20260617103356.3287775-1-ankitkap@google.com>
Received: from smtpclient.apple ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Wed, 17 Jun 2026 10:41:59 +0000
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v2 0/1] bcache: track active bypass writes to prevent stale cache reads
From: "Coly Li" <colyli@fygo.io>
Message-Id: <0EAD64DB-8C6C-4502-9C99-9F0D45878EC4@fygo.io>
X-Lms-Return-Path: <lba+26a3279f7+dd71be+vger.kernel.org+colyli@fygo.io>
References: <20260617103356.3287775-1-ankitkap@google.com>
Content-Transfer-Encoding: quoted-printable
To: "Ankit Kapoor" <ankitkap@google.com>

> 2026=E5=B9=B46=E6=9C=8817=E6=97=A5 18:33=EF=BC=8CAnkit Kapoor <ankitkap@g=
oogle.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> This is v2 of the patch to fix a race condition between read cache
> misses and bypass writes.=20
>=20
> Changes in v2:
> Instead of deferring key invalidation, we now explicitly track active
> bypass writes using dynamically allocated pages (modeled closely after
> md-bitmap.c as suggested by Coly). We use this tracking information
> during cache miss reads to determine if the read must also bypass the
> cache.
>=20
> The active bypass writes are tracked by dividing the backing device
> space into 32MB chunks and maintaining concurrent write refcounts. The
> memory overhead is minimal; a single 4KB page covers 64 GB of backing
> device space in the chosen approach.
>=20
> Implementation Approaches Evaluated:
> When designing this, we evaluated three synchronization approaches:
> 1. Global Spinlock
> 2. Page-level Spinlock (Chosen Approach)
> 3. Atomic Counters (Lockless)

Thanks, patch received. I will response you after reviewed them.

Coly Li
