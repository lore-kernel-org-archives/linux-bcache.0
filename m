Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2483D261B92
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769075852; cv=none; b=g7ohLI+6/lOtIO7QQuXDQbu7jzn51MNrG+oskFWRIVGwTfM/d0kS8HfpeO9CZF5n0v1qISUS2ZI0AktorZo4XFSFm+I7sULrpzeu5A4uSBp+y91NqJk+GM269rNrwHobu7YEGNGL0PKTJAzlP0KQ2WjmyApxmkglf2Tlf13/cak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769075852; c=relaxed/simple;
	bh=WR24rVlPKskuQG4aQ/syKb5Fca0gz1lw+HvLLHHcH+Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=pjUhmkbbwvWGCOEJeTnQM/MG2c8c0EdWK24NNmvJH7R2+qnacGfImZFhI9wKTuLDSc9+FW57eET4PcPeg4U7fRKgsXyK4XdEQkhPP5cOFrOxOwfRhe2F94X1o/7pP9XILOsOG4ggM+maD7veOSLI73lA/Vhebm6gnbyPQNf1EYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eTiGNdSB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WLvGKAWR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eTiGNdSB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WLvGKAWR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eTiGNdSB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WLvGKAWR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eTiGNdSB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WLvGKAWR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F0D55BCCB;
	Thu, 22 Jan 2026 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjEOYNPNl/uRPBXRzOyBtLVc1i1/cXqtUW300ha+FqY=;
	b=eTiGNdSBUXwD8MA3h0B7L5ZdoInDi/FpmE9noyOUrEqFypN1njyuqn5m2nhmDH4WTwd803
	HhvuztfK4quUO44DW4x8mDgoY4Mv3KoBkHWjsPVvhL+vT1SHA8ztS0umsZRl8krg4D85pd
	GQ7rBorpxjDB01lZnLppYdyBMzjv1OY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjEOYNPNl/uRPBXRzOyBtLVc1i1/cXqtUW300ha+FqY=;
	b=WLvGKAWRQM1dN5IvWadnJQiW0dhrq00/HfGhtkEgMPWBqV2mSQGQc6HKAilaB53pZlUq00
	z7w5K0hfV68M+ABA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eTiGNdSB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WLvGKAWR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjEOYNPNl/uRPBXRzOyBtLVc1i1/cXqtUW300ha+FqY=;
	b=eTiGNdSBUXwD8MA3h0B7L5ZdoInDi/FpmE9noyOUrEqFypN1njyuqn5m2nhmDH4WTwd803
	HhvuztfK4quUO44DW4x8mDgoY4Mv3KoBkHWjsPVvhL+vT1SHA8ztS0umsZRl8krg4D85pd
	GQ7rBorpxjDB01lZnLppYdyBMzjv1OY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjEOYNPNl/uRPBXRzOyBtLVc1i1/cXqtUW300ha+FqY=;
	b=WLvGKAWRQM1dN5IvWadnJQiW0dhrq00/HfGhtkEgMPWBqV2mSQGQc6HKAilaB53pZlUq00
	z7w5K0hfV68M+ABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 246BA13978;
	Thu, 22 Jan 2026 09:57:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VTftB4f0cWnZGAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 22 Jan 2026 09:57:27 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 22 Jan 2026 10:57:13 +0100
Subject: [PATCH blktests v3 2/3] bcache: add bcache/002
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-bcache-v3-2-2c02d15a4503@suse.de>
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
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3F0D55BCCB
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Add test case from Stephen Zhang [1].

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 tests/bcache/002     | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/bcache/002.out |  2 ++
 2 files changed, 65 insertions(+)

diff --git a/tests/bcache/002 b/tests/bcache/002
new file mode 100644
index 000000000000..04892667ad1b
--- /dev/null
+++ b/tests/bcache/002
@@ -0,0 +1,63 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
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
+	_bcache_requires
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
2.52.0

