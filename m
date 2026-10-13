Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9944BCBE
	for <linux-bcache@vger.kernel.org>; Tue, 13 Oct 2026 02:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857388; cv=none; b=KbRTsUAvsONkVpRS0Zctye2LCjsfj7UW/hwS54GUaToz8wCysQhwnwEDBvnMKYK5bo9QQC8ZYCE2j0q39XAHB5y/I06ozkmMvuvgavgCOo6B0ix7HBR/naTs29eJ3exrcSQFXVhC2XgsBSD1e6sJwe5ROenGl0M5XUX+Der/JAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857388; c=relaxed/simple;
	bh=czPVgNXT2OgaXwjFbvuyK45RKjR2md9vJ04hkTHTkCE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SuiEgcTfKA87TG7TuMH9eG8GsZrie9gSSVsp1qFkbyOq4/iKMoj+zNwELvpwKqtPok1Qkn35See3l5Ng3Jxv74Jgu8YI60j6cyH/3R+bx8azf8oxgQh5wvjREEncmvq/FThmcVTt8T4PSAPHQ2/1yD2LBcPs741fwC97NILw0Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gnFCcreV; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnFCcreV"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-353804b591eso4165617eec.0
        for <linux-bcache@vger.kernel.org>; Mon, 12 Oct 2026 19:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791857387; x=1792462187; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=53/8rFLtj+oKerssY2sv6i0RQan/DUVl/IJk1Ms9Yfc=;
        b=gnFCcreV0QYBNJTRlHo8PHFszPMpk3CNNVt3DdgKNnhWEZQ1V27Tv1axmCcyRTzkcR
         yZVnB+0gWVjzBbDS0QLMynvvSxIn8PfLjmm0b1yzXWIlyZuBHeJsIQdhc658ueiy4Icr
         Guqxf/RMKFPo0dggDLfjmK3Djzo2T1zegE36F22nNRgFGAdgfH4Nzb+ixj9l/XabJbL1
         5C3RLOOH/rDr9tEQYnHqxNu7zZUz4d54nIOtzkfraAkSlliIdi1DpB81UXYLdsHtzrMR
         AJ3PD+2XLs2UcAP8VxIcYpovPv5afhuHCArV5nthwW2kCcqGSScU8mZJvRPYLuurEwH8
         WUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791857387; x=1792462187;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=53/8rFLtj+oKerssY2sv6i0RQan/DUVl/IJk1Ms9Yfc=;
        b=N3EU1dMp3/wYYicKfFLgfsuy3qddq6iehRnX1jFR8v/XC96wwLqoppSs1v/y1oyJcv
         4uQ8sPrExvLTvjVCiMDg5HMZtx3N3eSyKwBpWyLvFiET6Of0HieBx+J+sFeken16TaGT
         qgz0t8xJIOKQ//eUQQyL76Qyl5b7hVTmQ8LQDI9RMoS6n0QDncjxTaRW53P2sDGkmEbW
         tOMbi8PIKLAS9ZyfI13/Q2ZQPwzmcxH29AIEp/TA92sjObenTExd162SBqE7gnqbpEIZ
         97WVKOOwwsYoTcC2lmPveMLW+MEkRTczGv4ZXtOMIo+g8WOpVsuJhg24YKuxcosRdXHD
         VWqA==
X-Forwarded-Encrypted: i=1; AKwUvByV8M1HP8HTkwPcPhxSf9SCOsmvin0ClFgmCuJXtkLxdQbcRPLCBGGwU5m6Y6tV65pEUNMxxZcWWxYxMTI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIip/SuhIHk1/TRsBwL388glcqYVqvJ7cNbgYQqYPeEC6qG+Ilz
	UdeQAQyAeovI7BtnbdMKwxusFA1A/v3mbjkrxpcsEP3rcrEIlc+resLv
X-Gm-Gg: AYBFou3qeffS3KMY8mRah4o8d/3pAA5Vrk4lGPg6b3KR06LJTKAjHVqQKNAdqpMVPk0
	D5XBXHuTGacBsNIsrauT2UiO/KcybND3X+OHFI8kq0QVw+JecM96u3eJmkzBeLvpSTfacBefIB1
	dqijOeTUWl25BFtb/DxaFGaDoLeQIDpsMxpjsrafLm9pQ3vp+1zuxUA3igvhwC3NfR8MFoiFuRn
	3NcF6EkLbcX59GZho6wb1bf3EP+7aosl2Y/X8ACSgdFuUdvGelCsCmQ1r1iTSZlNjif2OUnPu3o
	z7XqUo2Bl4X9jmj3aRIxrTQkcJdgL7PdU6vZALU2xwhGTBmq+PXkDafgMgq8jnK0oDjvJzkAbcK
	38WouJsMRUsn+AaHqnyYWJUBOVacMf0MuQohrPNcyN1KlW9mesePBYGLO4U1Mw8/6CW3vmddFnd
	+kOKgjzZKBom2mpp7AST/y3RmILgIRpKUHx/Dao5rcGuB+qawuS5HMnZQS62Om06BvsAC2kkRxx
	lRj/LwlDm5s
X-Received: by 2002:a05:7300:d103:b0:35b:3181:80e9 with SMTP id 5a478bee46e88-35b31818605mr4170366eec.20.1791857386463;
        Mon, 12 Oct 2026 19:09:46 -0700 (PDT)
Received: from [127.0.1.1] ([2404:f801:8028:3:8056:897e:dae3:8e2e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm11643813eec.24.2026.10.12.19.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 19:09:46 -0700 (PDT)
From: Subasri S <subasris1210@gmail.com>
Date: Tue, 13 Oct 2026 07:39:40 +0530
Subject: [PATCH RESEND] bcache: validate sb->keys before computing checksum
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-bcache-super-v1-1-7bf7e6930eac@gmail.com>
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com, 
 Subasri S <subasris1210@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791857383; l=2095;
 i=subasris1210@gmail.com; s=20260709; h=from:subject:message-id;
 bh=czPVgNXT2OgaXwjFbvuyK45RKjR2md9vJ04hkTHTkCE=;
 b=q+gXKToLe6oG7kwfZ0k9csc6qr5Y9W9z3QyJnSfj4hKUWIUfXYAE3pyWQL+OrlvARUkKCeDOC
 DjRaNK5jm19AD6Nn4FJuz51T7Tev3PCB3RjEinD0Pg2ltQR0O4kTOCl
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
index 97d9adb0bf96b..71929576ab89e 100644
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

