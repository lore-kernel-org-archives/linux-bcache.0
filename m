Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EFA1AF4D5
	for <linux-bcache@vger.kernel.org>; Tue, 24 Mar 2026 04:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774327873; cv=none; b=USH75voT/8DVWUAgzlWDjGryVnWTimY0thB4FOyhFrrw5/iCDqgAbdCH59L5oLsKy3CxL5ykn1su5AjFY78nnjNjmjDjEn9xnaLPQKFA/91D8WhIOyOeYj0NOS5f0JD0TpCGHb3HldcZmRW2a6X0FEb1y7WgMOcr0Y9cw+fOUxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774327873; c=relaxed/simple;
	bh=UNGt6uwbjokTjDJ7+m2kQ41XfvybTcSOEtIYxJbrjU0=;
	h=Message-Id:From:Content-Type:Date:To:Subject:Mime-Version; b=m48C05zPnJ1uUm9kO7b1A5kxMIH1D8bozJXW5nZ5ZDUu1jPThQPYlSUaXk+Z5VIUsTOiugZf13HbaNQuZmOW34DAYxH0f12Pgmym16noKMQ6s5V7vmKMyzFto3Y1uNdWdSPfHVJzN0A7gaPOW6y/VG9LF7hRnXURJrNkGD/6t2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=oEV4gVMm; arc=none smtp.client-ip=209.127.231.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="oEV4gVMm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774327859; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UNGt6uwbjokTjDJ7+m2kQ41XfvybTcSOEtIYxJbrjU0=;
 b=oEV4gVMm/2BPPZPip8xgAjn2Uxr6bHvHgdGPAH0GD903qUlzvSpZYZa97CE4Eb9Bt+ic/T
 P+y8Vng3upyZ7aS3OqRJlai4UoSGQJ4OFiSRwbwsasu22WmOZes+hO53tKr+oRax6k+lI/
 OUkdDq/vbtrew6KApntgRdNwL1bnKmf8WmoHL5+t4Mbkz0QaBC4XlsV+9hhlApH3mwUMjz
 F9n7qSDjBjcTLCM7d+ivXz8bRedHbOLsvNzk+tCE7IBgRZHnX9N73mg2W77DYtsLsQcksz
 eevVva646tRdBolST6PEEatjpoUazQ2GkzabUJV4Yx0wwG22aUkPAMP8KONzBg==
Message-Id: <4b210910448ef2227190f426e97614787d15d32b.53a515ea.f6d9.4988.8d81.b40b559c0503@bytedance.com>
From: =?utf-8?q?=E9=A1=BE=E6=B3=BD=E5=85=B5?= <guzebing@bytedance.com>
X-Lms-Return-Path: <lba+169c21831+a19ad4+vger.kernel.org+guzebing@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Mar 2026 12:50:55 +0800
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, 
	"colyli@fnnas.com" <colyli@fnnas.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>
Subject: [QUESTION] Using bcache to mask transient I/O hangs and errors from an unstable backing device
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi all,

I'd like to describe a problem we're facing and a proposed solution based o=
n bcache. I'm writing to ask whether this direction makes sense, and whethe=
r there is a better existing mechanism in the kernel that I might have miss=
ed.

=3D=3D Problem =3D=3D
We use kernel RBD (krbd) as a block device backed by a Ceph cluster. Due to=
 network instability and other infrastructure issues, the krbd device occas=
ionally suffers transient I/O hangs or I/O errors. These episodes can last =
anywhere from a few seconds to several minutes, after which krbd recovers o=
n its own.
During these periods, upper-layer applications (filesystems, databases, etc=
.) observe hung or failed I/O and may degrade or crash. Our goal is to make=
 these transient backing-device failures completely invisible to the applic=
ation layer.
To put it more generally: when a block device is unstable and may experienc=
e intermittent I/O hangs or I/O errors, how can we guarantee I/O stability =
for the layers above it?

=3D=3D Proposed approach =3D=3D
We plan to use bcache with a local NVMe device as the cache, sitting in fro=
nt of the krbd backing device. The idea is to let the NVMe absorb all I/O d=
uring a krbd stall and drain dirty data back to krbd once it recovers. Spec=
ifically:
=C2=A0 - The NVMe cache partition is sized equal to the krbd device, so the=
 entire working set can reside in cache. This maximises read cache hit rate=
. This is the most important.
=C2=A0 - We use writeback mode, so both reads and writes are served from th=
e NVMe first and asynchronously flushed to the krbd backing device.
=C2=A0 - The workload is a mix of reads and writes.
bcache already supports most of what we need. However, the current writebac=
k mode does not fully isolate the upper I/O path from backing-device failur=
es. When krbd hangs or returns errors during dirty-data flushing, bcache ma=
y still propagate those failures upward or stall the cache device.

=3D=3D What we think is needed =3D=3D
We believe a relatively small addition =E2=80=94 a new cache mode alongside=
 the existing write-through / writeback / write-around / none modes =E2=80=
=94 could solve this. The semantics of this new mode would be:
=C2=A0 * All reads and writes are served exclusively from the cache device.
=C2=A0 * Dirty data is flushed to the backing device asynchronously.
=C2=A0 * Any I/O errors or hangs on the backing device during flushing are =
handled gracefully =E2=80=94 retried later rather than propagated to the up=
per layer.
=C2=A0 * When the backing device is healthy, dirty data drains normally.
This would allow bcache to act as a resilience layer, not just a performanc=
e cache. The required changes seem modest and would not affect the existing=
 modes.

=3D=3D Questions =3D=3D
=C2=A0 1) Is this direction sound within the bcache architecture? Is there =
anything fundamental that would make it impractical?
=C2=A0 2) Would adding such a new mode to bcache be considered meaningful a=
nd welcome? I'm willing to do the development and submit patches, but I wan=
t to make sure this is not out of scope for the project.
=C2=A0 3) Is there an existing in-kernel solution =E2=80=94 dm-cache, dm-wr=
itecache, or some other mechanism =E2=80=94 that already handles the "mask =
transient backing-device failures" use case and that I may have overlooked?

Any feedback, pointers, or alternative suggestions would be greatly appreci=
ated. Thank you for your time.

Best regards.
