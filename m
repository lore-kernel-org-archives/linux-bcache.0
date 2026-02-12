Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF067E110
	for <linux-bcache@vger.kernel.org>; Thu, 12 Feb 2026 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770909841; cv=none; b=o4XPbhPVJnVb6D5LOS4pDWsfFT9puBnUVlpXrGwWIKX52gpo2NzRucM6BP2GHDVbcXc/A0FQ+EZhobhllhWZjXuU4+UhlcHPPZ06+vsK7OtwLWVrys3z96b7vh/TJEkIk7xpTEagzvH3noFQiUr3Va+lTdRAqtJdLPAHzUP6xAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770909841; c=relaxed/simple;
	bh=1pExaZo36klY5a3e+MP/b9mK7QWK+odPqE6HrN+Bd7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=AKbfBgG73WGtPPlCp9Dtvxc3sAGKhzB/ZsAbSI25AY8ZIbbdESBDh9f5S3+/LhtZVTiEU8I+IBA3/MZIVoBotalrkWDz9uFV9B1Epv4YzJ7FA5k5AGj29jEzTttg+VK24doIdqCXeTJRjO7AF7XrPL145X3JBTLDx3yaE1sJhYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TzoAn4aW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tN8QPhLw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TzoAn4aW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tN8QPhLw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TzoAn4aW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tN8QPhLw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TzoAn4aW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tN8QPhLw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22DFC5BDB5;
	Thu, 12 Feb 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBQDpBUIzTHOJMqgxNGcDx1zkA4pCK/kF2MfQb7QrGA=;
	b=TzoAn4aWRl7QDsL9AVrF+SiUpsORCUUeS3lHLSKW3vRm1aWdSsmoa/ORrr1I+mm40rBWIW
	5QcWXaRXm9zoKlnDB5vUCMDHFH+yBxYHpchKn+/qIeFP6FXpg82cS9fb2tbDNSzOeECwnk
	ELP20npUEP0x+jdqaRPQc+AxrlWVr/A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBQDpBUIzTHOJMqgxNGcDx1zkA4pCK/kF2MfQb7QrGA=;
	b=tN8QPhLwJBlHbUA0paJ9VSJLTWayZxSAP00EYxy2iFLaauE4w5O4prFxhVXg1EFExrs8kw
	o5RKNBFCOw9OcAAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TzoAn4aW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tN8QPhLw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBQDpBUIzTHOJMqgxNGcDx1zkA4pCK/kF2MfQb7QrGA=;
	b=TzoAn4aWRl7QDsL9AVrF+SiUpsORCUUeS3lHLSKW3vRm1aWdSsmoa/ORrr1I+mm40rBWIW
	5QcWXaRXm9zoKlnDB5vUCMDHFH+yBxYHpchKn+/qIeFP6FXpg82cS9fb2tbDNSzOeECwnk
	ELP20npUEP0x+jdqaRPQc+AxrlWVr/A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBQDpBUIzTHOJMqgxNGcDx1zkA4pCK/kF2MfQb7QrGA=;
	b=tN8QPhLwJBlHbUA0paJ9VSJLTWayZxSAP00EYxy2iFLaauE4w5O4prFxhVXg1EFExrs8kw
	o5RKNBFCOw9OcAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CF8A3EA62;
	Thu, 12 Feb 2026 15:23:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G+ciJYfwjWn1LAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 12 Feb 2026 15:23:51 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 12 Feb 2026 16:23:32 +0100
Subject: [PATCH blktests v4 2/3] bcache: add bcache/002
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-bcache-v4-2-215f3fde1c84@suse.de>
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
X-Rspamd-Queue-Id: 22DFC5BDB5
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Add test case from Stephen Zhang [1].

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 tests/bcache/002     | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/bcache/002.out |  2 ++
 2 files changed, 64 insertions(+)

diff --git a/tests/bcache/002 b/tests/bcache/002
new file mode 100755
index 000000000000..c27178a90c2d
--- /dev/null
+++ b/tests/bcache/002
@@ -0,0 +1,62 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2026 Daniel Wagner, SUSE Labs
+#
+# Test based on Stephen Zhang <starzhangzsd@gmail.com> test case
+# https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/#t
+#
+# Test bcache for bio leaks in clone
+
+. tests/bcache/rc
+
+DESCRIPTION="test bcache for bio leaks in clone"
+
+requires() {
+	_have_fio
+	_have_program iostat
+}
+
+test_device_array() {
+	echo "Running ${TEST_NAME}"
+
+	if [[ ${#TEST_DEV_ARRAY[@]} -lt 2 ]]; then
+		SKIP_REASONS+=("requires at least 2 devices")
+		return 1
+	fi
+
+	_setup_bcache "${TEST_DEV_ARRAY[@]}"
+
+	local bcache_nodes bcache_dev bdev_name fio_pid
+
+	mapfile -t bcache_nodes < <(_create_bcache \
+				--cache "${TEST_DEV_ARRAY[0]##*/}" \
+				--bdev "${TEST_DEV_ARRAY[1]##*/}" \
+				--writeback)
+
+	bcache_dev="${bcache_nodes[0]}"
+	bdev_name="$(basename "${bcache_dev}")"
+	echo 1 > /sys/block/"${bdev_name}"/bcache/detach
+
+	state="$(cat /sys/block/"${bdev_name}"/bcache/state)"
+	echo "Device state: ${state}"
+
+	_run_fio_rand_io --filename="${bcache_dev}" --time_base \
+			--runtime=30 >> "$FULL" 2>&1 &
+	fio_pid=$!
+
+	sleep 5
+
+	local stats_line util
+	stats_line=$(iostat -x 1 2 "${bdev_name}" | grep -w "${bdev_name}" | tail -n 1)
+	util="$(echo "${stats_line}" | awk '{print $NF}')"
+
+	if (( $(echo "${util} > 1.0" | bc -l) )); then
+		echo "ERROR: Accounting leak detected!"
+	fi
+
+	{ pkill -f "fio.*${bcache_dev}"; wait "${fio_pid}"; } &> /dev/null
+
+	_remove_bcache --bcache "${bcache_nodes[@]}" \
+			--cache "${TEST_DEV_ARRAY[0]##*/}" \
+			--bdev "${TEST_DEV_ARRAY[1]##*/}"
+}
diff --git a/tests/bcache/002.out b/tests/bcache/002.out
new file mode 100644
index 000000000000..529c1a90b135
--- /dev/null
+++ b/tests/bcache/002.out
@@ -0,0 +1,2 @@
+Running bcache/002
+Device state: no cache

-- 
2.53.0

