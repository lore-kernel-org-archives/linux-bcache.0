Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C5D2BCF7F
	for <linux-bcache@vger.kernel.org>; Sun, 16 Aug 2026 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890356; cv=none; b=bHyZhCHZsYOJheCcYRwjWfrV9kxlnOUjLPQt/u3BBeItFQmmP2KW/QB0nJgngtb9w8k5fl3Lcjd19/J/y0CqBNKrFe92ds2SbwyawOS8HsTSFPs7BwxmhmvsQNojfjATspUulZoEV+XJY2kXlehYhskQRpM+w1lgSqpWjJR2q8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890356; c=relaxed/simple;
	bh=/YXB/xlEfhl5K7F/yRbaB01B0fKbt+vkRNfpRtcriPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=fLDSb9nkP9VQgUSzwnI3LCu+PGWTe9dyXpSl3Nr8BwTkRnt3BWvkvc62YfmovwGusRkzCcJkqA4SXgD/pMe6hAJ5jK2uQyiBJq/bh4mgS+7kFlHV0yX8BsrzPmWqRDoJKfzXVcQhlxl4PmncID2V4BJdTQMO5MyqOLXMx6MlLIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVsxjQ4S; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVsxjQ4S"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbee3777e1cso1356792a12.3
        for <linux-bcache@vger.kernel.org>; Sun, 16 Aug 2026 07:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890354; x=1787495154; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zNyVnlei0cs9WE0fZVPn52FqubCQK26gvLsbIGU7uNM=;
        b=LVsxjQ4SiSGPKbZZn1D4YmIrCJ7Uuzoko8Lh/kAL/I4t/YHtx5OiH760jaEBIEi/Of
         0pQmVAxS17dtAFWzk6UaZtlA5EGIhUczgNGMUkdlOCXBoHVv66GWD58jOaJCTgo4sM2W
         FGaVf16Z5uURPTaYoBRWeAuYrTCtjW+gCLG/zjtyzlC9N6mU8yqMb7N5vU7SxQulYnUL
         VuGpwcmSM4O7DwvpDaRbjLZH0l0CGw34dz8tdKXGQUZJALoKGYeqLZrhe3pS7xcHTQpU
         g5s/SVzt+8kyqdAZ3h7PPp0x013ZMunXhFLvJ9cfX2VwBqz2ArvLx8AFeig/p22O2zzJ
         6y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890354; x=1787495154;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zNyVnlei0cs9WE0fZVPn52FqubCQK26gvLsbIGU7uNM=;
        b=lVIWlszJ2ErAiVfrwP9uvyCIJTlN/8+LcrnVFBTZ1FEwLIBjo2f3Nx9IhinzVlieK/
         Eg3gGrSSfOveD2z7hKoS9HBYrijIIYenPnMIZB+5Iq019Tq/uk3jeC7l+sRikxZILdAl
         k23mkf42PrTXMfOaaoAWmFJ88CkF6QWZeYoomssDdVhkIeN1Bh6rtq7Gx3oZqGSu//fU
         8hTnn8vsloVgbug77dntbEjACKn9SzBKI6u+nZiEB+a3yldqRxBAv+96ymLtD5LyCvgJ
         IdC0lIZGX2QY0L/yXO4J5lk9B7vsOpc2/nS1njIaMzC+1kwwIeiSKJTg2iX+xuX1T/WL
         Iz5A==
X-Forwarded-Encrypted: i=1; AHgh+RrkuQsQT5hOlX+WbH5ywH3TkVDlPJ+SFT91va6vM+JlU1DrQDB1lrANvGcxKfr3qsy4XuTsFw7bi5ExuPs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0xhWGtMNyvFrwlurCuJkbqqT4noR2tveef8qConV/Sl5iUeVi
	fEp5FNwmz8QZAsaQXRBhtYVwER0M7aXTibHI4rT59m8RNK3CZA0PpI64
X-Gm-Gg: AR+sD12DbAYt3WLseszSzLtUCWgUNiIrwbWoKLo8j1vY/6TU5urJ6RX5LWXk3vHCab5
	/EqaMxWDpCVBIppyw8i1xif15gqd2bjzAo0KgK1UXUcAAz5XFoN9ppS8/LfVOqiA1poe84vMlXQ
	4wzFdHbOQ6rI3pzo4eCda7+Cz47gjuOOzTAHJEOqZ73aWZrO6yWaOB2ta3aTbytadWmhOtfKnCr
	ljKjCTkVmvfOGX6DFt7whAvb10B1C1MFVLkOcFF/Ksh5zoSAtUGvud0x0HPMrC9gx3zLslFD5Hg
	QXxd8sVPL5OlsjLpgWzB6xTvIN/B/uuLDkzSgKvZCmQL0g3s1Gx78DN+7ir/oH5UtJVKe2cG5oC
	sZPilWEq8tmILw+CqHfGlLDzk6n10YyTyTkePPjLqCesJNFVrp4iAQrp61TdUMgiwO2bMDURWol
	qq5fJxWZzkgTXwTohXhyJ4uozDhNLs1qxf9+A70IIJSeaGJ6bChnYniIML6hTjDEE=
X-Received: by 2002:a05:6a20:939f:b0:3cb:8280:71f8 with SMTP id adf61e73a8af0-3cc71c93b1bmr22651210637.18.1786890354117;
        Sun, 16 Aug 2026 07:25:54 -0700 (PDT)
Received: from [127.0.1.1] ([2404:f801:8028:1:2ef1:1461:c48f:f92c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df68ccsm28177310eec.14.2026.08.16.07.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:25:53 -0700 (PDT)
From: Subasri S <subasris1210@gmail.com>
Date: Sun, 16 Aug 2026 19:55:49 +0530
Subject: [PATCH] bcache: validate sb->keys before computing checksum
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260816-bcache-super-v1-1-fb7cba32f5a6@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGzIgWoC/x3MSwqAIBRG4a3IHSdYZEhbiQY+fvNOKpQiCPeeN
 PwG57xUkBmFZvFSxs2Fj72h7wT5ZPcNkkMzDWqYlOm1dN76BFmuE1lqjAZw0Y82UEvOjMjPv1v
 WWj9l9ichXgAAAA==
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com, 
 Subasri S <subasris1210@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786890351; l=2093;
 i=subasris1210@gmail.com; s=20260709; h=from:subject:message-id;
 bh=/YXB/xlEfhl5K7F/yRbaB01B0fKbt+vkRNfpRtcriPY=;
 b=DvdiButgk+9CkZk/xViQpi9Dty9rxDoXTNYl8V4YPpLXcyr/Id3m4FtOCpt0zySCCboJpIdqo
 WONXn5XglRVBWHm5sh7wmmiruHCiWPR9TYHeRE0tJBSIWRbbsiOG6+T
X-Developer-Key: i=subasris1210@gmail.com; a=ed25519;
 pk=6C4wavGFy/OsR8yQQKNWuDXoYPHp2L3sfgNfyzTruTk=

csum_set() checksums the superblock from just past the csum field up to
&s->d[s->keys], so the length it hands to bch_crc64() comes straight off
disk. d[] only has SB_JOURNAL_BUCKETS (256) entries, but keys is __le16
and can be up to 65535, so a bogus value makes the crc walk far past the
end of the 4k superblock buffer.

syzbot hit this with a superblock that has a valid offset and
magic and garbage everywhere else:

BUG: KASAN: use-after-free in crc64_be_generic lib/crc/crc64-main.c:47 [inline]
BUG: KASAN: use-after-free in crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
Read of size 1 at addr ffff0000dd543000 by task syz.0.33/4986
Call trace:
 kasan_report+0x8c/0xc4 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
 crc64_be_generic lib/crc/crc64-main.c:47 [inline]
 crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
 bch_crc64 drivers/md/bcache/util.h:529 [inline]
 read_super drivers/md/bcache/super.c:208 [inline]

Add a bound check on sb->keys before calculating checksum.

Reported-by: syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cb5b32abe226710cdd8a
Tested-by: syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com
Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Subasri S <subasris1210@gmail.com>
---
 drivers/md/bcache/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 97d9adb0bf96..71929576ab89 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -204,6 +204,10 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	if (memcmp(sb->magic, bcache_magic, 16))
 		goto err;
 
+	err = "Too many journal buckets";
+	if (sb->keys > SB_JOURNAL_BUCKETS)
+		goto err;
+
 	err = "Bad checksum";
 	if (s->csum != csum_set(s))
 		goto err;

---
base-commit: 15ef2f78c49d20d53ec7c0f1c9b40b02e089f2d6
change-id: 20260815-bcache-super-5e48eebfc4ad

Best regards,
-- 
Subasri S <subasris1210@gmail.com>

