Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C737B3FADF6
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jul 2026 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783427405; cv=none; b=apeXyqxrjvJxlMYJFE8kOZ2wnMOzellPxWL4RJrSTgapFbyDlrIYN3kAzreZg/lc4uBthwi/FkWLNDndUg8EQF7xeNYVU7OTV0lcBigWSNXRBp97fxbbxDzOdSZwDNIUzWNR45WpMK6jGi9qcqThUlfA/pekuUSHZjJ8Qkl1Q6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783427405; c=relaxed/simple;
	bh=teHxCKTZ79MX5H477OzP9tSfRhkHXSUvXKRTMYxe1Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCk5NGmQF93otCa+/IJuf4hGKhIo93kxElnD65TlysknbGkFOnmiVmuxYyA0x2qVuDinNhEQVU1I76tEVJZmWWY0kAj4pET0iJ5YgzA6HS6swsmQjai8HnmF4iLLSnF4MEWl16Q48Ix6/qc0rVIe2sDET94/ejUojXpplCfgqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcV1cqqV; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcV1cqqV"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84347ad88edso5512338b3a.1
        for <linux-bcache@vger.kernel.org>; Tue, 07 Jul 2026 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783427404; x=1784032204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=teHxCKTZ79MX5H477OzP9tSfRhkHXSUvXKRTMYxe1Ok=;
        b=CcV1cqqVRJ8m6Rys5J3I3p0Mo/V5HEj8CxGdierZxPMA7Gsuab/AhLlZ0QbLI02IXE
         NfPvogPY1EWdHVRAXtR+CE+RHfNjsrmB0ooaVeTvE0hSvjWR3n4WmegRUNnOOduEhc4m
         6dbY60aj84eQkeBtpICr/37pZJBhPp2caQ3yh6dY331fYsnspSN/eelgi/pc6W3UfFyZ
         fGQ6V4/iuaEsd23RKN0kY1QF7lG8D0mopQC4PdXOc2Qlzv1mqJXccCQcMmUFyyhvWgVm
         1no584GaijBuZmUYFgtwojBJ+mpNTDCWmicdKVF3B1WAvTZ+WkWFlq3y4Qg0YczQPxV2
         K6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783427404; x=1784032204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=teHxCKTZ79MX5H477OzP9tSfRhkHXSUvXKRTMYxe1Ok=;
        b=JCfwvjZ22NCVdrfo+rO6jtGYYsxhzBmMVh7WbNlkNC1QRzbaxwflGL33nM6SS7Cn13
         1YZ5jYh7a5zC0iRJjyAZSQvDqXhn40fo4gNsaCUI8LQ9tm3Tye1Zpgvq0u8SWpE8xHw/
         Xi85DNnuPVMXCAREvD1bJDNulv1xS32c2Ykz8Cgmb+yQWviD/A6bv1mt0Rmtu+Fx/C01
         1Otc8W/3KHwanA5xQcatKO3IxSvy8MhM6vTa/8geiIx4PdckSbWxOe/5zQ/XOD1GqJIM
         zhFzQHtEQgimKiUl+HrJmd+oA1tVymxPj3tsjET9JwhiOGBx70JVEiLjJjkNVfpoiLGm
         BHAw==
X-Forwarded-Encrypted: i=1; AHgh+RprM/d4euS53gAPTMTq1Xq+pknh6HqVYej1j2gBHvavRZaZ140NZyKDS6mgMoFcA1IVZmXp4KC7knyb9JA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV20+0T1Tmt4c0msmT+FjGmtIJp2K7yRRgT7y41yTIKZNcNKAE
	fX/HhW63LigFrJkh6VEqcegkWx7c3Ug7WGG9RxYgOOtV8jES00qAkvKtErClqmJy6f/MkA==
X-Gm-Gg: AfdE7cnl7UIONg12e0FKFkuhc9utRY3xrIascMiwpFiSKo6DUDw3sZmrV+rMQw9Jsz2
	C9I4HlWFKJzm+YNR4/4JQtfcei3tk5PRrYtOH7ojAi/Z8d5FDaRiOCqAZb+PPdOZSoy0LO80n1E
	20mFU71ec7jNJUgvdg14vGkApEC5uDV6JkD/gwbQvpx00WcbcUGtRtv4Qlj1cvQxv6Uj+aGfurZ
	5JumFSRlX/vBp8TMuB6vbjIBAfojzTvVovQYYowr3wxVzFPxJ5ooYaJJtVa9lCgT4LXN5CFkfC+
	ikEBoAH6nwk6rtioQNBT5JodgnqeJLMNNiDXAoZQhnqQOjyuEAPN+ueVRqtFhw16MHK/Q4eToty
	AMcE8hGoRRcju4R/xNNoytBmBxbUt3xnerZwt1pzjiUFsI9Ia/vwWFyiEv2o4v+hEDBSysu2RiM
	4ZaOaxn6U=
X-Received: by 2002:a05:6a00:bd90:b0:847:8f0d:cc09 with SMTP id d2e1a72fcca58-84826e13ea4mr4552368b3a.44.1783427404096;
        Tue, 07 Jul 2026 05:30:04 -0700 (PDT)
Received: from ubuntu.. ([61.144.108.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b6162esm5474241b3a.11.2026.07.07.05.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:30:03 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: colyli@fygo.io
Cc: Jing Wu <realwujing@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Tue,  7 Jul 2026 20:29:57 +0800
Message-ID: <20260707122958.563507-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <D3C107FC-C1B6-4A65-B5E1-EE562FE84A5C@fygo.io>
References: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com> <D3C107FC-C1B6-4A65-B5E1-EE562FE84A5C@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Coly,

Just a quick follow-up: we have been running the v3 patch in our cloud
infrastructure for some time now, and the previously observed boot-time
blocking of unrelated bcache sysfs accesses during cache_set recovery
is gone. The udev timeout + retry cycle that kept delaying Ceph OSD
startup no longer reproduces.

Thanks,
Jing
