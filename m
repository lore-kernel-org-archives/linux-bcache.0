Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01580318EDE
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769006205; cv=none; b=IPet9Ao2umQvvooZnGRKOq5D+JB53QDY+t9b/GjWrV4SmHTHlLjGAc/ROsLwkGFVf++XOc4kRnqVnu0ustol+fZVBBCB679NwXoAX+eH35IGGNBrvyTODGcKLCEeWBoLobqvf8lMgfGFhaV7G6ouWNjNDD+HbeaJVC8clRXEXgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769006205; c=relaxed/simple;
	bh=J8SdD+Zln4jZNYeN5iuVljM6v9o0D707Z4lN+YvypM0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=iWJBUx3CxCRtni+eFCaN/5P9ElZl6+uDyF/E5QMPRVx0tF1WNdF4w92xF4BcPLGjB8d/gONMx5iv2WJEgkE7Krf64xjbA0uuT68ayhuwk2ORS8OiDZSrdKHQrufph3tzaUSDpNp6rGkaf3ZkP+NZ+pGVGmJDKZ8sPO2zC2wVL1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zj8ZA5dY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mSAiJ+0N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zj8ZA5dY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mSAiJ+0N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zj8ZA5dY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mSAiJ+0N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zj8ZA5dY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mSAiJ+0N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F5B73368F;
	Wed, 21 Jan 2026 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKt7ksVsvd1bOt6+hyDo0C2czjZuAQ7DCzWT2ZdJVMs=;
	b=Zj8ZA5dYHgvCxj85TuxRM+g4Xq+PNQS0/9lNXd5oG/NVcodq4AQoXCTO3aNtI1hVRfZn0o
	QTXDb6eozW0jzhsTnIIzojm378mDK5uD4WHzX+KhHfSpZD7XUIpmpGSdolCeKMuBgykHTS
	zslZ0JEwxQTLxuQBrF/kPST/CIuCiwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKt7ksVsvd1bOt6+hyDo0C2czjZuAQ7DCzWT2ZdJVMs=;
	b=mSAiJ+0Nifp/64rbTguuCtfZr+H2K5wgP0j3GUG6SK6EZfeYNdhTCATVRRFqaIIRqRysU1
	SRuiPZDjTtZCDUCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769006201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKt7ksVsvd1bOt6+hyDo0C2czjZuAQ7DCzWT2ZdJVMs=;
	b=Zj8ZA5dYHgvCxj85TuxRM+g4Xq+PNQS0/9lNXd5oG/NVcodq4AQoXCTO3aNtI1hVRfZn0o
	QTXDb6eozW0jzhsTnIIzojm378mDK5uD4WHzX+KhHfSpZD7XUIpmpGSdolCeKMuBgykHTS
	zslZ0JEwxQTLxuQBrF/kPST/CIuCiwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769006201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKt7ksVsvd1bOt6+hyDo0C2czjZuAQ7DCzWT2ZdJVMs=;
	b=mSAiJ+0Nifp/64rbTguuCtfZr+H2K5wgP0j3GUG6SK6EZfeYNdhTCATVRRFqaIIRqRysU1
	SRuiPZDjTtZCDUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A3AB3EA63;
	Wed, 21 Jan 2026 14:36:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7MaUDXnkcGnjcgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 14:36:41 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Wed, 21 Jan 2026 15:36:22 +0100
Subject: [PATCH blktests v2 1/2] bcache: add bcache/001
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-bcache-v2-1-b26af185e63a@suse.de>
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

So far we are missing tests for bcache. Besides a relative simple
setup/teardown tests add also the corresponding infrastructure. More
tests are to be expected to depend on this.

_create_bcache/_remove_bcache are tracking the resources and if anything
is missing it will complain.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 tests/bcache/001     |  32 +++++++
 tests/bcache/001.out |   1 +
 tests/bcache/rc      | 259 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 292 insertions(+)

diff --git a/tests/bcache/001 b/tests/bcache/001
new file mode 100644
index 000000000000..4a6e01113b6b
--- /dev/null
+++ b/tests/bcache/001
@@ -0,0 +1,32 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Daniel Wagner, SUSE Labs
+#
+# Test bcache setup and teardown
+
+. tests/bcache/rc
+
+DESCRIPTION="test bcache setup and teardown"
+
+requires() {
+	_bcache_requires
+}
+
+test_device_array() {
+	echo "Running ${TEST_NAME}"
+
+	if [[ ${#TEST_DEV_ARRAY[@]} -lt 3 ]]; then
+		SKIP_REASONS+=("requires at least 3 devices")
+		return 1
+	fi
+
+	 _create_bcache \
+		--cache "${TEST_DEV_ARRAY[0]##*/}" \
+		--bdev "${TEST_DEV_ARRAY[1]##*/}"
+	 _remove_bcache
+
+	 _create_bcache \
+		--cache "${TEST_DEV_ARRAY[0]##*/}" \
+		--bdev "${TEST_DEV_ARRAY[1]##*/}" "${TEST_DEV_ARRAY[2]##*/}"
+	 _remove_bcache
+}
diff --git a/tests/bcache/001.out b/tests/bcache/001.out
new file mode 100644
index 000000000000..f890aed2736c
--- /dev/null
+++ b/tests/bcache/001.out
@@ -0,0 +1 @@
+Running bcache/001
diff --git a/tests/bcache/rc b/tests/bcache/rc
new file mode 100644
index 000000000000..3dba6c85b1ee
--- /dev/null
+++ b/tests/bcache/rc
@@ -0,0 +1,259 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Daniel Wagner, SUSE Labs
+
+. common/rc
+
+declare -a BCACHE_DEVS=()
+declare -a BCACHE_BDEVS=()
+declare -a BCACHE_CSETS=()
+
+BCACHE_MAX_RETRIES=5
+
+_bcache_requires() {
+	_have_kernel_options MD BCACHE BCACHE_DEBUG AUTOFS_FS
+	_have_program make-bcache
+	_have_crypto_algorithm crc32c
+}
+
+_bcache_wipe_devs() {
+	for dev in "${BCACHE_DEVS[@]}"; do
+		# Attempt a clean wipe first
+		if wipefs --all --quiet "${dev}" 2>/dev/null; then
+			continue
+		fi
+
+		# Overwrite the first 10MB to clear stubborn partition tables or metadata
+		if ! dd if=/dev/zero of="${dev}" bs=1M count=10 conv=notrunc status=none; then
+			echo "Error: dd failed on ${dev}" >&2
+		fi
+
+		# Try wiping again after clearing the headers
+		if ! wipefs --all --quiet --force "${dev}"; then
+			echo "Warning: Failed to wipe ${dev} even after dd." >&2
+		fi
+	done
+}
+
+_bcache_register() {
+	if [[ ! -w /sys/fs/bcache/register ]]; then
+		echo "ERROR: bcache registration interface not found." >&2
+		return 1
+	fi
+
+	for dev in "${BCACHE_DEVS[@]}"; do
+		if ! echo "${dev}" > /sys/fs/bcache/register 2>/tmp/bcache_err; then
+			err_msg=$(< /tmp/bcache_err)
+
+			if [[ "${err_msg}" != *"Device or resource busy"* ]]; then
+				echo "ERROR: Failed to register ${dev}: ${err_msg:-"Unknown error"}" >&2
+			fi
+		fi
+	done
+}
+
+_create_bcache() {
+	local -a cdevs=()
+	local -a bdevs=()
+	local -a ARGS=()
+	local bucket_size="64k"
+	local block_size="4k"
+
+	_register_test_cleanup _cleanup_bcache
+
+	while [[ $# -gt 0 ]]; do
+		case $1 in
+			--cache)
+				shift
+				# Collect arguments until the next flag or end of input
+				while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
+					cdevs+=("$1")
+					shift
+				done
+				;;
+			--bdev)
+				shift
+				# Collect arguments until the next flag or end of input
+				while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
+					bdevs+=("$1")
+					shift
+				done
+				;;
+			--bucket-size)
+				bucket_size="$2"
+				shift 2
+				;;
+			--block-size)
+				block_size="$2"
+				shift 2
+				;;
+			--writeback)
+				ARGS+=(--writeback)
+				shift 1
+				;;
+			--discard)
+				ARGS+=(--discard)
+				shift 1
+				;;
+			*)
+				echo "WARNING: unknown argument: $1"
+				shift
+				;;
+		esac
+	done
+
+	# add /dev prefix to device names
+	cdevs=( "${cdevs[@]/#/\/dev\/}" )
+	bdevs=( "${bdevs[@]/#/\/dev\/}" )
+
+	# make-bcache expects empty/cleared devices
+	BCACHE_DEVS+=("${cdevs[@]}" "${bdevs[@]}")
+	_bcache_wipe_devs
+
+	local -a cdevs_args=()
+	for dev in "${cdevs[@]}"; do
+		cdevs_args+=("--cache" "${dev}")
+	done
+
+	local -a bdevs_args=()
+	for dev in "${bdevs[@]}"; do
+		bdevs_args+=("--bdev" "${dev}")
+	done
+
+	local output cmd
+	cmd=(make-bcache \
+		--wipe-bcache \
+		--bucket "${bucket_size}" \
+		--block "${block_size}" \
+		"${cdevs_args[@]}" \
+		"${bdevs_args[@]}" \
+		"${ARGS[@]}")
+
+	output=$("${cmd[@]}" 2>&1)
+	local rc=$?
+	if [[ "${rc}" -ne 0 ]]; then
+		echo "ERROR: make-bcache failed:" >&2
+		echo "$output" >&2
+		return 1
+	fi
+
+	local cset_uuid
+	cset_uuid=$(echo "$output" | awk '/Set UUID:/ {print $3}' | head -n 1)
+	if [[ -z "${cset_uuid}" ]]; then
+		echo "ERROR: Could not extract cset UUID from make-bcache output" >&2
+		return 1
+	fi
+	BCACHE_CSETS+=("${cset_uuid}")
+
+	local -a bdev_uuids
+	mapfile -t bdev_uuids < <(echo "$output" | awk '
+	  $1 == "UUID:" { last_uuid = $2 }
+	  $1 == "version:" && $2 == "1" { print last_uuid}
+	')
+
+	udevadm settle
+
+	_bcache_register
+
+	for uuid in "${bdev_uuids[@]}"; do
+		local link found attempt
+
+		link=/dev/bcache/by-uuid/"${uuid}"
+		found=false
+		attempt=0
+
+		while (( attempt < BCACHE_MAX_RETRIES )); do
+			if [[ -L "$link" ]]; then
+				BCACHE_BDEVS+=("${uuid}")
+				found=true
+				break
+			fi
+
+			(( attempt++ ))
+			sleep 1
+		done
+
+		if [[ "$found" == "false" ]]; then
+		   echo "WARNING: Could not find device node for UUID ${uuid} after ${BCACHE_MAX_RETRIES}s" >&2
+		fi
+	done
+}
+
+_remove_bcache() {
+	local uuid
+
+	for uuid in "${BCACHE_BDEVS[@]}"; do
+		local dev_path
+
+		dev_path=$(blkid -U "${uuid}")
+		if [ -n "$dev_path" ]; then
+			local dev_name
+
+			dev_name="${dev_path##*/}"
+			if [ -f "/sys/block/${dev_name}/bcache/stop" ] ; then
+			   echo 1 > "/sys/block/${dev_name}/bcache/stop"
+			fi
+		fi
+	done
+
+	for uuid in "${BCACHE_CSETS[@]}"; do
+		if [ -f /sys/fs/bcache/"${uuid}"/unregister ] ; then
+		   echo 1 > /sys/fs/bcache/"${uuid}"/unregister
+		fi
+	done
+
+	udevadm settle
+
+	local timeout
+	timeout=0
+	for uuid in "${BCACHE_CSETS[@]}"; do
+		while [[ -d "/sys/fs/bcache/${uuid}" ]] && (( timeout < 10 )); do
+			sleep 0.5
+			(( timeout++ ))
+		done
+	done
+
+	_bcache_wipe_devs
+
+	BCACHE_CSETS=()
+	BCACHE_BDEVS=()
+}
+
+_cleanup_bcache() {
+	local cset dev
+
+	shopt -s nullglob
+	for dev in /sys/block/bcache* ; do
+		[ -e "${dev}" ] || continue
+
+		dev=$(basename "${dev}")
+		echo "WARNING: bcache device ${dev} found"
+
+		if [[ -f /sys/block/"${dev}"/bcache/stop ]]; then
+			echo 1 > /sys/block/"${dev}"/bcache/stop 2>/dev/null || true
+		fi
+	done
+
+	for cset in /sys/fs/bcache/*-*-*-*-*; do
+		if [[ -d "${cset}" ]]; then
+			echo "WARNING: Unregistering cset $(basename "${cset}")"
+			echo 1 > "${cset}"/unregister 2>/dev/null || true
+		fi
+	done
+	shopt -u nullglob
+
+	udevadm settle
+
+	local timeout
+	timeout=0
+	for cset in /sys/fs/bcache/*-*-*-*-*; do
+		while [[ -d "${cset}" ]] && (( timeout < 10 )); do
+			sleep 0.5
+			(( timeout++ ))
+		done
+	done
+
+	_bcache_wipe_devs
+
+	BCACHE_DEVS=()
+}

-- 
2.52.0

