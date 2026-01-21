Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D748AE04
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769006205; cv=none; b=dhuKSkXjpDntoCS9Ml3dtoc6MSIxJO0urbldST2nSWyAWaWW2v9hvxjKP6HTJMWThbtYzXYQwWmAOQcyLsUZgR30XYrjhLBVnQ9jyoXRjcW0Hn56GqpUAZxzwv2pyrXLOSCRvSZv1x/D3lE1qU6bY7NgZ4vsCPmLnQgNTOjXQ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769006205; c=relaxed/simple;
	bh=NLQWcszwwPVj7IFmO9rVoI3ra+NeqadPxyhReSokYvA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=PIC6PDpTEMgeu93L4KRSYNsm3byc0a19NeNSZgEdN4hn7ln50xE8zSVfD/L3o+8PCmYVTXeChlUyW6v2HyoYD2+deg2sEBQju4vv3lbv9sH36xWFIr+lzIrg0dHsVWlxsyL+4h5Y2xSZ+XxF3MxA8CRiS6QDTacS+KUdWsSKX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dP+S1rh6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2idHcTA+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P5FzQAhB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CiLjokEa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dP+S1rh6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2idHcTA+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P5FzQAhB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CiLjokEa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E58075BD15;
	Wed, 21 Jan 2026 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=dP+S1rh6tjS5NflaCb1BIt/X1sI6dXIohs3PqeujDOEfk6A0TLxy1bfAwEnjUZ/EkOKOFN
	2qHC5MgqunzzGVAYiTx5s0sM4KV9bcDxqxPjF7uYCf+PFKe7YwRHIEnZ+CV7lVsPy9mOju
	41SycrMMaqv07AIQxgaL7zkEngEgdGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=2idHcTA+Zyot37XvpF4knkBNkZi52+Pb2ISdOaV9UjP21TMCrjwyIa3O/6P6WjxLUpNaP7
	5h4DjATY34NtYxCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=P5FzQAhBeVNNQ/zf0O9/2MBv+2L13I5mTRK07zexHDSeCS37+AMna/MgMyPOO/qO1RytIB
	OVAXA5spUHnsI8p9jSeqio+lhXGS+ekYLeIc/DtbhTe8CXuBYSZ00ZSVMzJWe8Zie9ddkX
	B69x2v2RD+Vb6XAgdVPVBK5k3UEMnFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZE7ky8QMQgbf4ZqVwA9QPknpSJehBT8c2sDK/t2HKk=;
	b=CiLjokEa5YE2IkULKfcnEJczeaf55rgKK/iZjgGe6i9cRtT8IY/3K7tgSRLtkexrYmxr83
	pqY3w3zwZ8L2YtDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D65FA3EA63;
	Wed, 21 Jan 2026 14:36:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8BxeM3nkcGnxcgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 14:36:41 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Wed, 21 Jan 2026 15:36:23 +0100
Subject: [PATCH blktests v2 2/2] doc: document how to configure bcache
 tests
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-bcache-v2-2-b26af185e63a@suse.de>
References: <20260121-bcache-v2-0-b26af185e63a@suse.de>
In-Reply-To: <20260121-bcache-v2-0-b26af185e63a@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO

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

