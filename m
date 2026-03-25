Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B85530AAB8
	for <linux-bcache@vger.kernel.org>; Wed, 25 Mar 2026 04:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774413721; cv=none; b=PAXiTm+g5CmvAhottqGGPgqY2O4VZSOSuKooHtH9uaLtYRio0UwmxLpDEdHeO6TnWpvBAOImAuz+taJNVCueYuVnIz/8OBNa43wky/kRpGSs1Kg63OlGwUCSeLVt2FyD2RjzEPpTpNvnulEf+4obGhLJrrFQG0al9HTlzeXt0AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774413721; c=relaxed/simple;
	bh=1zoiegA9rr9/ARMpqI2NMepk6PZQsJWewJePuKOQvrY=;
	h=To:Subject:Content-Type:Mime-Version:Date:Message-Id:Cc:From; b=TRvZ35wWY5S9GKA4UGproMpQbaZzC99UC2wSIBUss1S8t8aiVpVGuzHh9b1IHf1ah0oYAUt9d5irCLm4JhJl6yG48OGuMKVFrCAgH+kt/vYwMjLIPXorRuAHBL1h3u0b83VAp8EZZZYwDfcKnhxvk0zm2KRGEghNM5HOeo6zfDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GZdHp60/; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GZdHp60/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774413713; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1zoiegA9rr9/ARMpqI2NMepk6PZQsJWewJePuKOQvrY=;
 b=GZdHp60/TSordcaUQadRQC/J2kUHQBcztNb6U/7wGxpRFDaIh3flog4QggbVQYEsuyNPeL
 bQJVRxShIBWfExrSp3xNbDkTZCkZWSfwg6IE12iOv9hQ6aWaC64f/IAbcvGxOnVD53RLMt
 IOtHcD7RHtXnRyDcSQgq7OuXdlG4fjanUCuGNzES7j9hi1kC+ee8N4P8ly9Q0e7+p3p1GM
 0JlOk9lZr5D6XDpILea5RPcwhyBLgo7R9CnywmIj/U9ydyIsuOsNUSKl5qeNNMLLygqFTe
 ZrqFYa5hx6g39XkH6oefixYhAk75XjfTHcGnIBXjg+kk0FHa1ESJW/aqHuvFpQ==
Content-Transfer-Encoding: quoted-printable
To: "Coly Li" <colyli@fnnas.com>
Subject: Re: [QUESTION] Using bcache to mask transient I/O hangs and errors from an unstable backing device
X-Lms-Return-Path: <lba+169c3678f+fe4f69+vger.kernel.org+guzebing@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Wed, 25 Mar 2026 12:41:49 +0800
Message-Id: <4b210910448ef2227190f426e97614787d15d32b.43b36681.059c.49aa.a07b.43d99c01b338@bytedance.com>
Cc: =?utf-8?q?=E5=BE=90=E5=B9=BF=E6=B2=BB?= <xuguangzhi@bytedance.com>, 
	=?utf-8?q?=E5=B8=B8=E5=87=A4=E6=A5=A0?= <changfengnan@bytedance.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, 
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
From: =?utf-8?q?=E9=A1=BE=E6=B3=BD=E5=85=B5?= <guzebing@bytedance.com>

(Resending with linux-bcache@vger.kernel.org kent.overstreet@linux.dev on C=
C, which was accidentally dropped in my previous reply.)

> From: "Coly Li"<colyli@fnnas.com>
> Date:=C2=A0 Tue, Mar 24, 2026, 14:37
> Subject:=C2=A0 Re: [QUESTION] Using bcache to mask transient I/O hangs an=
d errors from an unstable backing device
> To: "=E9=A1=BE=E6=B3=BD=E5=85=B5"<guzebing@bytedance.com>
> Cc: "linux-bcache@vger.kernel.org"<linux-bcache@vger.kernel.org>, "kent.o=
verstreet@linux.dev"<kent.overstreet@linux.dev>
> On Tue, Mar 24, 2026 at 12:50:55PM +0800, =E9=A1=BE=E6=B3=BD=E5=85=B5 wro=
te:
> > Hi all,
> >=C2=A0
> > I'd like to describe a problem we're facing and a proposed solution bas=
ed on bcache. I'm writing to ask whether this direction makes sense, and wh=
ether there is a better existing mechanism in the kernel that I might have =
missed.
> >=C2=A0
> > =3D=3D Problem =3D=3D
> > We use kernel RBD (krbd) as a block device backed by a Ceph cluster. Du=
e to network instability and other infrastructure issues, the krbd device o=
ccasionally suffers transient I/O hangs or I/O errors. These episodes can l=
ast anywhere from a few seconds to several minutes, after which krbd recove=
rs on its own.
> > During these periods, upper-layer applications (filesystems, databases,=
 etc.) observe hung or failed I/O and may degrade or crash. Our goal is to =
make these transient backing-device failures completely invisible to the ap=
plication layer.
> > To put it more generally: when a block device is unstable and may exper=
ience intermittent I/O hangs or I/O errors, how can we guarantee I/O stabil=
ity for the layers above it?
> >=C2=A0
> > =3D=3D Proposed approach =3D=3D
> > We plan to use bcache with a local NVMe device as the cache, sitting in=
 front of the krbd backing device. The idea is to let the NVMe absorb all I=
/O during a krbd stall and drain dirty data back to krbd once it recovers. =
Specifically:
> > =C2=A0 - The NVMe cache partition is sized equal to the krbd device, so=
 the entire working set can reside in cache. This maximises read cache hit =
rate. This is the most important.
>=C2=A0
> Data buckets on cache device are stored in append-only way, it means the =
old
> data won't be deleted before a garbage collection. An exact equal sized c=
ache
> partation will hold less or much less data comparing to the whole data se=
t
> on backing device. Actual cached data size depends on how the old data is
> handled by garbage collection.

Thanks for the explanation and reply, now I understand.=C2=A0
Because cache buckets are append-only, effective usable cache capacity
can be smaller than raw cache-device size, depending on overwrite rate
and GC behavior.

My remaining question is about the full-set-caching case. If the goal is
to keep serving I/O from the local device even while the backing device
is temporarily unhealthy, then it seems this may no longer fit bcache's
current append-only cache model very well. Maybe in-place overwrites
would work here and avoid the need for a GC thread.

This would move bcache away from a pure caching role and closer to a
local-persistence layer with asynchronous writeback to the backing device.
Before I spend time prototyping anything larger: would you consider that
direction fundamentally out of scope for bcache?

>=C2=A0
>=C2=A0
> > =C2=A0 - We use writeback mode, so both reads and writes are served fro=
m the NVMe first and asynchronously flushed to the krbd backing device.
> > =C2=A0 - The workload is a mix of reads and writes.
>=C2=A0
> That means read-miss is still possible and frequent. It is an open questi=
on
> how to handle read failure for read-miss while the backing device is inva=
lid
> temporarily.
>=C2=A0
> > bcache already supports most of what we need. However, the current writ=
eback mode does not fully isolate the upper I/O path from backing-device fa=
ilures. When krbd hangs or returns errors during dirty-data flushing, bcach=
e may still propagate those failures upward or stall the cache device.
> >=C2=A0
> > =3D=3D What we think is needed =3D=3D
> > We believe a relatively small addition =E2=80=94 a new cache mode along=
side the existing write-through / writeback / write-around / none modes =E2=
=80=94 could solve this. The semantics of this new mode would be:
> > =C2=A0 * All reads and writes are served exclusively from the cache dev=
ice.
> > =C2=A0 * Dirty data is flushed to the backing device asynchronously.
> > =C2=A0 * Any I/O errors or hangs on the backing device during flushing =
are handled gracefully =E2=80=94 retried later rather than propagated to th=
e upper layer.
> > =C2=A0 * When the backing device is healthy, dirty data drains normally=
.
> > This would allow bcache to act as a resilience layer, not just a perfor=
mance cache. The required changes seem modest and would not affect the exis=
ting modes.
> >
>=C2=A0
> Indeed you don't need a new cache mode. It seems to work if a multiple-re=
try
> added to writeback failure situation, and in case you handle all relative
> stuffs e.g. =C2=A0writeback order, writeback throttle properly.

Yes, I agree. If full-set caching is not a hard requirement and partial cac=
hing is
acceptable, such that most read I/O can hit the cache without requiring a 1=
00%
hit rate, then retrying writeback failures should be sufficient.

We are still evaluating whether to relax the original goal from full-set ca=
ching to
partial caching, but that is one option we are considering.

>=C2=A0
> =C2=A0
> > =3D=3D Questions =3D=3D
> > =C2=A0 1) Is this direction sound within the bcache architecture? Is th=
ere anything fundamental that would make it impractical?
>=C2=A0
> 1, There is no assurance that all data set of backing device can be cache=
d on
> =C2=A0 =C2=A0cache device with any specific cache size.
>=C2=A0
> 2, If backing device is invalid while read-miss happens, how to handle it=
 is an open question.
>=C2=A0
>=C2=A0
> > =C2=A0 2) Would adding such a new mode to bcache be considered meaningf=
ul and welcome? I'm willing to do the development and submit patches, but I=
 want to make sure this is not out of scope for the project.
> > =C2=A0 3) Is there an existing in-kernel solution =E2=80=94 dm-cache, d=
m-writecache, or some other mechanism =E2=80=94 that already handles the "m=
ask transient backing-device failures" use case and that I may have overloo=
ked?
> >=C2=A0
> > Any feedback, pointers, or alternative suggestions would be greatly app=
reciated. Thank you for your time.
>=C2=A0
> Just a very simple reply at this moment.
>=C2=A0
> Coly Li
>=C2=A0

Thanks again.
Guzebing
