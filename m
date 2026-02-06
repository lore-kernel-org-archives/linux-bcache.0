Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFE8136349
	for <linux-bcache@vger.kernel.org>; Fri,  6 Feb 2026 02:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770345545; cv=none; b=MTTg7ixu7gneZ1gzQ9nbFp8JI8veCGcBQtU3WACsLBtl5BY5My3MtXVHsPEvh4CBRURRSAk/M/gQJeuIXLPpsL2lW3Hjiih3LLdMp5pKVO+0GDUh4mVTO70PALBpULDRXGFN5VDO14e3j30/s7aAkO/K4CJRids4MczEDyY8rH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770345545; c=relaxed/simple;
	bh=25Y2+i5wBgtljeeRREwXoQnIj1V/+Uao6baG9qdUf04=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=Mtt1qB7xcuRArnlCydo1Dk2qipfOXjjs9hUGxKMcnaFHFK7BrARpjVTmAoM81LHOufc9Kdp4+QWgkmYcNDlMsx/OVlT9leWBX5oV1fAhQRwMJ04wF23+s6lMNSxk/N25Pj538YZw/VwMpTEhBwAlvt2SmVe0gUkCCBzJhyXxaAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=t4sMGqaO; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="t4sMGqaO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=t4sMGqaOmW4zGcH+xmZvgUsO7R1s1+yxnsjB61G7/udOHIO0OER1I8DYcOkkkPZz6SffJQxkLmurt
	 UYCS0GMVRSsLhP88ckm6eqZ6sAvIbvvuuJyqQM4hGjFeDDj8qIXqTBlIkAGj+D1OZyxFtFVBHMk6qe
	 WUCG2BEpfQXCR2tk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from smtpclient.apple (unknown[103.37.140.23])
	by rmsmtp-lg-appmail-23-12026 (RichMail) with SMTP id 2efa6985543e6a0-d706c;
	Fri, 06 Feb 2026 10:38:55 +0800 (CST)
X-RM-TRANSID:2efa6985543e6a0-d706c
From: yangliming <liming.yang@139.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: [RFC/Feature Request] bcache: support io priority
Message-Id: <D31CD28C-7B6F-4D3E-89E7-966A06DFEAF0@139.com>
Date: Fri, 6 Feb 2026 10:38:44 +0800
Cc: colyli@suse.de,
 kent.overstreet@gmail.com
To: linux-bcache@vger.kernel.org
X-Mailer: Apple Mail (2.3864.300.41.1.7)

Hi bcache developers,

Many business scenarios require different IO priorities. After setting =
IO priorities, the goal is to have high-priority writes go to the SSD =
cache, while low-priority requests are bypassed to the HDD. Currently, =
the logic is:
```

if ((bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))) {

if (!(bio->bi_opf & (REQ_META|REQ_PRIO)) &&

(dc->cache_readahead_policy !=3D BCH_CACHE_READA_ALL))

goto skip;

}=20
```

This logic allows IO requests to bypass, but the request type cannot be =
controlled in user space.

Could you support setting bypass based on IO request priority? Is such a =
requirement reasonable?=

