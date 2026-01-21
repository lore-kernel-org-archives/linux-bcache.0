Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A634E48AE04
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769006198; cv=none; b=XozHUQ01kZe9GFyoQAZHmdrNqZuxj9+gF+vR8EG2frJpB5EhqjxJI9ro92oBlkmrqHKJdKhz6fvJGSyWfbK+Ph6/j7g+OEV8tfiL/gBf63+Y/Qg/XwUddqjrILkyGwpF8vogctmDB+R4CnSi9Q72FFVTFUxiOM7qMbv0zpitjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769006198; c=relaxed/simple;
	bh=T2xwOQeUfClNmAPH1kWpwGvyOhczPdS1888A9zHSx5s=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=F989V75oYchhVrwNxeup+nuuiQfj+Z2yMSYPM2TgQw9ZigryRj4BTVSJD4xyDOcztULZqnlFnbxHmD2cFMoE+Fy9oXjkj03UOM/IqailllARDR5JlN9jMssVJjuXxr4xYcRnMi9M7oCS/Sm1kPLTiVG/J07Yqn53qGPpKtRUW/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q+YrjhY9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Va3D61gu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q+YrjhY9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Va3D61gu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q+YrjhY9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Va3D61gu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q+YrjhY9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Va3D61gu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 900FB5BD14;
	Wed, 21 Jan 2026 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DRp9TRJcSbq4fFrCMqLeHybFyWqKHLAmfQmIBccHNgo=;
	b=q+YrjhY9jVpHTzATYggAqvUaRIFx3H5/BDyv3Ty1WaKRzNBaD9QkvHoD08IZXJKC877boU
	c6513N3tuJ5ZpjV5MMGiyPjWMFed9ga5Kt1pMaqQ/752LWhnALyjCmo/6z1Aiea+54/NDP
	tpcaR/2839INPmzJ8aMgVjF9pnmVv+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DRp9TRJcSbq4fFrCMqLeHybFyWqKHLAmfQmIBccHNgo=;
	b=Va3D61gu3IzNomTUWo9dC4S2Bkqh/ygPQ87oscIfn4VueGo6LEgh38Wy0JA/3NkzvnxsGB
	sUVHSkR0/cRpWoAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q+YrjhY9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Va3D61gu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DRp9TRJcSbq4fFrCMqLeHybFyWqKHLAmfQmIBccHNgo=;
	b=q+YrjhY9jVpHTzATYggAqvUaRIFx3H5/BDyv3Ty1WaKRzNBaD9QkvHoD08IZXJKC877boU
	c6513N3tuJ5ZpjV5MMGiyPjWMFed9ga5Kt1pMaqQ/752LWhnALyjCmo/6z1Aiea+54/NDP
	tpcaR/2839INPmzJ8aMgVjF9pnmVv+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DRp9TRJcSbq4fFrCMqLeHybFyWqKHLAmfQmIBccHNgo=;
	b=Va3D61gu3IzNomTUWo9dC4S2Bkqh/ygPQ87oscIfn4VueGo6LEgh38Wy0JA/3NkzvnxsGB
	sUVHSkR0/cRpWoAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE51D3EA63;
	Wed, 21 Jan 2026 14:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YSlPNXDkcGl9cgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 14:36:32 +0000
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH blktests v2 0/2] bcache: add bcache/001
Date: Wed, 21 Jan 2026 15:36:21 +0100
Message-Id: <20260121-bcache-v2-0-b26af185e63a@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XMQQ7CIBCF4as0sxYDlNbqyns0XRQYZDatYZTUN
 Nxd7Nbl//Ly7cCYCBluzQ4JMzGtSw19asDFeXmgIF8btNS9VFoK62YXUbQdukvbD24IBur5mTD
 QdkDjVDsSv9b0OdysfusfkZVQorvaIK32Rhl55zfj2SNMpZQvr42IEpoAAAA=
X-Change-ID: 20260120-bcache-35ec7368c8f4
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 900FB5BD14
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

I've got it working. The problem is that udevd sometimes doesn't register the
devices in a timely fashion. The workaround is to explicitly register the
devices within the tests. This races with udevd, thus some logic is in there to
filter out 'already registered warnings'. Eventually someone should look at
this...

Also made the wiping of the disks a bit more robust by stealing the ideas from
Stephen's test case[1]. Thanks!

As requested I also added an entry in running-tests.md. There is already a
section on TEST_CASE_DEV_ARRAY so it's a bit redudant but given it took me a
while to figure this out, I think it's worth to have it around.

Now, the test runs very stable in my VM. No issues in hundres of of runs:

bcache/001 => nvme0n1 vdb vdc (test bcache setup and teardown) [passed]
    runtime  4.659s  ...  3.555s

The runtime is not really constant, one of the symptions with all the
workarounds in place to get it working (retry loops, white loops etc).

[ 5327.588585][T100690] run blktests bcache/001 at 2026-01-21 14:33:45
[ 5327.742119][T100766] bcache: run_cache_set() invalidating existing data
[ 5327.747790][T100766] bcache: register_cache() registered cache device nvme0n1
[ 5327.782118][T100690] bcache: register_bcache() error : device already registered
[ 5327.790339][T100690] bcache: register_bdev() registered backing device vdb
[ 5327.798633][T100690] bcache: bch_cached_dev_attach() Caching vdb as bcache0 on set 33fc88e8-3251-433e-be43-620f625c
[ 5329.598292][T100396] bcache: bcache_device_free() bcache0 stopped
[ 5329.898146][T94893] bcache: cache_set_free() Cache set 33fc88e8-3251-433e-be43-620f6253e0fc unregistered
[ 5330.315859][T100803] bcache: run_cache_set() invalidating existing data
[ 5330.324537][T100803] bcache: register_cache() registered cache device nvme0n1
[ 5330.330337][T100809] bcache: register_bdev() registered backing device vdc
[ 5330.339168][T100809] bcache: bch_cached_dev_attach() Caching vdc as bcache0 on set 986fa332-8e02-4a1e-942c-b6f3458e
[ 5330.345113][T100813] bcache: register_bdev() registered backing device vdb
[ 5330.362462][T100813] bcache: bch_cached_dev_attach() Caching vdb as bcache1 on set 986fa332-8e02-4a1e-942c-b6f3458e
[ 5330.466850][T100690] bcache: register_bcache() error : device already registered
[ 5330.469039][T100690] bcache: register_bcache() error : device already registered
[ 5330.470933][T100690] bcache: register_bcache() error : device already registered
[ 5330.472971][T100690] bcache: register_bcache() error : device already registered
[ 5330.474847][T100690] bcache: register_bcache() error : device already registered
[ 5330.522678][T11701] bcache: bcache_device_free() bcache1 stopped
[ 5330.571838][T11701] bcache: bcache_device_free() bcache0 stopped
[ 5330.805725][T80064] bcache: cache_set_free() Cache set 986fa332-8e02-4a1e-942c-b6f3458470fe unregistered

The next step is to figure out how to hand back the devices to calling test, so
the test doesn't have to hardcode the test device. From Stephen's test:

[...]
    # 2. Detach
    log "Detaching backing device..."
    BDEV_NAME=$(basename $BCACHE_DEV)
    echo 1 | sudo tee /sys/block/$BDEV_NAME/bcache/detach > /dev/null
[...]

I am sure there is some bash-way to do this, which makes me blind. But hey, if
it works, I wont complain.

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
 

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Changes in v2:
- fixed whitespace damage
- added documentation on how to configure for bcache tests
- do registering explicitly
- made disk wiping more robust
- Link to v1: https://patch.msgid.link/20260120-bcache-v1-1-59bf0b2d4140@suse.de

---
Daniel Wagner (2):
      bcache: add bcache/001
      doc: document how to configure bcache tests

 Documentation/running-tests.md |  16 +++
 tests/bcache/001               |  32 +++++
 tests/bcache/001.out           |   1 +
 tests/bcache/rc                | 259 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 308 insertions(+)
---
base-commit: e387a7e0169cc012eb6a7140a0561d2901c92a76
change-id: 20260120-bcache-35ec7368c8f4

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

