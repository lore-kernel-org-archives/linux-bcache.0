Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3F7E110
	for <linux-bcache@vger.kernel.org>; Thu, 12 Feb 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770909834; cv=none; b=lxJXqTnHZQaC2MRfeviCoGAOwk09VhHWUZmElmxrqRViPciQJnp0Jtm28GtdTAmY1Il8EmqexCNAwQ4Stl/0E8t4VG98Mt9Jch7pm9/44uDBR5cAPet3bXKwwefoDN+HBJLJx/+zsr7I8tLRb6MBepcogGrqrL5uNwtGMnf5LJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770909834; c=relaxed/simple;
	bh=9hFOlZyYWx+DmTwzQtjEORqMHgWVglRDjNL+RTsPBWI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=RGs9eYJ44f7sFobIYPd6B6fIIZQ9HjVGVTBsuxWquPke0a5tev4SiQpcTgSj/AVK5OW1BLHcQa9mAhDfdqZ7m+qDRPOK7ragNQ42QMj3X8ipiNggiVdYykxkG7NK0FULggLHaB+ePKDfftuRtKzc3IEV5FkIMcRjhqrpgBgiHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m4lfAkzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2t9XSLDo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m4lfAkzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2t9XSLDo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m4lfAkzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2t9XSLDo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m4lfAkzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2t9XSLDo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F3C95BDB1;
	Thu, 12 Feb 2026 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THVHP/z2ny2Gu8UmuZ6bSO+C4+FzdlNR3zTq2FjlHKc=;
	b=m4lfAkzU2cP86xvKyggoGjrM/8LuF3xn+h6ic88Nnp6hTcR0SA/aaKypwg/31/5ljHLlOK
	3pqCJOlUDtAoFvv8J4ebbkK2+ZGEBOvhIUR58CFVQGSy5a01h8WUXiR6LOn1RohECgjQ4q
	RSp2z09lyL+GkPWhpzOlz8Rq91ePoKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THVHP/z2ny2Gu8UmuZ6bSO+C4+FzdlNR3zTq2FjlHKc=;
	b=2t9XSLDonCtdCNp+YAhUJC1aIaNbpAJrldj6bAF7gOjloKxb7axrQo+88EcK0mjx8LpW0c
	tFf3kvSkzLoiHsCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770909831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THVHP/z2ny2Gu8UmuZ6bSO+C4+FzdlNR3zTq2FjlHKc=;
	b=m4lfAkzU2cP86xvKyggoGjrM/8LuF3xn+h6ic88Nnp6hTcR0SA/aaKypwg/31/5ljHLlOK
	3pqCJOlUDtAoFvv8J4ebbkK2+ZGEBOvhIUR58CFVQGSy5a01h8WUXiR6LOn1RohECgjQ4q
	RSp2z09lyL+GkPWhpzOlz8Rq91ePoKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770909831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THVHP/z2ny2Gu8UmuZ6bSO+C4+FzdlNR3zTq2FjlHKc=;
	b=2t9XSLDonCtdCNp+YAhUJC1aIaNbpAJrldj6bAF7gOjloKxb7axrQo+88EcK0mjx8LpW0c
	tFf3kvSkzLoiHsCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E15463EA62;
	Thu, 12 Feb 2026 15:23:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OOPtNYbwjWmoLAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 12 Feb 2026 15:23:50 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 12 Feb 2026 16:23:31 +0100
Subject: [PATCH blktests v4 1/3] bcache: add bcache/001
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-bcache-v4-1-215f3fde1c84@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
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
 tests/bcache/001     |  44 ++++++
 tests/bcache/001.out |   3 +
 tests/bcache/rc      | 375 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 422 insertions(+)

diff --git a/tests/bcache/001 b/tests/bcache/001
new file mode 100755
index 000000000000..7258d87566cb
--- /dev/null
+++ b/tests/bcache/001
@@ -0,0 +1,44 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2026 Daniel Wagner, SUSE Labs
+#
+# Test bcache setup and teardown
+
+. tests/bcache/rc
+
+DESCRIPTION="test bcache setup and teardown"
+
+test_device_array() {
+	echo "Running ${TEST_NAME}"
+
+	if [[ ${#TEST_DEV_ARRAY[@]} -lt 3 ]]; then
+		SKIP_REASONS+=("requires at least 3 devices")
+		return 1
+	fi
+
+	_setup_bcache "${TEST_DEV_ARRAY[@]}"
+
+	local bcache_nodes
+
+	mapfile -t bcache_nodes < <(_create_bcache \
+				--cache "${TEST_DEV_ARRAY[0]##*/}" \
+				--bdev "${TEST_DEV_ARRAY[1]##*/}" \
+				--writeback)
+
+	echo "number of bcaches: ${#bcache_nodes[*]}"
+
+	_remove_bcache --bcache "${bcache_nodes[@]}" \
+			--cache "${TEST_DEV_ARRAY[0]##*/}" \
+			--bdev "${TEST_DEV_ARRAY[1]##*/}" \
+
+	mapfile -t bcache_nodes < <(_create_bcache \
+				--cache "${TEST_DEV_ARRAY[0]##*/}" \
+				--bdev "${TEST_DEV_ARRAY[1]##*/}" "${TEST_DEV_ARRAY[2]##*/}" \
+				--writeback)
+
+	echo "number of bcaches: ${#bcache_nodes[*]}"
+
+	_remove_bcache --bcache "${bcache_nodes[@]}" \
+			--cache "${TEST_DEV_ARRAY[0]##*/}" \
+			--bdev "${TEST_DEV_ARRAY[1]##*/}" "${TEST_DEV_ARRAY[2]##*/}"
+}
diff --git a/tests/bcache/001.out b/tests/bcache/001.out
new file mode 100644
index 000000000000..844154e13822
--- /dev/null
+++ b/tests/bcache/001.out
@@ -0,0 +1,3 @@
+Running bcache/001
+number of bcaches: 1
+number of bcaches: 2
diff --git a/tests/bcache/rc b/tests/bcache/rc
new file mode 100644
index 000000000000..cfd4094c2fe0
--- /dev/null
+++ b/tests/bcache/rc
@@ -0,0 +1,375 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2026 Daniel Wagner, SUSE Labs
+
+. common/rc
+
+declare BCACHE_DEVS_LIST
+
+BCACHE_MAX_RETRIES=5
+
+group_requires() {
+	_have_kernel_options MD BCACHE BCACHE_DEBUG AUTOFS_FS
+	_have_program make-bcache
+	_have_crypto_algorithm crc32c
+}
+
+_bcache_wipe_devs() {
+	local devs=("$@")
+	local dev
+
+	for dev in "${devs[@]}"; do
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
+		# Wipe the Tail (Last 5MB)
+		# bcache often places backup superblocks at the end of the device.
+		local dev_size_mb
+		dev_size_mb=$(blockdev --getsize64 "$dev" | awk '{print int($1 / 1024 / 1024)}')
+
+		if [ "$dev_size_mb" -gt 10 ]; then
+			local seek_pos=$((dev_size_mb - 5))
+			dd if=/dev/zero of="${dev}" bs=1M count=5 seek=$seek_pos conv=fsync status=none
+		fi
+
+		# Refresh kernel partition table & wait for udev
+		partprobe "$dev" 2>/dev/null
+		udevadm settle
+
+		# Try wiping again after clearing the headers
+		if ! wipefs --all --quiet --force "${dev}"; then
+			echo "Warning: Failed to wipe ${dev} even after dd." >&2
+		fi
+	done
+}
+
+_bcache_register() {
+	local devs=("$@")
+	local dev timeout=0
+
+	while [[ ! -w /sys/fs/bcache/register ]] && (( timeout < 10 )); do
+		sleep 1
+		(( timeout ++ ))
+	done
+
+	if [[ ! -w /sys/fs/bcache/register ]]; then
+		echo "ERROR: bcache registration interface not found." >&2
+		return 1
+	fi
+
+	for dev in "${devs[@]}"; do
+		local tmp_err
+
+		tmp_err="/tmp/bcache_reg_$$.err"
+		if ! echo "${dev}" > /sys/fs/bcache/register 2> "${tmp_err}"; then
+			local err_msg
+
+			err_msg=$(< "${tmp_err}")
+			if [[ "${err_msg}" != *"Device or resource busy"* ]]; then
+				echo "ERROR: Failed to register ${dev}: ${err_msg:-"Unknown error"}" >&2
+			fi
+		fi
+		rm -f "${tmp_err}"
+	done
+}
+
+_create_bcache() {
+	local -a cdevs=()
+	local -a bdevs=()
+	local -a ARGS=()
+	local -a created_devs=()
+	local bucket_size="64k"
+	local block_size="4k"
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
+	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
+
+	local -a cmd
+	cmd=(make-bcache --wipe-bcache \
+			--bucket "${bucket_size}" \
+			--block "${block_size}")
+	for dev in "${cdevs[@]}"; do cmd+=("--cache" "${dev}"); done
+	for dev in "${bdevs[@]}"; do cmd+=("--bdev" "${dev}"); done
+	cmd+=("${ARGS[@]}")
+
+	local output rc
+	output=$("${cmd[@]}" 2>&1)
+	rc="$?"
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
+
+	local -a bdev_uuids
+	mapfile -t bdev_uuids < <(echo "$output" | awk '
+	  $1 == "UUID:" { last_uuid = $2 }
+	  $1 == "version:" && $2 == "1" { print last_uuid}
+	')
+
+	_bcache_register "${cdevs[@]}" "${bdevs[@]}"
+	udevadm settle
+
+	for uuid in "${bdev_uuids[@]}"; do
+		local link found
+
+		link=/dev/bcache/by-uuid/"${uuid}"
+		found=false
+
+		for ((i=0; i<BCACHE_MAX_RETRIES; i++)); do
+			if [[ -L "${link}" ]]; then
+				created_devs+=("$(readlink -f "${link}")")
+				found=true
+				break
+			fi
+
+			# poke udev to create the links
+			udevadm trigger "block/$(basename "$(readlink -f "${link}" 2>/dev/null || echo "notfound")")" 2>/dev/null
+			sleep 1
+		done
+
+		if [[ "${found}" == "false" ]]; then
+			echo "WARNING: Could not find device node for UUID ${uuid} after ${BCACHE_MAX_RETRIES}s" >&2
+		fi
+	done
+
+	printf "%s\n" "${created_devs[@]}"
+}
+
+_remove_bcache() {
+	local -a cdevs=()
+	local -a bdevs=()
+	local -a csets=()
+	local -a bcache_devs=()
+	local uuid
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
+			--bcache)
+				shift
+				# Collect arguments until the next flag or end of input
+				while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
+					bcache_devs+=("$1")
+					shift
+				done
+				;;
+			*)
+				echo "WARNING: unknown argument: $1"
+				shift
+				;;
+		esac
+	done
+
+	for dev in "${bcache_devs[@]}"; do
+		local bcache bcache_dir
+
+		if mountpoint -q "${dev}" 2>/dev/null; then
+			umount -l "${dev}"
+		fi
+
+		bcache="${dev##*/}"
+		bcache_dir=/sys/block/"${bcache}"/bcache
+		if [ -f "${bcache_dir}"/stop ]; then
+			echo 1 > "${bcache_dir}"/stop
+		fi
+	done
+
+	# The cache could be detached, thus go through all caches and
+	# look for the cdev in there.
+	local cset_path
+	for cset_path in /sys/fs/bcache/*-*-*-*-*; do
+		local cache_link match_found
+
+		match_found=false
+		for cache_link in "${cset_path}"/cache[0-9]*; do
+			local full_sys_path _cdev cdev
+
+			full_sys_path="$(readlink -f "$cache_link")"
+			_cdev="$(basename "${full_sys_path%/bcache}")"
+
+			for cdev in "${cdevs[@]}"; do
+				if [ "${_cdev}" == "$(basename "${cdev}")"  ]; then
+					match_found=true
+					break 2
+				fi
+			done
+		done
+
+		if [ "${match_found}" = false ]; then
+			continue
+		fi
+
+		cset="$(basename "${cset_path}")"
+		if [ -d /sys/fs/bcache/"${cset}" ]; then
+			echo 1 > /sys/fs/bcache/"${cset}"/unregister
+			csets+=("${cset}")
+		fi
+	done
+
+	udevadm settle
+
+	local timeout
+	for cset in "${csets[@]}"; do
+		timeout=0
+		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
+			sleep 0.5
+			(( timeout++ ))
+		done
+	done
+
+	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
+}
+
+_cleanup_bcache() {
+	local cset dev bcache bcache_devs cset_path
+	local -a csets=()
+
+	read -r -a bcache_devs <<< "${BCACHE_DEVS_LIST:-}"
+
+	# Don't let successive Ctrl-Cs interrupt the cleanup processes
+	trap '' SIGINT
+
+	shopt -s nullglob
+	for bcache  in /sys/block/bcache* ; do
+		[ -e "${bcache}" ] || continue
+
+		if [[ -f "${bcache}/bcache/backing_dev_name" ]]; then
+			bdev=$(basename "$(cat "${bcache}/bcache/backing_dev_name")")
+
+			for dev in "${bcache_devs[@]}"; do
+				if [[ "${bdev}" == "$(basename "${dev}")" ]]; then
+					echo "WARNING: Stopping bcache device ${bdev}"
+					echo 1 > /sys/block/"${bdev}"/bcache/stop 2>/dev/null
+					break
+				fi
+			done
+		fi
+	done
+
+	for cset_path in /sys/fs/bcache/*-*-*-*-*; do
+		local cache_link match_found
+
+		match_found=false
+		for cache_link in "${cset_path}"/cache[0-9]*; do
+			local full_sys_path cdev
+
+			full_sys_path="$(readlink -f "$cache_link")"
+			cdev="$(basename "${full_sys_path%/bcache}")"
+
+			for dev in "${bcache_devs[@]}"; do
+				if [ "${cdev}" == "$(basename "${dev}")" ]; then
+					match_found=true
+					break 2
+				fi
+			done
+		done
+
+		if [ "${match_found}" = false ]; then
+			continue
+		fi
+
+		cset="$(basename "${cset_path}")"
+		if [ -d /sys/fs/bcache/"${cset}" ]; then
+			echo "WARNING: Unregistering cset $(basename "${cset}")"
+			echo 1 > /sys/fs/bcache/"${cset}"/unregister
+			csets+=("${cset}")
+		fi
+	done
+	shopt -u nullglob
+
+	udevadm settle
+
+	local timeout
+	for cset in "${csets[@]}"; do
+		timeout=0
+		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
+			sleep 0.5
+			(( timeout++ ))
+		done
+	done
+
+	_bcache_wipe_devs "${bcache_devs[@]}"
+
+	trap SIGINT
+}
+
+_setup_bcache() {
+	BCACHE_DEVS_LIST="$*"
+
+	_register_test_cleanup _cleanup_bcache
+}

-- 
2.53.0

