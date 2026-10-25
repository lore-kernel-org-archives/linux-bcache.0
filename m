Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.214.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792931928;
	b=Uz1NGyqMDh+vVchkshc9ZU0Ez0v8ORasGqhBkywGQ//bOwOdkofpnAM2IenmHETn8U3j
	 8oFTUZCmnTRDlyPOAHIoImUZSVdF2VYCbROjh9Qc+Y0nMQEGW3zBnTcHpfMgs6xQw7lDd
	 viWj5yi+Rc739ipKllroVCzvnwzqu0P4sJpmso78qfSNxUQ/G0hTLf8zmOBsvnqmJbG0d
	 qmjx+6u3Imh2Dsavjq5pA16YYCcffXMXmDWo8QibE1BqD2FZBGEveJdmMzJ/BRzze0zAI
	 QZYw8MsgJRr/G2hioMGcOi7/guWMsvmgg4kRH19gwJx+joIgiBCoqqcl/IrLowr7SSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792931928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
	b=xLouKuDZhnSaVQA16PcY0eWQPPzj9yTSk2apYgXjbgfrvkEzwnRqFwn98jD1ozRratxy
	 onwLinK1dOZgHlyRSMgaN9b5CLfX1wqZVSgfMcF7JdwBIMOAOTyJSyWrJ3uRSVyH32Xui
	 L/Yatejk5XGqWcwwLqobSmeQ2LiZjr+fXWL5K6KrEIveVZki0szpCdR833gl7COorGSoz
	 njHBlWedxUtHz//AZPUY8xPohJOnrF0q7xs9/uxM/t+tyTyZ7WKcvTpF+wenuBXLQGJD1
	 EF6N6H8Y4crLK2ute1q0swvlZcHb7gp38hLPkpuLLLodlCTJKc19IANd4+Bp7lzKtHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iOtqb047;
	arc=fail smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F7606A31D
	for <linux-bcache@vger.kernel.org>; Sun, 25 Oct 2026 12:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 335F7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iOtqb047
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e5fb79ce82so13951405ad.0
        for <linux-bcache@vger.kernel.org>; Sun, 25 Oct 2026 05:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792931927; cv=none;
        d=google.com; s=arc-20260327;
        b=btW3Fy4RRpuaDFyWkkAVxIBvsjd3R8d4zYCI3tzwyuEg1cQLef00bb68/u/bxtRWnj
         BcNI2SFA0yBmKxgK1r7N4h/DGUx4lg4/BZGFct7B0OhzPHDvRBSZUOLpH4kO9utgXLE3
         Uyz9JP+VbmFiIgrteCWjhP6MfspxMpnUnGPcMYdZ2D4TcCpuAxWXqiNVtbCbvzjy1NF3
         FibgeRS6BWdKiYxPrxSxHCQLTioXLJmSU31FSZ/BEBwkVIaFuMXQPl3hacDWeAt9tqkO
         j7qqy5Grx5U/EBQnVLsyMj0LU24v2BlLb7AePSyUvfAi0gBJe2i9dBbgBxqNxLcXm41v
         RQ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        fh=W6WEZ8Y4lpEkHj7DPch7ihGJmlTYAVQqHHAeitlpTDk=;
        b=X8yvbcK21Iq6OY7FMoyrllRK/53g65AY55vz9BakOFrrmOWNZ4slwhvYk4RXAwRGX4
         Zy6ysZK5OoSucGP68nqZRX4IhnePw6dgFOFPe3vtou24KvbaTNb4Wp3CwPmjTBg1JKPu
         Ogh49e4lYqqu2W1MZgPLRQvExZTCasVNzzPz6PZL6RrNPU+rLJ/mlY93C5lz6d67Nqc8
         nuEGHABwwwAv/pDyU0/GSI9IASK+DtmdUFQMp4wEh2wy8mRTV1V5JlT6La/PRvpio+nc
         /coFQY2zIRfAAvbUX+uInSWIGdtreQ/5khEUU9GBqNGR17DfJsCoZ9AIav2aDiC3K+/O
         LogQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792931927; x=1793536727; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        b=iOtqb047pnEUjxXecpH7QYAAr+0xFD5CcDSyHwjG3/WU1su2+31417TQX0mo173lXz
         IJ2GtlWfHIjw5XYazrF54FlBJivDQWD+a6tIVaNJ5ZIG8Y8lPZNbezvVVNAcKsmQjLao
         +5Kc2ezbXmfXt6ODeB67Z4TDljlwl6/7bF4DLWTZwYK079kp68HGtW3/PYrMGZlpIbOC
         6Hxs7U8Nh9DJmBBFSHf4PghnVjo6J1znjCoHBA68pzOc/LYcVV2xZ/AhhpEwIkrdFmj4
         eOzcraHDpl8Mcd92gD6TrWI+9nsRqXjK+qprUOrsNyxLf4H6cMXQTFmu0AHqGmzmM/7z
         WVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792931927; x=1793536727;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        b=IC7NKT7bgUOHMPeHygtfhPVP3FdIHI3caXo+yi3yE8N+qNABXhP1hOj9rW2WQZWWTk
         EBwjMWA2EZp7uysRGOBSjwLdJI6npPJYlsSQWMJ9OD5uTBsFrRGh+8m6HpytluzbwXf1
         AxgzFPXrIxKC+aqT8EMEiRDlZ8xZ2T9svqjwgqbAuANfrGaUHCHK1cp7jZ+AOJ+p/24F
         BpY/nSIkzFzjbkuee2UnDGkgP7lukFnRez52BI/qYKxC7lkXnBwlubvpreRiWBU5Q+eS
         HLpRBJXLBv4pnBd3+WyOZhaat11II7i5QYcMNBF1HK7bT4h+3UF4gqveq6GCNWmaLp/N
         c6Yg==
X-Gm-Message-State: AFq9FYLp/oqu/GpSplu7s0nNzUb8Q0JtOulXiTD1kFbHv+ofAGFvrGvz
	WXnCZ6NiizyrbFVNy1qeZChP9ubBiAtwOSs2/rfSdAM/9sQKG/jZ2XhVu8c8dOXhe8srZMO3zP3
	Je6kd5jP/VMX1uPVUGKe+mawc0rNWyBDJ8qgFjTg=
X-Gm-Gg: AYBFou0I4uWJ5e2UppghKJsWMKyy9SLUGGdb+GE2DnxFx4+reH6Jm47FkrfEAIqHXZy
	w80Z9+hqI7HhU7oncTbrfzTESm3ey5eX7UQ9JNOBa7Ssm+4buIhJ3ea6lUTSTo8jh80r1A+r1tm
	/BgDeKQRci285sjA6Mywf7DI27dapHqwsmlAxvl06ARE5EVDP7J2REJCvU4mZy3UEWSX0YLM420
	ZFfpNJ7amuh07ij23lrWa0kK0nzPF8Idn1jc1Ln5B9fBRccsqiHjjUDcOy18n0mOPSAoqXFNRIA
	1dcqFC3o5YpFBg6XLhqGiEZ3CcVc1cH6Bf1h+Thunoqpl6+CPDI7k71AIgeNmriKtQAorXCL+YK
	MQhn7+My5HW77SV/EbuU8PE+5GrYVEFrhQgIfc94=
X-Received: by 2002:a17:903:1103:b0:2e8:3e5d:b2b7 with SMTP id
 d9443c01a7336-2ea9c8754e2mr34279705ad.40.1792931927515; Sun, 25 Oct 2026
 05:38:47 -0700 (PDT)
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Konstantin Nikiforov <helllamer@gmail.com>
Date: Sun, 25 Oct 2026 15:38:36 +0300
X-Gm-Features: AclHuK-zJVIt5pMq4aEG8YbVUe1pdfb3ZT8Uy3v4AWHcgp8mQbjuBakU33gJh-A
Message-ID: <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
Subject: [REGRESSION] md/raid5: discards on an array of non-TRIM HDDs now fail
 with BLK_STS_NOTSUPP; bcache counts them as backing-device errors and stops
 the device
To: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Cc: "wale.zhang.ftd@gmail.com" <wale.zhang.ftd@gmail.com>, kent.overstreet@linux.dev, colyli@fygo.io, 
	"song@kernel.org" <song@kernel.org>, yukuai@fygo.io, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#regzbot introduced: 90573092673c

Hi,

since upgrading from 7.1.8 to 7.2.11 a machine with root on
LVM -> bcache -> md raid5 (three SATA HDDs without TRIM) loses its root
device a few minutes after boot. The same stack ran on 7.1.x without
any bcache backing-device errors.

Storage stack
-------------
  3x ST1000DM010-2EP102 (no TRIM; discard_max_hw_bytes = 0)
   -> md126: raid5, 3 devices, 512K chunk, metadata 1.2
   -> bcache0: md126 as backing device, cache set detached
      (also reproduced while an NVMe cache was attached)
   -> LVM vgpcrd5
   -> btrfs (/usr, /var, /opt; mounted without any discard option)
      + ext4 (/, /home)

Kernel: 7.2.11-arch1-1 (Arch Linux), mdadm 4.6, bcache-tools 1.1

Symptoms
--------
Every boot, starting ~3 minutes after mount, dmesg fills with:

  bcache: bch_count_backing_io_errors() md126: IO error on backing
device, unrecoverable

in bursts of up to ~35 lines 2 ms apart. Per boot I counted 11, 17, 22
and 63 of them. bcache's io_error_limit is 64, so once a boot crosses it
bch_cached_dev_error() stops bcache0 and root, /usr, /var and /home
disappear. No I/O errors are logged by libata, sd or md; all three
members are healthy (SMART clean, array [UUU], no rebuild).

Analysis
--------
Since 90573092673c ("md/raid5: validate discard support at request
time", v7.2-rc1) raid5_set_limits() unconditionally sets

  lim.max_hw_discard_sectors = UINT_MAX;

and records member support in conf->raid5_discard_unsupported. On this
array sysfs now shows:

  /sys/block/md126/queue/discard_max_hw_bytes: 2199023255040
  /sys/block/md126/queue/discard_max_bytes:    2199023255040
  /sys/block/md126/queue/discard_granularity:  0
  /sys/block/sd[abc]/queue/discard_max_hw_bytes: 0
  (md127, a raid1 on the same disks, still shows 0 for all of these)

Two upper layers react to the advertised discard support:

1. btrfs enables discard=async by default because the device advertises
   discard (mount shows "ssd,discard=async" although nothing in fstab
   asks for it).

2. bcache forwards discards to the backing device whenever
   bdev_max_discard_sectors(dc->bdev) is non-zero (cached_dev_write()
   and detached_dev_do_request()). Before 7.2 that was 0 for this array
   and bcache completed the discards itself.

raid5_discard_limits() then completes every such bio with
BLK_STS_NOTSUPP. bcache's backing_request_endio() treats any non-zero
bi_status as a media error and calls bch_count_backing_io_errors(), so
each discard brings the backing device one step closer to being stopped.
With 64 small deletions on the btrfs volume a root filesystem on
raid5+bcache is gone.

The granularity is also inconsistent: discard_granularity is 0 while
discard_max_hw_bytes is non-zero, so writing any non-zero value to
discard_max_bytes fails with EINVAL (only 0 is accepted).

Related changes I found:
- efdffeb6d491 ("md: skip discard on unsupported member devices", 7.3)
  fixes the same bcache symptom for raid0/raid10 via
  md_submit_discard_bio(), but raid5 does not use that helper and still
  returns BLK_STS_NOTSUPP in current mainline (raid5_discard_limits()).
- 85764f475f3b ("md/raid5: complete discard bios while reshape is
  active") addresses a different fallout of the same commit (hang during
  reshape).

I have not found a report for this raid5 + bcache case on lore.

Possible fixes (either side would do):
- md/raid5: when conf->raid5_discard_unsupported is set, complete the
  bio successfully (discard is advisory) instead of BLK_STS_NOTSUPP, or
  do not advertise max_hw_discard_sectors in that case, as before 7.2.
- bcache: do not count BLK_STS_NOTSUPP (or failed REQ_OP_DISCARD) in
  bch_count_backing_io_errors(), the same way REQ_RAHEAD failures are
  already ignored.

Workaround in use
-----------------
A udev rule writing 0 to /sys/block/md126/queue/discard_max_bytes and
/sys/block/bcache0/queue/discard_max_bytes (also inside the initramfs),
plus "nodiscard" on the btrfs mounts. With that, io_errors stays at 0.

I can test patches on this machine.

Regards,
Konstantin Nikiforov
Claude Fable 5.1
