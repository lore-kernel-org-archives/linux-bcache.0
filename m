Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5C639DBCC
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jul 2026 07:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783324335; cv=none; b=pCk0FBP3DABlaNl9KfTt+iyOuyI97FBr4l4+bZ78t4lOqn4kxvKv/UT4ONy6tFyILaC2GzPVI4rOoIywI3NNF034K3Yw4t4SXxPy114sWS5Z9+x/3sTDBkJ+qMwXHHU0LEmQPpRvDGwm33oRyTbwowmSBD6FLgsa6PziWjr6o30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783324335; c=relaxed/simple;
	bh=zuWsV33sneA/2ZSLtf4u8pxmA4JAZSakBTHvj8I6AX8=;
	h=Cc:In-Reply-To:Message-Id:Content-Type:To:Subject:Date:From:
	 Mime-Version:References; b=UfLPSGcK/MdWZ7nM9XmbnHp5Bl/B1cVAeBpsCN72Sl6wChofS5hrTTDGZG67phYplyOxe/V9p7ckdA1LFmHjrzCMBC6SadwMN7+uB2TpLjB0l/uytOFVlSqOwGyX8aDTVbaAA/aZXA1fIBetso2Cjp46FSdOGUz7Wcwd5AXJdyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dTscSlc7; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dTscSlc7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783324318;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=67PeQALqwB0IWBj7ftRcOUy6Jnm2IHzspatHEruFHLg=;
 b=dTscSlc7DlltA5Ol0kyfBtIOfwPdi0ATlyyugtJ5B696jwuUOhA6re3Eg+gr+/qEHsaZdK
 Ct6eZnT2T/NVxYY/7PwWKcfY12UXHWRetC9xmXDTbbviVMAQCFjfCCdiZRU4DPYYASmGhS
 pkNtehcv+m+JeDTsshqxFWGoBWZEkYsF07RLicQTLaB51TuLXhSsh/uTW31yO9x9dq4GJw
 Ua6MoXjLvNisLpXM335/XMFfBgeIdof9ghgnX1qi4tt9lseTSydQSaxFLCQQLoidcdIvZR
 jawSwxGJQohey1R5bmqxtSfQ3deFU43HroNMmHfobKfM5xXdSl8zdyxCgiptKA==
Cc: <linux-bcache@vger.kernel.org>, <kent.overstreet@linux.dev>, 
	<linux-kernel@vger.kernel.org>
Received: from smtpclient.apple ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Mon, 06 Jul 2026 07:51:56 +0000
X-Lms-Return-Path: <lba+26a4b5e9d+d5420c+vger.kernel.org+colyli@fygo.io>
In-Reply-To: <aktYzuXWQ89EPM55@studio.local>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3A71FE3B-D8C4-4AFE-A809-62E1EDC0531E@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Mailer: Apple Mail (2.3864.600.51.1.1)
To: "Ankit Kapoor" <ankitkap@google.com>
Subject: Re: [PATCH v2 0/1] bcache: track active bypass writes to prevent stale cache reads
Date: Mon, 6 Jul 2026 15:51:44 +0800
From: "Coly Li" <colyli@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fygo.io>
References: <20260617103356.3287775-1-ankitkap@google.com> <20260617190152.3436375-1-ankitkap@google.com> <aktYzuXWQ89EPM55@studio.local>

> 2026=E5=B9=B47=E6=9C=886=E6=97=A5 15:39=EF=BC=8CColy Li <colyli@fygo.io> =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
>> u16 counters: I realized clamping at U16_MAX completely breaks the
>> decrement path. If an I/O burst exceeds 65,535 writes, clamping loses
>> the true count. The counter will drop to 0 prematurely while writes
>> are still in flight, leaving a window for stale reads.
>>=20
>=20
> Using u32 is good. For 100TB cache, the refcount pages may occupy around
                                                   ^^^^^^
                                                   This is a typo, should b=
e backend.
> 100MB more or less memory. IMHO that's acceptable.

Coly Li
