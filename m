Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8118B0A
	for <linux-bcache@vger.kernel.org>; Fri, 28 Aug 2026 02:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787885755; cv=none; b=QRhDNiEktmM4gw9tqhn1LjObRt5l7JKcATzqaL1UQeuwoZYPNqy+IdEba/rYv2dU88j+Z127hd8q4D6KvByP3fQAMfeR/U6CzOByy2ty1eAjcoDZwFOsffEFJmkbuHmX5IuSywUaUaPeYmkTq9gM9xUsTseV7mZVZ2/IK0xZxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787885755; c=relaxed/simple;
	bh=LOdOV4/4iCoUIqGOZ6uNVnUNFk8HRUHngrfVlnXwl0I=;
	h=To:Mime-Version:Subject:Content-Type:In-Reply-To:From:Message-Id:
	 References:Cc:Date; b=JHpan/KIFiNAUTC71ui/i5t+jPREkeaHZfp1vEdU0IS6kgxmCxzZEW/BuNduVsIHo3g5I9Twmds4/1ufYlj6qJoR+13Ps/RTPOvf7SfrkToA2BBt9pIcwUNcsGwBgPc03FnH+tCtAF6p57mlJDBl4thSEjffEdhQ6UHHSTy58D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=MtylH+/X; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="MtylH+/X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787885748;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yY+lcghrqnx81qgnq62zTKcOxIz7PXBrFUB+Xx4sfMU=;
 b=MtylH+/Xh3qP3kKLvprTO+DSWYvJHjMwihwr9EXWDAmDKKa8aKpEiFJ6RJ7GQb8YRDqpss
 mtIBKrnJc6IINX2/mbhUiSYy8VWwRw0Pitgwozy4I9t55NAi37iKDMg3lE1bSS4KS3OWMI
 eu/dQW3wGfLZeo0qYS2yl45a577ptVw825Ztq4+5erOe++TfiwlUthaGE76pCzjEYpzygP
 ROkrUfkop02aXIUfkz9cVDReF0Xw9gzAvSh0FbkQ2+ktCu43OWO8lviP2Fg1mFePKhCgMW
 asamcZxS876wioIqenWg2mwjfMDXv9c0vskJ5QjMm/jak/P3gi8Whc8ctr5Z6g==
X-Original-From: Coly Li <colyli@fygo.io>
Received: from smtpclient.apple ([120.245.64.136]) by smtp.larksuite.com with ESMTPS; Fri, 28 Aug 2026 02:55:47 +0000
To: "Farhad Alemi" <farhad.alemi@berkeley.edu>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [BUG] bcache: BUG_ON in bch_prio_write()
Content-Type: text/plain; charset=UTF-8
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Lms-Return-Path: <lba+26a90f8b4+033c49+vger.kernel.org+colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+0ovCgU4Y17ERRdtCydW6aVUGiYDMs9Uz4TEJoMGh13oEJQvA@mail.gmail.com>
From: "Coly Li" <colyli@fygo.io>
Message-Id: <FF3CC193-5FD7-4BD5-A504-2B194F7D835C@fygo.io>
References: <CA+0ovCgU4Y17ERRdtCydW6aVUGiYDMs9Uz4TEJoMGh13oEJQvA@mail.gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, <falemi@asu.edu>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 28 Aug 2026 10:55:35 +0800

> 2026=E5=B9=B48=E6=9C=8828=E6=97=A5 07:04=EF=BC=8CFarhad Alemi <farhad.ale=
mi@berkeley.edu> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello Coly Li, Kent Overstreet,
>=20
> While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
> SEFCOM lab, we hit the crash below. Crash reports can be found here:
>=20
>  https://github.com/farhad-alemi/public_bug_reports/tree/main/115-bcache-=
bug_on-bch_prio_write/
>=20
>  ------------[ cut here ]------------
>  kernel BUG at drivers/md/bcache/super.c:660!
>  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>  CPU: 0 UID: 0 PID: 16493 Comm: bcache_allocato Not tainted 7.1.0-rc5
> #1 PREEMPT(full)
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
>  RIP: 0010:bch_prio_write+0x10a6/0x10c0 drivers/md/bcache/super.c:660
>  Code: f9 e9 b1 f5 ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 98 f3
> ff ff 4c 89 f7 e8 e5 62 e8 f9 e9 8b f3 ff ff e8 0b f9 80 f9 90 <0f> 0b
> e8 03 f9 80 f9 e8 ee fe f4 f8 e9 0e f2 ff ff 66 0f 1f 84 00
>  RSP: 0000:ffffc90006657a40 EFLAGS: 00010293
>  RAX: ffffffff883dceb5 RBX: ffffffffffffffff RCX: ffff88801d0c9b00
>=20
> Our reproducer.c is available upon request.
>=20
> Happy to test a patch if that would help.

Copied, I will handle this soon.

Thank you for the report.

Coly Li
