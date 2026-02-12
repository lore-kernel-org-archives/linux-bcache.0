Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB251FBC8C
	for <linux-bcache@vger.kernel.org>; Thu, 12 Feb 2026 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770909830; cv=none; b=ZVXXrvIRG87LHtJqqhXfspxJqbZr8mWssAHVtAYwszHSOGUvFkCwLvGwSgGf+L2XCFV+3vLcwB6r+VIe37gLgHiK4qyryXYUQCf6LvGw00akbdpaRfAy4I2xSa6smLVhMe+7bmJk2t2AeevKmWoZF3l2O9URSt0uFuwJ8sRSeoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770909830; c=relaxed/simple;
	bh=oq1RV8vmEW+wsEdfwCuojy7u0J5S7Vw4RazMQn1VjHs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=k1SgH91zmj4vhjFM27iAONMmM2V5k7fliuqwM0lW9RXFFR1NM776RLVZF8b3lFuDeUwlqQr6y+XjJvcr30+tIKtO+eztk9lw3MCSYhy5Zq9m+6fonyJ9AvvSdAQSHmdng6c4gNniPwavexp1Q0W7ArhHhzNayEuuE43Xm7/3VxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d+Bs/3JW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MsHPp0sP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d2x7Y8tY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vw29r+4B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d+Bs/3JW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MsHPp0sP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d2x7Y8tY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vw29r+4B"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01D013E6CE;
	Thu, 12 Feb 2026 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wwNVz192v3URqIaCsnTslVz2YPDKzTOQFcIOsBCgnkM=;
	b=d+Bs/3JW058pi7sOnu080TaSLAMNkke5QGYC7xyVuPcYljV7v9uremksNEaFS20ZDFINx5
	HzEogEB/Li2r4CBH1lk+kflN2wtqxTofIPyAGdMESer5Y/2vxEre7/FVONpcGyGaci7H+b
	Y5sE4L8/pxtKUFjrZ1+fUjJU4FKGhCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wwNVz192v3URqIaCsnTslVz2YPDKzTOQFcIOsBCgnkM=;
	b=MsHPp0sPVENo3VOVIc1b29aIlnsmwaVLbx+6d1fU1NiawxaqX+owBFJPhoi/ezALSs3rFn
	/sKP0sDWIB2niBDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d2x7Y8tY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vw29r+4B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wwNVz192v3URqIaCsnTslVz2YPDKzTOQFcIOsBCgnkM=;
	b=d2x7Y8tYGabZUjaizggA0wVXs0Zo0COvgmUrcj8GZ9iN59uqw21RGRMsP6QkIU5Ol+hKgT
	+R5z3bYPXDP4MU4+T/84h19YVJveEYqW3fsov3d5vch7ZJu7TsukalJ6dEH0fJy3be30p7
	I6wjUvUCTMgdpDBXKalK89voYwzQdM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wwNVz192v3URqIaCsnTslVz2YPDKzTOQFcIOsBCgnkM=;
	b=vw29r+4Be+12bIPk/dD8BaQnrM0eWIV0N4SvCkMyE/VxJliw2Vk08zPiMS8fC16xhWPAiv
	R8ZSmbRRR5ntf4BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82AC13EA62;
	Thu, 12 Feb 2026 15:23:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Poq9Hn/wjWnlKgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 12 Feb 2026 15:23:43 +0000
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH blktests v4 0/3] bcache: add initial test cases
Date: Thu, 12 Feb 2026 16:23:30 +0100
Message-Id: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XMTQ6CMBCG4auQrq3pTH9EV97DuCjtIN2AabXRE
 O5uYYEYl99knndkiWKgxE7VyCLlkMLQl6F2FXOd7W/Egy+boUAjAAVvnHUdcanJHaSpXd0qVp7
 vkdrwWkKXa9ldSI8hvpduhvn6l8jAgetj04oGvQIlzumZaO+JzYGMWwQrQl4CaGwLtSYj7S+SW
 4QrkgWhE+hBW6WF/KJpmj7T/tKSBAEAAA==
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
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 01D013E6CE
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

I've updated the v3 version with the feedback from Shinichiro for v2.
Shinichiro, please note I did rewrite some of the logic in v3, thus some of your
comments didn't apply. But hopefully I don't made a big mess :)
 
Cheers,
Daniel

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
 

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
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
 tests/bcache/002               |  62 +++++++
 tests/bcache/002.out           |   2 +
 tests/bcache/rc                | 375 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 496 insertions(+)
---
base-commit: e387a7e0169cc012eb6a7140a0561d2901c92a76
change-id: 20260120-bcache-35ec7368c8f4

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

