Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18673BA238
	for <linux-bcache@vger.kernel.org>; Thu,  5 Mar 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772722931; cv=none; b=K3j8URkbow6eGc1ZMFqrcb798fce/NGfn9BvB/xMs/yHmH6zu2RvjUcgMBjoUjDvTvlDU31hLvY32fBeCAGq+NQa6HckpI/kAJhbaQAZf904LQUcHpvnXHl/4OiukNDfPHEATptxzrYd6KT5GFxSSBwSg5ZbJhqnWF4Hg95+dcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772722931; c=relaxed/simple;
	bh=03KKhwo81ogb/ihT2sjeKrp7wpaJtGWYVmlMk3mXaEw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=qOHo7I9Q+jmmeNekHO/ATRsGqQot0Ux0VSOurEyuLCn6ieQWqeS7zxrgG8thSftCQrHwQk4qu9iQIfm91c4OUWZPnLfiYua+bIOjjBiNtpGmoz/suQaBoKamZovGyVNPp5aUR+6kUVIOKASumsKZhCSouxMVxYnFNNFJeZbLng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YVuw6QFm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R0eANETg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RSlAr4YZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+xqh6Dpx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YVuw6QFm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R0eANETg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RSlAr4YZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+xqh6Dpx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DD143F8AB;
	Thu,  5 Mar 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ycz1bzdGN+oM/uU/EP4ET70ULCRLZ2XcQjUuKSUdiQE=;
	b=YVuw6QFmQr21hdXJLT0Uj6+EEYS3zDmUrKg6ltc4V6Yk2CHyq/qnsEJlBvtd2GXb2YQQFy
	ZDus86fyJtLjoxp2b4KnfwjKMKgKlt92xV9YDSqYrqANeA03Jk/f8Ld+tfwakQT7DELDvW
	1r7RiK2ytHHmoVd4ZZGSomGM8ciyX18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722923;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ycz1bzdGN+oM/uU/EP4ET70ULCRLZ2XcQjUuKSUdiQE=;
	b=R0eANETgYnWEluiXMWnOvov2cjtw46wrXKpLe+X7XlJma7+xHs9Nn4hwNCfWVLfSPRBeGT
	qloCYmBneIv9h4Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RSlAr4YZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+xqh6Dpx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ycz1bzdGN+oM/uU/EP4ET70ULCRLZ2XcQjUuKSUdiQE=;
	b=RSlAr4YZr0Fgztpo14WCbYpsYvagP41SUTkNXQbPMPR+zapbA1OoN0Hx2tNmbnXIQqfyD1
	qfBBfUre6+QGN+SaJ8OrIxZe83va32jiw96tkv52VUzFmueOhUt7sTOo8d0ji8FvuwduBb
	kWzHm/Ugcu9aRM7rb+Qq7EETGTFLvXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ycz1bzdGN+oM/uU/EP4ET70ULCRLZ2XcQjUuKSUdiQE=;
	b=+xqh6DpxqSWbQPMSZ3D6EXadyRaW0xoFF97WZtekHfjhWK0/lpugeLoOiFV5Ys7mjrA+Qe
	ajvG5lN99eoUINAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 489243EA68;
	Thu,  5 Mar 2026 15:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kBgMEOaaqWmjGQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 05 Mar 2026 15:01:58 +0000
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH blktests v5 0/3] bcache: add initial test cases
Date: Thu, 05 Mar 2026 16:01:43 +0100
Message-Id: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XMTQ7CIBCG4as0rMUwA9TqynsYFxQGy6Y1oI2m6
 d2lXfQnLr/JPO/AEsVAiV2KgUXqQwpdm4c+FMw2pn0QDy5vhgJLASh4bY1tiEtN9iTLylZesfz
 8jOTDZw7d7nk3Ib26+J27PUzXv0QPHLg+117U6BQocU3vREdHbAr0uEWwIOQ5gKXxUGkqpdkju
 UW4IJkRWoEOtFFayD1SK0JYkZoQaC+9I7CVWtE4jj8xhlOtOQEAAA==
X-Change-ID: 20260120-bcache-35ec7368c8f4
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.de:mid,suse.de:dkim,suse.de:email,linux.dev:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5DD143F8AB

I've addressed all comments from Shinichiro. 

bcache/002 is not using iostat anymore, instead it reads directly from sysfs.
Also updated this tests according Stephen's feedback. I didn't test yet with an
older version.

Unfortunatly, I was not able to reproduce the "nvme?n1" file in my setup with:

  TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"
  TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc /dev/nvme1n1"

Not sure where this is coming from.

Cheers,
Daniel
 
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Coly Li <colyli@fnnas.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>

--- Changes in v5:
- Addressed all comments from Shinichiro
- Updated bcache/002 according Stepen's feedback, though reduced
  fio's runtime to 10s
- Link to v4: https://patch.msgid.link/20260212-bcache-v4-0-215f3fde1c84@suse.de

Changes in v4:
- changed file mode to 755 for 001 and 002
- changed license to GPL-3.0+
- use group_requires
- fixed whitespace damage
- dropped unnecessary '|| true'
- added 'local' for local variables
- added wait loop for register interface to show up
- updated documentation
- Link to v3: https://patch.msgid.link/20260122-bcache-v3-0-2c02d15a4503@suse.de

Changes in v3:
- add bcache/002
- return created bcache devices to tests case
- made cleanup more robust (handling detached cache)
- track all resources correctly
- operatoe only in final cleanup on known devices
- Link to v2: https://patch.msgid.link/20260121-bcache-v2-0-b26af185e63a@suse.de

Changes in v2:
- fixed whitespace damage
- added documentation on how to configure for bcache tests
- do registering explicitly
- made disk wiping more robust
- Link to v1: https://patch.msgid.link/20260120-bcache-v1-1-59bf0b2d4140@suse.de

---
Daniel Wagner (3):
      bcache: add bcache/001
      bcache: add bcache/002
      doc: document how to configure bcache tests

 Documentation/running-tests.md |  10 ++
 tests/bcache/001               |  44 +++++
 tests/bcache/001.out           |   3 +
 tests/bcache/002               |  78 +++++++++
 tests/bcache/002.out           |   2 +
 tests/bcache/rc                | 377 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 514 insertions(+)
---
base-commit: e387a7e0169cc012eb6a7140a0561d2901c92a76
change-id: 20260120-bcache-35ec7368c8f4

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

