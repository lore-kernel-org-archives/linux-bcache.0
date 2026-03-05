Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C43BA23E
	for <linux-bcache@vger.kernel.org>; Thu,  5 Mar 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772722931; cv=none; b=CfoH0XAbmUSA+lI9htJCcSwmqvEeY/fPLHV+lSg7+dE9f/vpZXojucxAtT8cgE6qWHUb1bsM6wUA6ka18qQ2bX9GsmGMLnZDriNJZA44ATwrzzy3oaj2hUasJrXoDJXT1muwJYlitZqjLIbXMOhbeR3ehhHn39n6QnyA92RIcD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772722931; c=relaxed/simple;
	bh=+VSd2lSvmpGl6zHlpeupAt+eJJ1u5dZSGJhcsYfouRI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=K8kslVF0f3eiCt6jcCUVttVekG8SvJKOcag4ciTaXPqG96ri7zZsoLzyILfJBhR6/Jwhzp8XbldmEVsFxz/HhT/YROfKE2qpmiRr2fxQY2Q5hMQsrl9whWZqLbwg/7095ClqgJ0+A697wywQmwYYOYApij6IMpPWWCFetz2p8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R3+BQqFi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W/NFye1N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zupZKrq2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e9BNG1s9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R3+BQqFi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W/NFye1N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zupZKrq2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e9BNG1s9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E91CD5BCF7;
	Thu,  5 Mar 2026 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vuutZeVn8bVu7bojmjvdGMy367H6knkuSuQ3UvRO6U=;
	b=R3+BQqFiKMEv/XjHU/U2TErFnhChfsm5ajX67A90BInxychve4Hn6vGu9luSOFetzpzb7l
	jIWYBOJwmn0wPY4sby/IYejaFSOjNOOIshkaRLW1dnTY4ojUiZwrqHUIl7XXTjhOsKwZ80
	HI3MrUZaw/S6mGo1rW9Re31ItDKUggA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vuutZeVn8bVu7bojmjvdGMy367H6knkuSuQ3UvRO6U=;
	b=W/NFye1Ne7wfA3dYIEojXpi3kq2h73LHJSG0RyNG276nAbSqroPZoALcdMGlK+csWXJkpa
	HWaOYFp/XfkHTlDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772722920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vuutZeVn8bVu7bojmjvdGMy367H6knkuSuQ3UvRO6U=;
	b=zupZKrq2OeHLZiQc0nCdM0ujLcwCl2FktSaCY1S46MbrEOWMBz8qAmOXAGtp/Ud3xqOpDN
	qNVhdzaoCgnlRcokvKVe6SIoKNZq3hIVzsm6nHzV92iZY3lwZwxcgeftszKvPLAt472mlG
	+seo9HZoiRDLaUf1m8S7kdf95Qipmg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772722920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vuutZeVn8bVu7bojmjvdGMy367H6knkuSuQ3UvRO6U=;
	b=e9BNG1s93tujZkMvE6uVeZeM3MLIm5K2qePZNsOme9WUz7ps3iA6KiNaRuRYroT6yzW3mU
	6yFHJpjR1QZFqrAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D13733EA76;
	Thu,  5 Mar 2026 15:02:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7DdnMeiaqWmsGQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 05 Mar 2026 15:02:00 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 05 Mar 2026 16:01:45 +0100
Subject: [PATCH blktests v5 2/3] bcache: add bcache/002
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Add test case from Stephen Zhang [1][2], which is

1. Wait for fio to complete (wait $fio_pid)
2. Wait a few seconds for I/O to drain
3. Then check the utilization

If utilization is still > 0% after I/O completes, then there's a real
accounting leak.

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
[2] https://lore.kernel.org/all/CANubcdU92Uv7wNdZH357LLTnfwPouekXNTPSjHnzYzK99-eZ9w@mail.gmail.com

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 tests/bcache/002     | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/bcache/002.out |  2 ++
 2 files changed, 80 insertions(+)

diff --git a/tests/bcache/002 b/tests/bcache/002
new file mode 100755
index 000000000000..a50722ff9e0e
--- /dev/null
+++ b/tests/bcache/002
@@ -0,0 +1,78 @@
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
+}
+
+read_ticks() {
+	local bdev_name="$1"
+	local stat_file
+
+	stat_file="/sys/block/${bdev_name}/stat"
+	awk '{print $10}' "$stat_file"
+}
+
+get_utilization() {
+	local bdev_name="$1"
+	local t1 t2
+
+	t1="$(read_ticks ${bdev_name})"
+	sleep 1
+	t2="$(read_ticks ${bdev_name})"
+
+	# (t2 - t1) is the ms busy. Over 1000ms, (delta/10) gives percentage.
+	echo "scale=2; ($t2 - $t1) / 10" | bc
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
+	local -a bcache_nodes
+	local bcache_dev bdev_name fio_pid state
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
+			--runtime=10 >> "$FULL" 2>&1 
+	
+	sleep 5
+
+	local util
+	util="$(get_utilization "${bdev_name}")"
+
+	if (( $(echo "${util} > 1.0" | bc --mathlib) )); then
+		echo "ERROR: Accounting leak detected! Current utilization: ${util}%"
+	fi
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

