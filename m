Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157FF403142
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 08:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783499147; cv=none; b=KyVy070MlU1YEBECUORelbU2kzbXxMj9sEokOuMMSs1UCb50QkqMPg/2P/ZLWCyjVPyJQo+qJokkY9sR0N3/ieZnQ+cRiwT/NQWm/PFmHkq5SJfFI4S1x8e2IwlVYlAkdJyMuPEGeVD1HXE/N3XEhy6q6NdvoP/VbR0pnBChuXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783499147; c=relaxed/simple;
	bh=hTooJ4gPZijeqiBqs/9NNNxlJIXFJZt3B0cBEjkv3Vc=;
	h=In-Reply-To:References:Cc:Subject:Date:To:Content-Disposition:
	 Content-Type:From:Message-Id:Mime-Version; b=LS8PQF3lAhgfUNrDokwEkLoWsYnEnPPT/2sclMFHs/emj3SBDDeFqEka41JFVgReg97aQaR9xIwsLG7eAmIHGkUF9bS3NCaROlsm+yqxfh71j/HXuoaJWc786PLlMgzQ9p+0quaVx1bLa98f/FGcfmnfZXgOo2euHgGIj5uiSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=l9HvGLQA; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="l9HvGLQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783499128;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NNsphr+1jqmVKVU3j3dlJSJyOP8uXrhxf8Uh2IrW1oM=;
 b=l9HvGLQA38orv0XFcVzsta+AEWGe6TxNs1lNg7LEvAicDuO1Vxgc8r25eGHcaQoie+kv4f
 3VjCNB/I+bIAEUgj+3FiuWti/TW9nTSNN1jdXoDfvIWOiqgflCJUwVbkUD+RwPn+UOMv+F
 93dQ0qdoBmMA8Tzx/t2c2XLfkqXbbKAPK9VayadFbnLA57xOeAEzcS2maN6ufy5XOyyC7Y
 rFExWQSSXUJ1wGWq3ObiKfDek8YbBjfFARKAmPoHDCVs4Mihwxxmcoj70ZSYIco9wMhp8J
 8XsOjGAtnm5Xe0LXYtdxj9rch3S6uH84p3KQ5kX/Zmh5/yAB8lkztgzCiYSd0w==
Received: from studio.local ([120.245.64.95]) by smtp.larksuite.com with ESMTPS; Wed, 08 Jul 2026 08:25:26 +0000
In-Reply-To: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com>
Content-Transfer-Encoding: 7bit
References: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Coly Li" <colyli@fnnas.com>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Qiliang Yuan" <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Wed, 8 Jul 2026 16:25:23 +0800
To: "Qiliang Yuan" <realwujing@gmail.com>
Content-Disposition: inline
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fygo.io>
X-Lms-Return-Path: <lba+26a4e0977+81ed33+vger.kernel.org+colyli@fygo.io>
From: "Coly Li" <colyli@fygo.io>
Message-Id: <ak4I5Rkx1ZPjueNv@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On Mon, Jul 06, 2026 at 10:08:59PM +0800, Qiliang Yuan wrote:
> Large-scale bcache device registration and concurrent sysfs access can
> hang unrelated tasks for a long time, e.g.:
> 
[snipped]

> 
> Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Jing Wu <realwujing@gmail.com>

I just realize this patch was sent out by Qiliang Yuan, but the
email address is from realwujing@gmail.com which owned by Jing Wu.

How and why does this happen?


Coly Li

[snipped]
