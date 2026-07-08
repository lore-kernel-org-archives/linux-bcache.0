Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21543433BD0
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 11:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783510543; cv=none; b=CUB/WzPoZLVhehWmNO+0me39lnOJ1+qJ7HYtlJUD4PGcavam89rAw5T4SsL72JnX1kEjeI7IvxQGct64anmvaDKNOqyYNbsQoPcKZE7pmAIJMnB0z79QfQIDet8IokjACcgNCFCtuRD1LUaEnCALSmuZL+eIwROuo7prnTbjbJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783510543; c=relaxed/simple;
	bh=LyE6WmkOCjrKynMGmOfvayz/Kbpu9A/iI3Yom8wbuqI=;
	h=References:In-Reply-To:Message-Id:Content-Type:Subject:From:Date:
	 Mime-Version:Cc:Content-Disposition:To; b=FEhe2Zx4Zy7olWaF6i74lz+zxbuSQcrbftXTYJunWhhasmPLqU1PCTt/ZvNi/2arTQmzQcfTFp9G4b1UVlYpHrVobt+G+Z8GeoZ8IrmZhC36NezauFH8S+QsanHpoUw5+iy106F8PNIiHjd85JesaSC6pb50Gu3lWDFrPwAZC7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IwCaFFXU; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IwCaFFXU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783510527;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=VwyD7pjocCThHG0ftrkt8Sujt//yVi6jiEUqbjIWlvU=;
 b=IwCaFFXUJD2WmtdOh+J505QLy+Sk7FRPqFsnXMn1XJngHyDykjun90oKqJT3zX+5J5TGQn
 M/PuLMplFSfUQfcOAlQezSEFZmsIy8GYPW4E7OSUWZwihbqvNqFZMHgTNUhuyepqjtYz64
 yBKZkShwowcll0TyBlq3EY9Bsa4jAVJarJ+kYXE7y3ElgmNsZ9RgX4wTcKVAv+i0bLUvuD
 XFy/ev6a3bL9Epmim8o2s9cP2j55jRgHUo37UHsA66WMZ+uGSNVl7fLMj5fUP/gEvoy0Gw
 5+jlyyfqqy70HSUFu4mH3jOlZ7eIFKAUG1IltsF3YvJaVLp4M2j1E2RVc84rrA==
References: <ak4I5Rkx1ZPjueNv@studio.local> <20260708084907.436861-1-realwujing@gmail.com>
X-Original-From: Coly Li <colyli@fygo.io>
In-Reply-To: <20260708084907.436861-1-realwujing@gmail.com>
Message-Id: <ak4zj99pJClmDEva@studio.local>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
From: "Coly Li" <colyli@fygo.io>
Date: Wed, 8 Jul 2026 19:35:23 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4e35fe+b528c4+vger.kernel.org+colyli@fygo.io>
Cc: <kent.overstreet@linux.dev>, <colyli@fnnas.com>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yuanql9@chinatelecom.cn>, <akpm@linux-foundation.org>, 
	<kuba@kernel.org>, <brauner@kernel.org>, <eddyz87@gmail.com>
Received: from studio.local ([120.245.64.95]) by smtp.larksuite.com with ESMTPS; Wed, 08 Jul 2026 11:35:26 +0000
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
To: "Jing Wu" <realwujing@gmail.com>

On Wed, Jul 08, 2026 at 04:49:07PM +0800, Jing Wu wrote:
> On Wed, Jul 08, 2026 at 04:25:23PM +0800, Coly Li wrote:
> > On Mon, Jul 06, 2026 at 10:08:59PM +0800, Qiliang Yuan wrote:
> > > Large-scale bcache device registration and concurrent sysfs access can
> > > hang unrelated tasks for a long time, e.g.:
> > >
> > [snipped]
> >
> > >
> > > Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > > Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > > Signed-off-by: Jing Wu <realwujing@gmail.com>
> >
> > I just realize this patch was sent out by Qiliang Yuan, but the
> > email address is from realwujing@gmail.com which owned by Jing Wu.
> >
> > How and why does this happen?
> 
> Jing Wu and Qiliang Yuan are on the same team. The git send-email
> configuration was mixed up when preparing this submission, and the
> patch ended up going out under the wrong author address. Apologies
> for the confusion.
> 
> The solution itself is the result of team collaboration: both of
> us worked on the analysis, design, implementation and testing, so
> both Signed-off-bys are correct and intentional.
> 

It seems all patches authored by Qiliang Yuan used realwujing@gmail.com
as the email address, even your name didn't show up in the patches.
Since you and Qiliang are in same team, why you didn't use
chinatelecom.cn email address in your SOB ?

This is not a common situation, so I need to make it clear for the
supply chain security reason.

Thanks.

Coly Li
