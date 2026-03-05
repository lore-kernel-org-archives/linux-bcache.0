Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC7396D19
	for <linux-bcache@vger.kernel.org>; Thu,  5 Mar 2026 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772722925; cv=none; b=fe0CJjq6BOluJD5f1VrgNoe4SJ4nNx6deTvXehNBYeFZqEjvQ2G9grgr9g5e9nzraqgaOOgVUJ3w0axScVMYmwHtfBCdpRqM3ndaaAtGRpGj4B0NraVW/MThDqxnKCy8cWgJ5YqKwl02AH7lzbHsSlHKvElWwDHU5S79mKNvtpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772722925; c=relaxed/simple;
	bh=Ae2N++dbOdjQGpsx2NiT5jHVY4JMX2Php0P3EY0Ai84=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=VyqEtrUXmWBritSN8h7KlhUJKj6skAvs5ZpmozzDHZI+NKn1WZYHCKGRMy4HRmsX/WkCvszNoXFEXsQXQOklEPJcPghfPVpGJ70GiQbMOF2JpkJxdBmqvQEFDyaJesn08ymr/UGZbVpWh1h4M4un9wKkYzpVybvJAgnUAv2q6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0g0Z/UrX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rfQfJtI3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0g0Z/UrX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rfQfJtI3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0g0Z/UrX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rfQfJtI3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0g0Z/UrX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rfQfJtI3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE32E5BD1F;
	Thu,  5 Mar 2026 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=0g0Z/UrXuyKFPW2U2hBfBmPUN+xK8ISxSeixQphVlEWmn5MbhV/8j1e+T37A5jMgCC4nUD
	S6qFtAOES2vt508NObUzJ6nsRv9CUSJe0AxD87ckqJR/Df+PfsssSG1CiU0JUk/KghfOg7
	DlsrpTQI5rtwlE6fjJKRau++sobhihI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=rfQfJtI3aoeD0sQs4U0bGmxWyAurEeJsi7XgpbEvW/7RU4U0mOfYDrWIFmI5rMa76Dfoxf
	7h/L5aZRkmbxz3AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=0g0Z/UrXuyKFPW2U2hBfBmPUN+xK8ISxSeixQphVlEWmn5MbhV/8j1e+T37A5jMgCC4nUD
	S6qFtAOES2vt508NObUzJ6nsRv9CUSJe0AxD87ckqJR/Df+PfsssSG1CiU0JUk/KghfOg7
	DlsrpTQI5rtwlE6fjJKRau++sobhihI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=rfQfJtI3aoeD0sQs4U0bGmxWyAurEeJsi7XgpbEvW/7RU4U0mOfYDrWIFmI5rMa76Dfoxf
	7h/L5aZRkmbxz3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 958583EA77;
	Thu,  5 Mar 2026 15:02:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ERTpIumaqWmvGQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 05 Mar 2026 15:02:01 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 05 Mar 2026 16:01:46 +0100
Subject: [PATCH blktests v5 3/3] doc: document how to configure bcache
 tests
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-bcache-v5-3-04cd4c9080d7@suse.de>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
In-Reply-To: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

Add a bcache entry in running-tests which explains how to configure
blktests for the bcache tests.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/running-tests.md | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/running-tests.md b/Documentation/running-tests.md
index f9da042bb3a0..7d935aad3331 100644
--- a/Documentation/running-tests.md
+++ b/Documentation/running-tests.md
@@ -189,6 +189,16 @@ THROTL_BLKDEV_TYPES="sdebug" ./check throtl/
 THROTL_BLKDEV_TYPES="nullb sdebug" ./check throtl/
 ```
 
+### Bcache test configuration
+
+The bcache tests require multiple devices to run simultaneously. By default,
+blktests run each test case for each device in TEST_DEVS. This behavior
+prevents testing with multiple devices. The TEST_CASE_DEV_ARRAY resolves this by
+enabling multiple device configurations per test. Bcache tests need at
+least three devices, which can be specified in your configuration as follows:
+
+TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"
+
 ### Normal user
 
 To run test cases which require normal user privilege, prepare a user and

-- 
2.53.0

