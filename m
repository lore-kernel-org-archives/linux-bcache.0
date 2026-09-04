Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFC8481A97
	for <linux-bcache@vger.kernel.org>; Fri,  4 Sep 2026 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525459; cv=none; b=bLHGkGG/kRP0beM0FckwWbFB/xBmJp7GPqdQUogSMmDPgV7i3P2UqHDJXA7s4zMK47ML4Br3+ootjP2BQBbu7RSCS2SHKe7TqCdixNbeE1NsXebovz0q4GUnhB7YobJXRx92/G1u2n4Y13t9rrJfKgS8m6Kfr0EuZx9Ta8MlDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525459; c=relaxed/simple;
	bh=x2wbt42LUYfsWIWbxHFEFI9MOJsb09wZigy4zayb5GE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V7LMalbsx51hptqUXdu3u3mBeE1he/1BFbrYbgHKE2QT6/qdw4tudQnzpufYpmt6atjbOx9Ay96VK50TkStg3EJbmUc9jEzGKy4MiINc6b+sm1k6BGimD9yyrBgMq0yNYjij83tyK6o2qlz+MBDVFbQ7fzoAXZn5Cu58wCO6VkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adTXw3F4; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adTXw3F4"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4af7283bf83so417797b6e.3
        for <linux-bcache@vger.kernel.org>; Fri, 04 Sep 2026 05:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788525455; x=1789130255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oAKlKt/QjH4lFsAPxeLcj7oKRn+elbiY1FdXmIqGpZ8=;
        b=adTXw3F46O9R9U7g4qcDuBvHVO3azj4WJRQ/xGfzJKLkTZDLCFE/MXoWzNYkPdhxyW
         YNu6VUUgBJEo7d3h7IA1taxjDum4ZnQVVMpZAQOKPgjFzRRGa3mr/gr8JryZDRmFwCXB
         Apbq8HuMdaHtCkdalG3YfqUSJfBmitbm8B7suosVJWsMQO69FTDwM47TEB5MwftTK0Q8
         2hM/jLKIW3vzxqZeV9SdmMwLGbQhA75MQLfMIFRuonxKuCc9AkXD84kPUiyKQtwfJ3MA
         4LoMNzIeBexBnrY0Otq0lGT0lizp+4tWr2eHc4CmbrKuqL+3Y9lalrkyCBQzG5MjK4n0
         Mktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788525455; x=1789130255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oAKlKt/QjH4lFsAPxeLcj7oKRn+elbiY1FdXmIqGpZ8=;
        b=IAnnU9lPPTtq6YIEk+ZWvkcyuyArgn6mWr6Cg3k1lbCRKbg8DJLFDu6tdEomScx4H/
         qvDA310a5CdlpU+onAxSRhnVJarTNgfy0PbJ0deJZ0EMcZ+NLX4caQGhunXIeSQOEYoJ
         O6Yeb7woKsg6Gk7BInXOsgedX3M1eNBLowNoF1JNtXEhu6/0C9k7oItL8xma2noeDKcg
         NUV7k/shtNt3e6o3QUArh6ILODmOnPevkTntRXrKwwShKybrmKRAYkGQdYEPHC2FHV+L
         k25EAajreefyUUalAI2BMqRqK8dFVPR0zWcb4efxx+bsfkWuvIXGPo/ORzcY0oN6Pt2d
         9t9A==
X-Forwarded-Encrypted: i=1; AKwUvBx3wQjIL/uEZUoMohJFC4QyClPpPxx27Cy/4q/tdnpBh5W6yW5kcWFbJXPxwIM8hhM4eLhV2osNN15/aas=@vger.kernel.org
X-Gm-Message-State: AFuF++mntsWDyoLMMfWeL5gMX+FCohx9DWvgGihzf1tYv7uFDeU/W1AL
	2B5Uh7JDolaF5/sVg5m3utTTlWhb2RLQL00DA+v5rCn9gHhTlXgyKsM3
X-Gm-Gg: AYBFou3Ur9A46wtVuyapPvNwWgNAJrX0gIbrKiDajWQEWF0Pucuk7Es0K/Yma03zkGZ
	/dwNgUIcPnAkrfvwi6WXDjt1S2zU78Rs13cA+yz2ChF7HachIpYHhphSayRIL28ZF3HGYibu7Yc
	1+BJOPSCJ6xDu2a4QDNErNfko0sFullN3BAt637ulpBVOWBq/jXJn57B2/6p7D2ugm7RBEFzZwJ
	pZgOhNcJfwa+VUhIPzKm+UCNIl/nHVP0CuBX7cgOFDePlDHw9gJDxvb5+mlwVM89RX2/hZ4AItN
	ZbmpwUBHG9PWCa2s0jxEeoDrW9qOgadYuErIVdVImaX/PEZcZeGWxouvO2DArc1SywlV1VqK1mR
	KFJLhKN7RF9f47c+CBmkIQSi/efGR3S1MJCYXDj3r87IKfHxarvf0OCerqp08k0AKl9OstunErM
	sNQjiqBcEeRmX/KstaLEXqGQe+wifMCwyPuy3otmPGYDes/F3yQy9DuXBgEeEgCeB8ZaBElSOH6
	GoC1zHzId93qy4ypVhUzQMyRw==
X-Received: by 2002:a05:6820:184a:b0:6b7:8396:f3d7 with SMTP id 006d021491bc7-6b78396f903mr1393858eaf.57.1788525455285;
        Fri, 04 Sep 2026 05:37:35 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d25sm6750111eec.5.2026.09.04.05.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:37:34 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org
Subject: [PATCH] md: bcache: fix typo "idel" in comment
Date: Fri,  4 Sep 2026 18:07:29 +0530
Message-ID: <20260904123730.39849-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "idel" to "idle", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f453..7734fe0dd429 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -162,7 +162,7 @@ static bool idle_counter_exceeded(struct cache_set *c)
 	int counter, dev_nr;
 
 	/*
-	 * If c->idle_counter is overflow (idel for really long time),
+	 * If c->idle_counter is overflow (idle for really long time),
 	 * reset as 0 and not set maximum rate this time for code
 	 * simplicity.
 	 */
-- 
2.48.1

