Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4E2F8E87
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jul 2026 01:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783389114; cv=none; b=dgrhA+gGcWwgUW09xOxoafYFTVcY3mU26rMY/ZcvvNiqG2kGddRbLWFy3jcGxXP/7rtClVVn6tmNjRCu5PckG2tCTf8ZFbK3NFkcE7Fi7EgesiPCRv3qe1Xl0WPI6WDvDFENoxTo97VYckteLig+WX1cnlt5yIO687k4bs7Yb7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783389114; c=relaxed/simple;
	bh=omqdDRL+FmnXggbfCXvPC/JVdJUdyvVPDLwPhmsHuUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO7ODA8Y1Y3HbGyy8Hk9yLpsaTXWhzBHxpBK1IRPNFgbbil/3lpKt4XM0b+W5cqFqmhHc2JXhB+jAi1FOpIYwCbPagGT6sGlVazbNA2wkj4iPYpDQdhlHJe6KebkF3/Ze0nOtB/e/+4P9WWQLOsyEDMBJgCC98vgRRsdny/L30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n2531GKk; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n2531GKk"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-383adaa461fso1883383a91.3
        for <linux-bcache@vger.kernel.org>; Mon, 06 Jul 2026 18:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783389112; x=1783993912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hogqnb/PWbeMOSGUyp313BmM060DNpuPzyexsIa2sJ4=;
        b=n2531GKka9sujdaew4ZEY9aKGVAYp0DJ2YK/7LgIGVe0DR15Lxd9JtHA6U92UfIPMQ
         XRzfKgA6m9jH9h2EivTeGu5kGMj+XsF+hSVrh4ss6oxjHNyBjLGo5O2NPtTIuZ2wLjRA
         m2NquXTJs6cPDrc0B4ZjAowUZnHsdN7SQH5IhkRcLl3Ip2GGmSAO64RcrLmfBy4nbMMv
         w194OF9PvKJYS/JbneFKkX/JxQblhRTZIoDZDIKwn4riwWKd+0zADxkhKIxc38jjcBeA
         WW+zlavIv6B0IsSIPB2Vo3Y1JdrgoYhsGDkGrERK7q+pbMBEIGePLImNg/bOTL7hXlkT
         KCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783389112; x=1783993912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hogqnb/PWbeMOSGUyp313BmM060DNpuPzyexsIa2sJ4=;
        b=FSCtemZHFKvvTsifmJpnxk6Kl6Iqa3BclYxHAwYgniwnTqZLieC09JaFQWLArhucFf
         Gcggw2fm82L3ylaTXezzMIwSahTmX7UOulsbOpnYBCOw1WhatoncJrBjBlSbLgE2Jqik
         u1yfGZhhGzEtjart/XhEu4uNSIC4T34dRtnBRpO4hALobyCyOvRQmDUGbgeTe0AD6Yjx
         BINsVgdTIR74aRNX5Vv1w8ZGuWnHKAf1hTtO+RJjEkJujB2SJBhYEkSoXBWqHZPvpkp4
         hVZ/qmZE+NJk5zu7wjDmwc/F4Kcz/PpwadAIqqPC/fiu8ef4FMCM8SPOKEyJaZYJaap9
         2qNg==
X-Forwarded-Encrypted: i=1; AHgh+RoBgHtsLUIdXb4RuQqjlCEurFS5TXxGXX/WqLf8iDdmrjajM4Gp5UzU6GDPSwTv7yzs1BWVqpT/28l07jI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ1d10hrMz+in5xLuxoMfgqMgElk4/lwbKqWDbAzmaL23vogzh
	cEIjkqAtrdno+LXDRvfOYmVU448VHgWid8MafY0WSAFAH8eGYU0/uEAc
X-Gm-Gg: AfdE7ckNS6y4emnGZH94lwdNCcW5HUk+XpsvBrAFnwfNoJ8qQ2qEXbileeuzZYoDlN+
	EnYy8qWGO4vA+goMFAtoI1spuYL77zE2VLH/nvwe8icFwFBKR0RsASS4/IDL+kTCDs3SGtQwdXE
	y9Vd6iyYCvQq1nMgPG8YESXSely0HYhMW2E7+efyP0AlPhfO/rMlOK5sDX/Vf5N9nHxMjn69wou
	WSi5fjsKEKmK9hIArCU8IOCZXQuaCJvb/fXwYhtFMOj3VUQu8HFNYi/FwlHDQBGlf8lUC5d1rD8
	bRpidDoDo7si1oZAiILrbUN6ndQPELxlRLZOvQiWWQRyQf+knWt6VpxLKTrnMh4+1Qq6jK1vds6
	Zv4kaVq3is25+yQcWK7cIedpX62pZ1bnDLpVLGgbnYUHcbwk4NNdPWtDoGQeYoug0GMUsDLXtGk
	sIP5ge6wE=
X-Received: by 2002:a17:90b:268d:b0:380:8b14:d8e1 with SMTP id 98e67ed59e1d1-387572b394dmr3272566a91.24.1783389112184;
        Mon, 06 Jul 2026 18:51:52 -0700 (PDT)
Received: from ubuntu.. ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d13fd758sm227689a91.5.2026.07.06.18.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 18:51:51 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: colyli@fygo.io
Cc: kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	realwujing@gmail.com,
	yuanql9@chinatelecom.cn,
	Coly Li <colyli@fnnas.com>
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Tue,  7 Jul 2026 09:51:44 +0800
Message-ID: <20260707015144.550136-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <D3C107FC-C1B6-4A65-B5E1-EE562FE84A5C@fygo.io>
References: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com> <D3C107FC-C1B6-4A65-B5E1-EE562FE84A5C@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiliang Yuan <realwujing@gmail.com>

Hi Coly,

Thanks for the quick reply. You are right that I jumped straight to the
fix without explaining the problem well enough. Let me back up and
describe the actual production incident this patch comes from, with the
real call traces and the operational consequence, not just the timeout
message.

> I feel you should explain the problem you try to solve. Is it that some
> sysfs interfaces that you thought should not be blocked but blocked indeed?
>
> If yes, then it is better to list which bcache interfaces you think they should
> not not be blocked during the bcache device initialization.

This is from a Ceph OSD node: 2 NVMe drives, each partitioned into 6
partitions (12 cache_sets total), caching 12 HDD backing devices. At
boot, udev triggers a per-device script as each bcacheN device shows
up, which writes tuning values under its sysfs directory. Three
interfaces are concretely affected, all blocked in mutex_lock(&bch_register_lock)
while an unrelated cache_set is still in run_cache_set():

1. bch_cache_set_store(), writing congested_read_threshold_us /
   congested_write_threshold_us for an already-running, unrelated
   cache_set:

   task:bcache_cache_se state:D stack:    0 pid: 3492 ppid:     1
   Call trace:
    __mutex_lock.constprop.0+0x1d4/0x5ec
    __mutex_lock_slowpath+0x1c/0x30
    mutex_lock+0x50/0x60
    bch_cache_set_store+0x40/0x80 [bcache]
    sysfs_kf_write+0x4c/0x5c
    kernfs_fop_write_iter+0x130/0x1c0

2. bch_cached_dev_store(), writing sequential_cutoff for an already
   attached, unrelated backing device (same incident window).

3. register_cache() itself, i.e. registering a *different*, unrelated
   cache device, blocked behind the same lock:

   task:bcache          state:D stack:    0 pid: 8104 ppid:     1
   Call trace:
    __mutex_lock.constprop.0+0x1d4/0x5ec
    __mutex_lock_slowpath+0x1c/0x30
    mutex_lock+0x50/0x60
    register_cache+0x11c/0x1a0 [bcache]
    register_bcache+0x1d4/0x3cc [bcache]
    kobj_attr_store+0x18/0x30

So it is not just "show" vs "store", and it is not limited to the
device currently initializing: an unrelated device's own registration
can be blocked too.

> If your motivation is to get ride of the timeout trace message, it should be
> much simpler patch.
>
> If the issue to solve is to avoid blocking on some specific sysfs files for
> some purpose e.g. for the system monitoring processes to get some
> information from the bcache subsystem, then it is better to list the
> interfaces you are accessing (read or write), in which conditions the
> processes are blocked and what is the expected behavior.

It is not about the timeout message. The concrete, measurable
consequence in this incident is that systemd-udevd kills the udev
worker once it hits its own timeout, and the device add event fails
and gets retried:

  systemd-udevd: bcache7: Spawned process '/usr/sbin/bcache_cached_dev_conf.sh ...' timed out after 2min 59s, killing
  systemd-udevd: bcache7: Worker [1879] failed
  systemd-udevd: bcache7: Retry 1 times.

This is not a one-off: the same kill/retry cycle repeats roughly every
3 minutes (11:04:03, 11:07:04, 11:10:05, ...) and by 11:04:03 it hits
essentially every NVMe partition on the box (nvme0n1p7-12,
nvme1n1p8/10/11/12). So the whole bcache management plane on this node
fails to come up cleanly at boot and keeps retrying for several
minutes, which in turn delays the LVM PV activation / Ceph OSD startup
that depends on these devices being ready (interleaved in the same
log window).

Expected behavior: recovering one cache_set (journal replay + btree
check, whose duration scales with device capacity/health and is not
bounded) should only make operations on *that* device wait. It should
not block sysfs access to other, already-running cache_sets/cached_devs,
and it should not block registration of other, unrelated cache
devices.

> At the first glance, I feel this patch doesn't have enough testing. e.g. the
> race between bcache_reboot() and bcd_cache_set_recover().

That is a fair concern, and I want to be precise about what I have and
have not actually verified, rather than just argue from the code.

What I did check: bch_cache_set_recover() only runs unlocked on a
cache_set that was just allocated by bch_cache_set_alloc(). The
CACHE_SET_REGISTERING flag is set and the cache_set is list_add()'d
into bch_cache_sets in the *same* bch_register_lock critical section as
the allocation, before the lock is dropped for recovery. So
bcache_reboot()'s list_empty(&bch_cache_sets) checks and its
mutex_lock()-protected wait loop see this cache_set for its entire
recovery, the same as any other cache_set that takes a while to stop -
there is no window where it is invisible to bcache_reboot().

What I have not done is actually exercise this interleaving: trigger a
reboot while a cache_set is mid-recovery and confirm bcache_reboot()
waits for it correctly instead of assuming based on the code path. I'd
rather get that data than keep arguing from the source. If you have a
specific interleaving in mind that you think breaks this, please point
it out and I will either fix it or build a targeted reproduction
(e.g. an artificial delay inside bch_cache_set_recover() to widen the
window and drive bcache_reboot() through it) and report back with
results before asking you to look at the patch again.

Thanks,
Qiliang
