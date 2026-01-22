Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F088355044
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769075859; cv=none; b=fBbp+U8VvXmqZkpUznAXRx5QHMxC6oFFqJV0xVm58sCfi7nQVWYGWkIarJSUDVHj2ly/liPx5IOIowCFwejRZjX58nvIYRDihjvRoHyL1cB3WJ35SlooT41nJcQbQef06JdQ8taAxv3fTOH5/EviVHO+Cada8VrIRSCA+mV2HOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769075859; c=relaxed/simple;
	bh=NLQWcszwwPVj7IFmO9rVoI3ra+NeqadPxyhReSokYvA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=hH+gjLdO+Q7a0P4PS1BLTtXYeesOFF+oUnV/xQWvFWim968WywincF1ifVEk+A7hV+xov/vW5dRda8lv06BvWrB+3C3CFLnXm8+0KZuwbFWLgCANqHicjbPEJePCvnlXbLrz8Yux7rC/rg/0DNjKXXDAyZdd+U2HP+/e4oz4W2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QxkieiUg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4a0jJRue; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CqRkaUAb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FMbfyeDl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QxkieiUg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4a0jJRue";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CqRkaUAb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FMbfyeDl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D54C05BD00;
	Thu, 22 Jan 2026 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=QxkieiUgQB++vxphXQ8M2MIG3wjMt6GSMhLqueb1FJy9mGWjatfHSEZp7U/IWzahd0VEvK
	wgYLPPOHTXafddc3MGgjIVPM7lqy3m5VFDmPu+NYttnPKMJhYHaUdCIVaSe944kaincxJy
	9nVoVGefpkIFAe2gIp5SvPTsqDVueB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=4a0jJRueAboGXt/KUhrjp/FF7oWJmUsRESOAYVPwREhL0ukVSBbgonIls1bAkM7KplNejy
	YnWUn4QXza0OG5CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CqRkaUAb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FMbfyeDl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=CqRkaUAbmqTVVA5nztTSzXKHmwlsx1b2V9KFJ+2pLq9z3ePuCJJBFLRQT861K+c2Ni5xa9
	V15wiUxU7/FLFZfzcJcwBAbX7KbD3rWb/n2aODLwtRsTyXTmRD7DVh6Zx6hi1uc3OvQ7D7
	3bpkONnAsWLl9nEQLLxAKUXiADM+GDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=FMbfyeDlPBFd9xa1tBa7dC1JoOZ8k2t44UyIqlSUK9hdrqGqyBsMwy6qEcfSoyorJW9O7h
	57P5LrkFwBIXTRAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BACC113978;
	Thu, 22 Jan 2026 09:57:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /UuiLIn0cWnfGAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 22 Jan 2026 09:57:29 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 22 Jan 2026 10:57:14 +0100
Subject: [PATCH blktests v3 3/3] doc: document how to configure bcache
 tests
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-bcache-v3-3-2c02d15a4503@suse.de>
References: <20260122-bcache-v3-0-2c02d15a4503@suse.de>
In-Reply-To: <20260122-bcache-v3-0-2c02d15a4503@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLoutxgtpbe87j1mhictwxkqba)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: D54C05BD00
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

Add a bcache entry in running-tests which explains how to configure
blktests for the bcache tests.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/running-tests.md | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/running-tests.md b/Documentation/running-tests.md
index f9da042bb3a0..c4abc6767cd0 100644
--- a/Documentation/running-tests.md
+++ b/Documentation/running-tests.md
@@ -189,6 +189,22 @@ THROTL_BLKDEV_TYPES="sdebug" ./check throtl/
 THROTL_BLKDEV_TYPES="nullb sdebug" ./check throtl/
 ```
 
+### bcache test configuration
+
+The bcache tests require multiple devices to run simultaneously. By default,
+blktests executes each test case iteratively for every individual device listed
+in TEST_DEVS. This standard behavior makes it impossible to pass a group of
+devices into a single test via TEST_DEVS.
+
+To solve this, the TEST_CASE_DEV_ARRAY was introduced. This allows for custom
+device configurations on a per-test basis. For bcache tests, a minimum of three
+devices is required. Configuration Example
+
+Add the following to your configuration to define the devices used for all
+bcache tests:
+
+TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"
+
 ### Normal user
 
 To run test cases which require normal user privilege, prepare a user and

-- 
2.52.0

