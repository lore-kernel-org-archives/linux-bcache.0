Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516081C3F0C
	for <linux-bcache@vger.kernel.org>; Thu, 12 Feb 2026 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770909847; cv=none; b=RJQ8ouSgc//jo1FD/hXppVnDz6fdWcDQ0WkSX33v3ZbFTBJ6yEWTOI5x3EXKCuaQzmzpapvuCHbDlxiTlLN9dgBfbRPOiwXWo6ofiJvz5yeESR0/4zIwqiJ3WirU/R0IoMyK+ymxSRXWPYBfu+vYz+DsvyaecpGvkL0WMZMUV8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770909847; c=relaxed/simple;
	bh=Ae2N++dbOdjQGpsx2NiT5jHVY4JMX2Php0P3EY0Ai84=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=jskFZ+MQyI7rFEAXq+uU8W40Bw/jLX0zpB+Ha6LmOMtU1+Z3Bf4Oydy5kpANIV9LKXwrlcN0gGd8GcZ33YV149IgfeZjtqlloZDADdUbTLSuWhrdRpKQg4RPg6PwyWGVO8JCPXuYCwrHBStWYUjW8x593W/dUxAzcnNNT9/xIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nr2gjWTF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PRuE8o/J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nr2gjWTF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PRuE8o/J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nr2gjWTF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PRuE8o/J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nr2gjWTF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PRuE8o/J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A12D5BDF5;
	Thu, 12 Feb 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=Nr2gjWTF322ibflD4m4pHhP7vzG9QNz9F07vCm5Sutz+fFC6W/OrjUevVLxNYbbtewzqVH
	LRoo0PdLk1/3yL+ZAMSVU6e3V916bjZWEruHLabgYrze01w8hQUPTPTySxClH2EhJXSBV2
	+M+d/6nRGoCGFYuBCGT13fg4nNSHeNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=PRuE8o/JBhGjiRK9/rmp445SwcFrcinB1bpBdSvpxbS6SuFgA8DMM6kUoQ7pHDubM+6BEH
	uU/xKdhb3lWQUcBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=Nr2gjWTF322ibflD4m4pHhP7vzG9QNz9F07vCm5Sutz+fFC6W/OrjUevVLxNYbbtewzqVH
	LRoo0PdLk1/3yL+ZAMSVU6e3V916bjZWEruHLabgYrze01w8hQUPTPTySxClH2EhJXSBV2
	+M+d/6nRGoCGFYuBCGT13fg4nNSHeNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0y8C2+BwX136Xn8XL84qBWd0BiUIMubhkk6hqkM0Jc=;
	b=PRuE8o/JBhGjiRK9/rmp445SwcFrcinB1bpBdSvpxbS6SuFgA8DMM6kUoQ7pHDubM+6BEH
	uU/xKdhb3lWQUcBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C12F3EA62;
	Thu, 12 Feb 2026 15:23:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UHyrBY/wjWm4LgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 12 Feb 2026 15:23:59 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 12 Feb 2026 16:23:33 +0100
Subject: [PATCH blktests v4 3/3] doc: document how to configure bcache
 tests
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-bcache-v4-3-215f3fde1c84@suse.de>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
In-Reply-To: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

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

