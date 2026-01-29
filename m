Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0107B2309B9;
	Thu, 29 Jan 2026 01:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769651705; cv=none; b=jcmIBtxiD5PUp5r7IAEPrF5gg5T4babslAXUN46jpdAWNZP9HfQeYKfQsgMh3BXMHHUaq6/tgS5uv9wTPMOR4XHVQMnHKCrKdkutPBoCmZUCLH793Z92uPLxs6S3jgpLvFdm65fjmyOWfufajkB6jwCdU9qyex1xOx6/qAh78KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769651705; c=relaxed/simple;
	bh=Ohe+ZFPrWImP5U48KfzlsaruJoDhahc0eFiRfPnSoqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=G/bgv3YYKBprJGqQOfktET1u7P/A6tHPEOlAQ6/WSBsSpTAqL46xwr7UDduNdIsQ/tJmX7mw1AfdJGEQchhmq5ThgHDFd//SxKbAm1oOPlK7uD5rOHEgBsBzwW2E1Gw0eqPG8U/eFWF9DOhajORyvXs0PbkM39TweYSaYD+M+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MRUf/Y/H; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MRUf/Y/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=Ohe+ZFPrWImP5U48KfzlsaruJoDhahc0eFiRfPnSoqU=; b=M
	RUf/Y/HxGmJd5r6NKlLVLuyQScrl2xXxoRIwTJsrOd/NlJftLxsxEvJSXIj6I2ex
	A/ymBsorHLafe7XJ/HXUFrhVman28NrTeN+LFRS5jnzIAZlNAWRHrJ17MfaJOpgd
	D3yIk84zEYK9uwoVYbxfJZO0cjDur8EN/DGMDAz5jk=
Received: from zhangshida2026$163.com ( [116.128.244.171] ) by
 ajax-webmail-wmsvr-40-148 (Coremail) ; Thu, 29 Jan 2026 09:54:08 +0800
 (CST)
Date: Thu, 29 Jan 2026 09:54:08 +0800 (CST)
From: zhangshida2026  <zhangshida2026@163.com>
To: colyli@fnnas.com, kent.overstreet@linux.dev, hch@infradead.org,
	axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn, starzhangzsd@gmail.com
Subject: Re:[PATCH v3 0/2] bcache: fix I/O accounting leak
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260127082112.1114158-1-zhangshida2026@163.com>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
X-NTES-SC: AL_Qu2dC/qevk4v7iKebekfnksQg+g8XMe4ufsn24Zfc+AGlyH32QAgX21eIGLx8silBAavngecfyJn8cZnV6dR0boMKqNGqp4QgOfmtH8xLg==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <4134f033.14c9.19c07753714.Coremail.zhangshida2026@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:lCgvCgDnz9TBvXppO5NhAA--.9195W
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC5wGYpGl6vcG7CgAA3E
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgoKCgoKCgoKCgoKCgoKCgpBdCAyMDI2LTAxLTI3IDE2OjIxOjEwLCB6aGFuZ3NoaWRhMjAyNkAx
NjMuY29tIHdyb3RlOgo+RnJvbTogU2hpZGEgWmhhbmcgPHpoYW5nc2hpZGFAa3lsaW5vcy5jbj4K
Pgo+VGhpcyBzZXJpZXMgYWRkcmVzc2VzIGFuIEkvTyBhY2NvdW50aW5nIGxlYWsgd2hlcmUgZGV0
YWNoZWQgYmNhY2hlCj5kZXZpY2VzIGNvdWxkIHJlcG9ydCAxMDAlIHV0aWxpemF0aW9uIGluIGlv
c3RhdCBhZnRlciBjb21wbGV0aW9uCj5vZiBkaXNjYXJkIHJlcXVlc3RzLgo+Cj5DaGFuZ2VzIHNp
bmNlIHYyOgo+LSBPbWl0dGluZyB0aGUgZGVhZCBOVUxMIGNoZWNrIGZvciBiaW9fYWxsb2NfY2xv
bmUoKSAoc3VnZ2VzdGVkIGJ5IGhjaCkuCj4tIFVwZGF0ZWQgdGhlIEZpeGVzIHRhZyBmb3IgdGhl
IGFjY291bnRpbmcgbGVhay4KPgo+U2hpZGEgWmhhbmcgKDIpOgo+ICBiY2FjaGU6IHJlbW92ZSBk
ZWFkIGNvZGUgaW4gZGV0YWNoZWRfZGV2X2RvX3JlcXVlc3QKPiAgYmNhY2hlOiBmaXggSS9PIGFj
Y291bnRpbmcgbGVhayBpbiBkZXRhY2hlZF9kZXZfZG9fcmVxdWVzdAo+Cj4gZHJpdmVycy9tZC9i
Y2FjaGUvcmVxdWVzdC5jIHwgNiArLS0tLS0KPiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDUgZGVsZXRpb25zKC0pCgo+CgoKSGkgSmVucywKClRoZSBwYXRjaGVzIGhhdmUgYmVlbiBy
ZXZpZXdlZCBieSBDaHJpc3RvcGggYW5kIGFja2VkIGJ5IENvbHkuIApHaXZlbiB0aGF0IHdlIGFy
ZSBub3cgYXQgcmM3LCBJIHdhbnRlZCB0byBzZWUgaWYgeW91IHdvdWxkIGNvbnNpZGVyIHBpY2tp
bmcgCnRoZXNlIHVwIGZvciB0aGUgNi4xOSBjeWNsZT8KClRoYW5rIHlvdSBmb3IgeW91ciB0aW1l
IGFuZCBmb3IgYWxsIHlvdXIgd29yay4KCkJlc3QgcmVnYXJkcywKU2hpZGEgWmhhbmcKCj4tLSAK
PjIuMzQuMQo=
