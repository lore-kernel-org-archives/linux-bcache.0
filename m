Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB020366548
	for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 13:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768915709; cv=none; b=kAiDX7rwguX/dgigEGHSg8laXuSjnViLpHUHLiYbr0GpknpEiSa6pgh6Wxz3VG23ESjqyCo5ksmzEqd2igDn5u+CKPV3WsJta6dkGREcX6t3+ZVxKY/JNqOqRTux7dVB3ACM6T/Q33SF/43EvUDY+5MWnI7izcSmTTbIwsehwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768915709; c=relaxed/simple;
	bh=66t/P1JV7sy0zdEnDXunvix8jw1hoL4Ed4EcA6kMRao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FspFssKMK1KucHIQdEt97P/+DzG25u+avm0ARaxWPMEme3VWCwmJTk71ZBNAdqW+LqRkAfyctnoQmWR9i4nScGHS576p4Pgn5afxhb8vljeVJlwZbh//HihA/K3U4xaf9F4jsy1MRyxPY7d8cIgPTM0lHVrs20sVldyiVMvhb9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1XNxPMk/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1uLa/+tv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1XNxPMk/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1uLa/+tv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1XNxPMk/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1uLa/+tv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1XNxPMk/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1uLa/+tv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9640337DC;
	Tue, 20 Jan 2026 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768915705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7pbivrkjoEp2/X9V8hmr4UuTP9afXQ9ZipFfG8QelWw=;
	b=1XNxPMk/CZjF24emfp8FfCx/irPz/3E0z6iVJEWGX9C9SNjymXofIZ/CekMI8K/9V4EC8q
	IAdEGVJPIgE1fqkMLtIsnHfOM3OmuOWAMgfqFiS7cBMPwc/xMZX+efC3fO34FpldELACdF
	Kfrmko7EjNJnkhPIOad2roauD5ZM01c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768915705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7pbivrkjoEp2/X9V8hmr4UuTP9afXQ9ZipFfG8QelWw=;
	b=1uLa/+tv2/bmpNfZz4xtN+uCQPt0MmkDsr5toDpPBsNYIdsHWvIQjnVrDnzQxVLRQjI/FE
	c3eMMUo31RexyKCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768915705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7pbivrkjoEp2/X9V8hmr4UuTP9afXQ9ZipFfG8QelWw=;
	b=1XNxPMk/CZjF24emfp8FfCx/irPz/3E0z6iVJEWGX9C9SNjymXofIZ/CekMI8K/9V4EC8q
	IAdEGVJPIgE1fqkMLtIsnHfOM3OmuOWAMgfqFiS7cBMPwc/xMZX+efC3fO34FpldELACdF
	Kfrmko7EjNJnkhPIOad2roauD5ZM01c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768915705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7pbivrkjoEp2/X9V8hmr4UuTP9afXQ9ZipFfG8QelWw=;
	b=1uLa/+tv2/bmpNfZz4xtN+uCQPt0MmkDsr5toDpPBsNYIdsHWvIQjnVrDnzQxVLRQjI/FE
	c3eMMUo31RexyKCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB9C33EA63;
	Tue, 20 Jan 2026 13:28:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iD29MPmCb2lGIwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 20 Jan 2026 13:28:25 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 20 Jan 2026 14:28:18 +0100
Subject: [PATCH blktests] bcache: add bcache/001
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQyMD3aTkxOSMVF1j09Rkc2Mzi2SLNBMloOKCotS0zAqwQdGxtbUA93t
 E7VgAAAA=
X-Change-ID: 20260120-bcache-35ec7368c8f4
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
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
The initial test is very simple but it alreayd shows some troubles.

After running make-bcache, sometime there is immediatly some kernel logs and
this is the good case. User land finds all devices and thus is happy.

Though when there is not activities (for seconds), user space complains about
missing devices. I have added some debugging stuff in this verison so there is
some more info to help figure out what's going on.

"""
bcache/001 => nvme0n1 vdb vdc (test bcache setup and teardown) [failed]
    runtime  67.538s  ...  67.479s
    --- tests/bcache/001.out    2026-01-20 12:57:37.151032990 +0000
    +++ /tmp/blktests/nvme0n1_vdb_vdc/bcache/001.out.bad        2026-01-20 13:00:11.129159120 +0000
    @@ -1 +1,32 @@
     Running bcache/001
    +WARNING: Could not find device node for UUID c23b55bf-0619-4825-ada6-8d26c57210bb after 60s
    +$ make-bcache --bucket 64k --block 4k --cache /dev/nvme0n1 --bdev /dev/vdb
    +UUID:                      1b8ed2a8-4bed-4d55-a9de-1da3d5d60922
    +Set UUID:          c9fee0e5-b330-443a-8d8a-66750c1d4b86
    +version:           0
    +nbuckets:          65536
    ...
    (Run 'diff -u tests/bcache/001.out /tmp/blktests/nvme0n1_vdb_vdc/bcache/001.out.bad' to see the entire diff)

[ 2882.431357] run blktests bcache/001 at 2026-01-20 12:59:10
[...] make-bcache runs shortly after the test starts though we start to see logs way later:
[ 2946.570731] bcache: run_cache_set() invalidating existing data
[ 2946.576450] bcache: register_cache() registered cache device nvme0n1
[ 2946.582442] bcache: register_bdev() registered backing device vdb
[ 2946.590678] bcache: bch_cached_dev_attach() Caching vdb as bcache0 on set ed5c9c6d-a4f8-41fe-b6a2-73433b561796
[ 2946.599839] bcache: register_bdev() registered backing device vdc
[ 2946.609148] bcache: bch_cached_dev_attach() Caching vdc as bcache1 on set ed5c9c6d-a4f8-41fe-b6a2-73433b561796
[ 2946.774259] bcache: bcache_device_free() bcache0 stopped
[ 2946.818099] bcache: bcache_device_free() bcache1 stopped
[ 2947.181586] bcache: cache_set_free() Cache set ed5c9c6d-a4f8-41fe-b6a2-73433b561796 unregistered

Running bcache/001
WARNING: Could not find device node for UUID c23b55bf-0619-4825-ada6-8d26c57210bb after 60s
$ make-bcache --bucket 64k --block 4k --cache /dev/nvme0n1 --bdev /dev/vdb
UUID:                   1b8ed2a8-4bed-4d55-a9de-1da3d5d60922
Set UUID:               c9fee0e5-b330-443a-8d8a-66750c1d4b86
version:                0
nbuckets:               65536
block_size:             8
bucket_size:            128
nr_in_set:              1
nr_this_dev:            0
first_bucket:           1
UUID:                   c23b55bf-0619-4825-ada6-8d26c57210bb
Set UUID:               c9fee0e5-b330-443a-8d8a-66750c1d4b86
version:                1
block_size:             8
data_offset:            16

/sys/fs/bcache*:
total 0
--w------- 1 root root 4096 Jan 20 12:12 pendings_cleanup
--w------- 1 root root 4096 Jan 20 12:11 register
--w------- 1 root root 4096 Jan 20 12:12 register_quiet

/sys/block/bcache*:
ls: cannot access '/sys/block/bcache*': No such file or directory

/dev/bcache*:
ls: cannot access '/dev/bcache*': No such file or directory

/dev/bcache/by-uuid/:
ls: cannot access '/dev/bcache/by-uuid/': No such file or directory
"""

With one cache and one bdev device this happens pretty much everytime. I had
some more luck using one cache and two bdev devices which has a successrate of
roughly 50%.

Note: to run this tests blktests TEST_CASE_DEV_ARRAY needs to be set:

  # cat config
  TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"

# ./check -c config bcache
 
---
 tests/bcache/001     |  32 ++++++++
 tests/bcache/001.out |   1 +
 tests/bcache/rc      | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 258 insertions(+)

diff --git a/tests/bcache/001 b/tests/bcache/001
new file mode 100644
index 000000000000..a723f14f80bf
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
+		_bcache_requires
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
+     _remove_bcache
+
+	 _create_bcache \
+	 	--cache "${TEST_DEV_ARRAY[0]##*/}" \
+	 	--bdev "${TEST_DEV_ARRAY[1]##*/}" "${TEST_DEV_ARRAY[2]##*/}"
+     _remove_bcache
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
index 000000000000..cd71edf1042c
--- /dev/null
+++ b/tests/bcache/rc
@@ -0,0 +1,225 @@
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
+BCACHE_MAX_RETRIES=60
+
+_bcache_requires() {
+	_have_kernel_options MD BCACHE BCACHE_DEBUG AUTOFS_FS
+	_have_program make-bcache
+	_have_crypto_algorithm crc32c
+}
+
+_create_bcache() {
+    local -a cdevs=()
+    local -a bdevs=()
+    local bucket_size="64k"
+    local block_size="4k"
+
+	_register_test_cleanup _cleanup_bcache
+
+	while [[ $# -gt 0 ]]; do
+        case $1 in
+            --cache)
+                shift
+                # Collect arguments until the next flag or end of input
+                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
+                    cdevs+=("$1")
+                    shift
+                done
+                ;;
+            --bdev)
+                shift
+                # Collect arguments until the next flag or end of input
+                while [[ $# -gt 0 && ! $1 =~ ^-- ]]; do
+                    bdevs+=("$1")
+                    shift
+                done
+                ;;
+            --bucket-size)
+                bucket_size="$2"
+                shift 2
+                ;;
+            --block-size)
+                block_size="$2"
+                shift 2
+                ;;
+            --writeback)
+				ARGS+=(--writeback)
+                shift 1
+                ;;
+			--discard)
+				ARGS+=(--discard)
+				shift 1
+				;;
+            *)
+                echo "WARNING: unknown argument: $1"
+                shift
+                ;;
+        esac
+    done
+
+	# add /dev prefix to device names
+	cdevs=( "${cdevs[@]/#/\/dev\/}" )
+	bdevs=( "${bdevs[@]/#/\/dev\/}" )
+
+	# make-bcache expects empty/cleared devices
+	local dev
+    for dev in "${cdevs[@]}" "${bdevs[@]}"; do
+    	wipefs --all --quiet "${dev}"
+		BCACHE_DEVS+=("${dev}")
+    done
+
+    local -a cdevs_args=()
+    for dev in "${cdevs[@]}"; do
+        cdevs_args+=("--cache" "${dev}")
+    done
+
+	local -a bdevs_args=()
+    for dev in "${bdevs[@]}"; do
+        bdevs_args+=("--bdev" "${dev}")
+    done
+
+	local output cmd
+	cmd=(make-bcache \
+		--bucket "${bucket_size}" \
+		--block "${block_size}" \
+		"${cdevs_args[@]}" \
+        "${bdevs_args[@]}" \
+		"${ARGS[@]}")
+
+	output=$("${cmd[@]}" 2>&1)
+	local rc=$?
+    if [[ "${rc}" -ne 0 ]]; then
+        echo "ERROR: make-bcache failed:" >&2
+        echo "$output" >&2
+        return 1
+    fi
+
+	local cset_uuid
+	cset_uuid=$(echo "$output" | awk '/Set UUID:/ {print $3}' | head -n 1)
+	if [[ -z "${cset_uuid}" ]]; then
+        echo "ERROR: Could not extract cset UUID from make-bcache output" >&2
+        return 1
+    fi
+	BCACHE_CSETS+=("${cset_uuid}")
+
+	local -a bdev_uuids
+	mapfile -t bdev_uuids < <(echo "$output" | awk '
+  	  $1 == "UUID:" { last_uuid = $2 }
+      $1 == "version:" && $2 == "1" { print last_uuid}
+	')
+
+	udevadm settle
+
+	for uuid in "${bdev_uuids[@]}"; do
+    	local link found attempt
+
+		link=/dev/bcache/by-uuid/"${uuid}"
+		found=false
+		attempt=0
+
+	    while (( attempt < BCACHE_MAX_RETRIES )); do
+    	    if [[ -L "$link" ]]; then
+        	    BCACHE_BDEVS+=("${uuid}")
+            	found=true
+				break
+			fi
+
+		    (( attempt++ ))
+			sleep 1
+    	done
+
+		if [[ "$found" == "false" ]]; then
+    	   echo "bcache: ${uuid} not found" > /dev/kmsg
+		   echo "WARNING: Could not find device node for UUID ${uuid} after ${BCACHE_MAX_RETRIES}s" >&2
+		   echo "\$ ${cmd[*]}" >&2
+		   echo "${output}" >&2
+		   echo "" >&2
+		   echo "/sys/fs/bcache*:" >&2
+		   ls -l /sys/fs/bcache* >&2
+		   echo "" >&2
+		   echo "/sys/block/bcache*:" >&2
+		   ls -l /sys/block/bcache* >&2
+		   echo "" >&2
+		   echo "/dev/bcache*:" >&2
+		   ls -l /dev/bcache* >&2
+		   echo "" >&2
+		   echo "/dev/bcache/by-uuid/:" >&2
+		   ls -l /dev/bcache/by-uuid/ >&2
+		fi
+	done
+}
+
+_remove_bcache() {
+    local uuid
+
+	for uuid in "${BCACHE_BDEVS[@]}"; do
+        local link full_path dev
+
+		link=/dev/disk/by-uuid/"${uuid}"
+  		full_path=$(readlink -f "${link}")
+	    dev="${full_path##*/}"
+
+		if [ -f /sys/block/"${dev}"/bcache/stop ] ; then
+		   echo 1 > /sys/block/"${dev}"/bcache/stop
+		fi
+	done
+
+	for uuid in "${BCACHE_CSETS[@]}"; do
+		if [ -f /sys/fs/bcache/"${uuid}"/unregister ] ; then
+		   echo 1 > /sys/fs/bcache/"${uuid}"/unregister
+		fi
+    done
+
+	udevadm settle
+	# XXX sic!
+	sleep 3
+
+	for dev in "${BCACHE_DEVS[@]}"; do
+        wipefs --all --quiet "${dev}"
+    done
+
+	BCACHE_CSETS=()
+	BCACHE_BDEVS=()
+}
+
+_cleanup_bcache() {
+    local cset dev
+
+	shopt -s nullglob
+    for dev in /sys/block/bcache* ; do
+        [ -e "${dev}" ] || continue
+
+        dev=$(basename "${dev}")
+        echo "WARNING: bcache device ${dev} found"
+
+        if [[ -f /sys/block/"${dev}"/bcache/stop ]]; then
+            echo 1 > /sys/block/"${dev}"/bcache/stop 2>/dev/null || true
+        fi
+    done
+
+	for cset in /sys/fs/bcache/*-*-*-*-*; do
+        if [[ -d "${cset}" ]]; then
+			echo "WARNING: Unregistering cset $(basename "${cset}")"
+            echo 1 > "${cset}"/unregister 2>/dev/null || true
+        fi
+    done
+    shopt -u nullglob
+
+    udevadm settle
+
+    for dev in "${BCACHE_DEVS[@]}"; do
+        if ! wipefs --all --force "${dev}"; then
+           echo "ERROR: Failed to wipe ${dev}. It may still be in use." >&2
+        fi
+    done
+
+	BCACHE_DEVS=()
+}

---
base-commit: e387a7e0169cc012eb6a7140a0561d2901c92a76
change-id: 20260120-bcache-35ec7368c8f4

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

