Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23B83CDBAA
	for <linux-bcache@vger.kernel.org>; Thu, 27 Aug 2026 23:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871867; cv=pass; b=kK6fVMqoVQypIelV5ynX6zI9m0yrwTpD1aiXBtwmINGIuERTNVwwKp+RXcfCanEJ6+wAUs7erRANhsUKyJkVxQlnFmK1fEhmKUBy1l0wCWMHjS60ReJRn/BbmA6lCT51pFP/iBY+AQbxhimJhyymFC9wSBgo0NiwWa+f81ffZwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871867; c=relaxed/simple;
	bh=QsepCMeiTbPeNVABwKQ4kjsp/vlAuUKCw6UJtp0V5xg=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=icYm/x7kIIMOevXIrfeG+6ic4t7XIREkWApnRy/1x9p5qIneGwWFkriqS5L0dRE5AzEzETh14DT5eeupImq9gZzmuxkfDihAwaWOVaJNKlLM1OepaqVGz+Gkurey9moevvk60dDCxd5f8KWiCUl4xEud1SLQHO/jHoK20ul0RlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=FoTS2vbZ; arc=pass smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="FoTS2vbZ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so1967625ad.1
        for <linux-bcache@vger.kernel.org>; Thu, 27 Aug 2026 16:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787871865; cv=none;
        d=google.com; s=arc-20260327;
        b=RJbKn+PbdEvDWmnWLdsM1t7ITthcBKW8X8wTXBIA/ToVzN8AFcVvmBAxbb8hCNuyZm
         evg0JqgRrfI6Pj6KVG1sukaruE2eaqZDi36v6vqHt9XwtB3zxyPw7AM9UFFZ+ig3wIOM
         LWZt12xZYBJE1yGCZJZVKg92yMvPNbZEwTjbc2aQvNEs9NOn3JfRYtusjIKEMuibw0tf
         91DrD5DFtaQY3I5DWSNnC5pkCvRfT3Sb79xVer0ghD6j814hgTEMogaZHLx0Pq45U07L
         BIBBbwEbGAJPuKp5kNiMv90z5t1+p9uW1LV6mTUvLau3yQhPYh5TAHPh6GrZOK/LVeI0
         Jpyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=Y8w8/99lXpipXNugsU1jjmc1wW/tCaLOM5DmuIqroZU=;
        fh=xA3p/slRzwJehIwUZhQVlivurvuM1ha7uhf1PrjVT0U=;
        b=sAJ23ZHz1lPiF4+UCim1db793pumblL6Csk6doLGmeBR/H1SvLjmEcGZn5+/MHnLln
         lw5BOmDgtLFm82B9mGt+/S+V359MgN3iFgaFIxTR1tG7E9uCaP5d/81a2HCwkQ9/cqln
         re2YHBQzl2vWuMQTXd5JDf0sxhVI4QJbx2icb9/6voJLf7J8qb6kw52HLa7FvX2sxsFD
         dW2NZmn2RNo95+WuSNN3Wfl7bh4s2PxbSfyWwwS+xStHdGIFYYZu8DQKfM+1xEPtMTmv
         wpMAj1jUTtCLy8LC/yMcgmAJNHlJF8226OrdmCjFjTpzjlKHjAx3j4qCXtXw+AXqa79x
         AzWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787871865; x=1788476665; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y8w8/99lXpipXNugsU1jjmc1wW/tCaLOM5DmuIqroZU=;
        b=FoTS2vbZkRRkjDB7EBc2nKiRYa8AMVaHEiwtyo5oMzraRznkyCAEb0otyY8h59nEaA
         1R3LeZV5eR9MYaMRKr+upM5/qFfN8MZGx2zSwIcNHjq1XxoXuYP8YeUvOlfeKcTefCGf
         qsQiYJFTLB/9fiVhmp6M2nBDasdSQdJS1OIoKX0C0xdgb9NyQ9un6lsdufkG7ye2VlLZ
         V2K7N+3A7ULImo3ee/pqtjJxeVt4WRlLrp0ccWWvshmsgES0Qk3unaUSF7/uJyHmF+iS
         k0Nf6fk+Y0W4wAg8kpPsfqoYU5X5gqTAKIB69g5u0cOmKC3dvLGHYLVX4NrQsecUuaF6
         ngmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787871865; x=1788476665;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y8w8/99lXpipXNugsU1jjmc1wW/tCaLOM5DmuIqroZU=;
        b=VileONLVwvNMgtBcKS1IAvQDec2Mig8c8+mk/gBHRCa8AeE2JmB+2gcrWJ1Q5QG+xP
         nyQPOv5mcGIr1Se+dXr+3wvlESU6YPuujUvWLZG+P0Zjtkrh0Svlq9k1f784sqZFd4Fh
         QFwj7zO9JVHxt1RrunQJqsBzMgdtmdR2OLuwBiBKzx0y4bKvkt30yunjPplXnRZXaPag
         N7wI4qVmQdf+EZLBMjmkiRUbkfe/PE0WeVdYz4OhMdVHAmPLNu2aPWZDy0DeFuL2GXTd
         pdipi5H+BeZ+DOTr2wPmrJUQ8H5/JkayI3FuJsaJGoJ6pacjwlpc7QDDkAPjHxVYwyxC
         GeMg==
X-Forwarded-Encrypted: i=1; AHgh+RqzddHee7gzgn5x4FkRfxRy+qkSb28RLOv97vpzIXoOa+2aIworQrRgBqzYOkrG3GxDdhTCWlQ6iL3bVW0=@vger.kernel.org
X-Gm-Message-State: AFuF++mHjB3+cm5DdyELXTXR4kzpeVUOeE44PlxQrxjqk7fz5M1NWa0r
	DNqB7Rl4PQvcrHnl4bZCTt2H0SwxSJ52YYgPKprUXDLfoEemyLcev1XBTlbJW9WyiPST5tBvWUb
	olzJMRRBNlnenb8ARK+9ZpC2XtalJHOgqUSCC7x3E
X-Gm-Gg: AR+sD11urDiubMOqie5fV+u2Ibi30TY8k1ojejYncnlQpMc49bpWNY6W2F/5Am7a+CO
	JmFlwdXkSp4tFsi87CvankBp6bUNAcbTcEJ+TGSX4zN4OrhAGGfD05dErOdTRjUvrft/D5w+r61
	6ihCv7q9Vzb4GJwFq/pXTWYJ4JI6iwh/VglbZYNFk/sclVvbzCvEU94ce3lGTQ45zmUM4GgiNgB
	4my1QYhshnzLb7gC88hd9YaLlI9yf4WzCavYI+w2xp5RC87tYxu+vb+s8wKxisAVzCnsyqIyuvi
	cXF3E7vu9lIkirXyFZ+JcRL07qtjNANOzZvQemLbdxxVskh3jGbJMPqz7BcjKhpDb/PPFsm8P8B
	Z6EwNi0Nahiez2D0p1FiHwcZTZ05rlvvc
X-Received: by 2002:a17:903:3884:b0:2d6:3c22:993a with SMTP id
 d9443c01a7336-2d74dbe96fdmr48838025ad.3.1787871864030; Thu, 27 Aug 2026
 16:04:24 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 23:04:22 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 23:04:22 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 23:04:22 +0000
X-Gm-Features: AcwNN1XHtToPPwTQkHjpj925zF940Qhj869Qi77Jaw0lF76Q7nZ8RKTQuP57Vc0
Message-ID: <CA+0ovCgU4Y17ERRdtCydW6aVUGiYDMs9Uz4TEJoMGh13oEJQvA@mail.gmail.com>
Subject: [BUG] bcache: BUG_ON in bch_prio_write()
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: falemi@asu.edu, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Coly Li, Kent Overstreet,

While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
SEFCOM lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/115-bcache-bug_on-bch_prio_write/

  ------------[ cut here ]------------
  kernel BUG at drivers/md/bcache/super.c:660!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 0 UID: 0 PID: 16493 Comm: bcache_allocato Not tainted 7.1.0-rc5
#1 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:bch_prio_write+0x10a6/0x10c0 drivers/md/bcache/super.c:660
  Code: f9 e9 b1 f5 ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 98 f3
ff ff 4c 89 f7 e8 e5 62 e8 f9 e9 8b f3 ff ff e8 0b f9 80 f9 90 <0f> 0b
e8 03 f9 80 f9 e8 ee fe f4 f8 e9 0e f2 ff ff 66 0f 1f 84 00
  RSP: 0000:ffffc90006657a40 EFLAGS: 00010293
  RAX: ffffffff883dceb5 RBX: ffffffffffffffff RCX: ffff88801d0c9b00

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
