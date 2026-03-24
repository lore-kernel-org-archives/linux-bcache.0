Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430A03C5DDA
	for <linux-bcache@vger.kernel.org>; Tue, 24 Mar 2026 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334460; cv=none; b=iw8Kuat8HExgBkzoVUO7VqJuPhG1MCurva85UuTh0KOxxexdaF3ybm+BT8/YgUlQJYxdOxG/nZ/AKbzI1B0SaHth4AMJsyFshPfPck86Wlt4Ivi/POTTOusNIhNyFujgiDA8Itx1ADzRt0RDZ2jeKGsFYqRTSSVqee4fhMiubEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334460; c=relaxed/simple;
	bh=Xx+VB18MSM5Q3KXyib/8jza9Nj1C8jyMIK0DUq0bMvI=;
	h=Content-Disposition:From:Subject:Cc:Message-Id:In-Reply-To:
	 Content-Type:References:To:Date:Mime-Version; b=XZEjNYDWstM/pxD3Yksp8UPCytQGSlWSzeQBgfZVdmZ2RzEKYqoKp8QPyDVR/GRh7qjIyNG2/EHhWFY6TegqsbW6CuFaRklhegXHTMs0uroWNFyrgWhxT2cPArHrwWPPQvaQ3ycDADbPFW9O3Wn+shtxXuF3hBffNjCgFBILdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=pid6FC+t; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="pid6FC+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774334247;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pQDytFeIehF6ct9IS6UzJAZQSvuKmNCcICiP7/OJf28=;
 b=pid6FC+tpk7uNwZ8xCs/D+U7vD7szUYWkydZ+qRb2UJgnLyICFWCkvyreammeiud0iPutI
 Yl47/mxBCC/YI8uVpewkEn4gUo2my+LzeDu8qjIruyysjOEJHMHGi+j+Q9hIsswXp0tfNL
 8nPe89/VfaEX8K0uq6latj91U+k/QbikcafNN9v5OIqkXg+f6Km9a3gElEtie2RbMIVI9s
 C+SgL5RXUHdnkOjihzw0lHz7HeruPr+BO1LarPOL518RihkdMVChpkh0lhbxKNWJJDNLDw
 rf8pv1M90eKGD3XTccO2sAZvk+8e+JO8eqVEHjkoTfIKwI2NElvVWv8hg2WvaA==
Content-Transfer-Encoding: quoted-printable
X-Original-From: Coly Li <colyli@fnnas.com>
Content-Disposition: inline
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [QUESTION] Using bcache to mask transient I/O hangs and errors from an unstable backing device
X-Lms-Return-Path: <lba+269c23125+8c2b0e+vger.kernel.org+colyli@fnnas.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>
Message-Id: <acIutX0i9rbAR3K7@studio.local>
In-Reply-To: <4b210910448ef2227190f426e97614787d15d32b.53a515ea.f6d9.4988.8d81.b40b559c0503@bytedance.com>
Received: from studio.local ([120.245.64.207]) by smtp.feishu.cn with ESMTPS; Tue, 24 Mar 2026 14:37:24 +0800
Content-Type: text/plain; charset=UTF-8
References: <4b210910448ef2227190f426e97614787d15d32b.53a515ea.f6d9.4988.8d81.b40b559c0503@bytedance.com>
To: =?utf-8?q?=E9=A1=BE=E6=B3=BD=E5=85=B5?= <guzebing@bytedance.com>
Date: Tue, 24 Mar 2026 14:37:23 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On Tue, Mar 24, 2026 at 12:50:55PM +0800, =E9=A1=BE=E6=B3=BD=E5=85=B5 wrote=
:
> Hi all,
>=20
> I'd like to describe a problem we're facing and a proposed solution based=
 on bcache. I'm writing to ask whether this direction makes sense, and whet=
her there is a better existing mechanism in the kernel that I might have mi=
ssed.
>=20
> =3D=3D Problem =3D=3D
> We use kernel RBD (krbd) as a block device backed by a Ceph cluster. Due =
to network instability and other infrastructure issues, the krbd device occ=
asionally suffers transient I/O hangs or I/O errors. These episodes can las=
t anywhere from a few seconds to several minutes, after which krbd recovers=
 on its own.
> During these periods, upper-layer applications (filesystems, databases, e=
tc.) observe hung or failed I/O and may degrade or crash. Our goal is to ma=
ke these transient backing-device failures completely invisible to the appl=
ication layer.
> To put it more generally: when a block device is unstable and may experie=
nce intermittent I/O hangs or I/O errors, how can we guarantee I/O stabilit=
y for the layers above it?
>=20
> =3D=3D Proposed approach =3D=3D
> We plan to use bcache with a local NVMe device as the cache, sitting in f=
ront of the krbd backing device. The idea is to let the NVMe absorb all I/O=
 during a krbd stall and drain dirty data back to krbd once it recovers. Sp=
ecifically:
> =C2=A0 - The NVMe cache partition is sized equal to the krbd device, so t=
he entire working set can reside in cache. This maximises read cache hit ra=
te. This is the most important.

Data buckets on cache device are stored in append-only way, it means the ol=
d
data won't be deleted before a garbage collection. An exact equal sized cac=
he
partation will hold less or much less data comparing to the whole data set
on backing device. Actual cached data size depends on how the old data is
handled by garbage collection.


> =C2=A0 - We use writeback mode, so both reads and writes are served from =
the NVMe first and asynchronously flushed to the krbd backing device.
> =C2=A0 - The workload is a mix of reads and writes.

That means read-miss is still possible and frequent. It is an open question
how to handle read failure for read-miss while the backing device is invali=
d
temporarily.

> bcache already supports most of what we need. However, the current writeb=
ack mode does not fully isolate the upper I/O path from backing-device fail=
ures. When krbd hangs or returns errors during dirty-data flushing, bcache =
may still propagate those failures upward or stall the cache device.
>=20
> =3D=3D What we think is needed =3D=3D
> We believe a relatively small addition =E2=80=94 a new cache mode alongsi=
de the existing write-through / writeback / write-around / none modes =E2=
=80=94 could solve this. The semantics of this new mode would be:
> =C2=A0 * All reads and writes are served exclusively from the cache devic=
e.
> =C2=A0 * Dirty data is flushed to the backing device asynchronously.
> =C2=A0 * Any I/O errors or hangs on the backing device during flushing ar=
e handled gracefully =E2=80=94 retried later rather than propagated to the =
upper layer.
> =C2=A0 * When the backing device is healthy, dirty data drains normally.
> This would allow bcache to act as a resilience layer, not just a performa=
nce cache. The required changes seem modest and would not affect the existi=
ng modes.
>

Indeed you don't need a new cache mode. It seems to work if a multiple-retr=
y
added to writeback failure situation, and in case you handle all relative
stuffs e.g.  writeback order, writeback throttle properly.

=20
> =3D=3D Questions =3D=3D
> =C2=A0 1) Is this direction sound within the bcache architecture? Is ther=
e anything fundamental that would make it impractical?

1, There is no assurance that all data set of backing device can be cached =
on
   cache device with any specific cache size.

2, If backing device is invalid while read-miss happens, how to handle it i=
s an open question.


> =C2=A0 2) Would adding such a new mode to bcache be considered meaningful=
 and welcome? I'm willing to do the development and submit patches, but I w=
ant to make sure this is not out of scope for the project.
> =C2=A0 3) Is there an existing in-kernel solution =E2=80=94 dm-cache, dm-=
writecache, or some other mechanism =E2=80=94 that already handles the "mas=
k transient backing-device failures" use case and that I may have overlooke=
d?
>=20
> Any feedback, pointers, or alternative suggestions would be greatly appre=
ciated. Thank you for your time.

Just a very simple reply at this moment.

Coly Li
