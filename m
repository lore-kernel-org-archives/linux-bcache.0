Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD9B18FC97
	for <linux-bcache@vger.kernel.org>; Fri, 13 Mar 2026 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773412569; cv=pass; b=bfb1PGH79McaIqyCzembFtbHWI+AbhaAv7v0hLTgL77DefZq15u0T46lYWtjCsXur6bJHHVEGFAyQbhCrOEja0DY96EsJAnVQQejb8u//HhqIMbg5StIOSeTWHzrsJothtdMqeQLidntYA2UwYUV1EjL7BZ8tSGMQLEh4BEl1y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773412569; c=relaxed/simple;
	bh=ufun1Wcths+rb07VUe3k8d704B6RETyuxyIo09gQ9pQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UyuOxfn5pXOXUv4Zn7RxIMja9o30xrQ8POTsz12TqGbc7NXgJx/rl3pZ+Ka7fB5r+3epO7rS1BUHUy+64yzN4LCfOQI8GpsNLmUnU6wyYbYdKPzDtcoR0ahBu5MYRFMmZh3T/R5/SF4XGqs/2dk8lnr9hQy7sPpK/hGPX9CTp94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6ZXGJTi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OHtN0vcj; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6ZXGJTi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OHtN0vcj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773412567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
	b=Y6ZXGJTi753gPM/nt0f6JeBWBlrzyg1lHgAMsAqF0v7Sta55Lk8e6juo0cVe05CGr8Uvgl
	QnoWefYh8y8bcnXi7STTlt1Lt54N+7s8z2F0ZeIyl1GwY0XhsJryiivKcb7IjuSvUodyOR
	ZKXse1NAlIHbJ+/RzUGD3844KYxCvNk=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-X1KvY-oBP3W5nsH4jMUtkA-1; Fri, 13 Mar 2026 10:36:05 -0400
X-MC-Unique: X1KvY-oBP3W5nsH4jMUtkA-1
X-Mimecast-MFC-AGG-ID: X1KvY-oBP3W5nsH4jMUtkA_1773412565
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7986944a367so24792147b3.0
        for <linux-bcache@vger.kernel.org>; Fri, 13 Mar 2026 07:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773412565; cv=none;
        d=google.com; s=arc-20240605;
        b=KFrHeQYbn3UkEXSxCmETQlAVdkqXhinqI56PmKqIyB9NHLXSw/xBZ4zCC/PnTgDjWr
         RInmbFjdw1QlbM+UNxa8d39ZthCD0Wsy393FWQ8vdQApsKJGZqSKGtNr2rfc4K4xIyKI
         C0h/6o3M1hD/Ezm/TDJcaXFUWeFAbwqphV3ECbjZaec/XfEZi6l8Pr7HB29/KeIWPHiK
         MYK+FFzIc74DqprtalAeFKwIw6pRoUMsrcYpHydOnvcytVV+VaFuOIAjr+qQ5uOtFiLP
         YMFT8f0xr6qXY1S49FEeWWB8ctg/3MDIALhGFONjLcwRw42EV2LswL6EN5DTNVigrypF
         +/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
        fh=yz8VDaf9Hlo05gae1O9cWMZwmh7XjCqQ5daGkwWrR6U=;
        b=SKSwSGj7ZoeNC8xfhrSYmO6h6HuiYpVlxWY6S+MrOHUQ+FXdzRPf9InFlBv/59X5Qg
         C34zki+TnYxrYgIT3UwYM6SfRMKmEPmCnkk7S/8O0wpiMzsPIGmPxomQASr3anGMzddx
         5zcQwF0FFfKpPrBqKtZoWQmQT7VQkI8WSPRgvNQqCMqh4wRQWFy05vpI2uR+foxvRVth
         oG7H6zqPpFuBls4Ff0NK+cFURhXhkFZYFRjaTCHQaWocOKxl9s7esRmr7vTRfl5b1S2Z
         cMt/OxFxTS5I6cIX+Mm3tzUFVid2ZkoxNeb9hA57jL7FdKmU8bIELZtn/TWDzTWJOF/i
         ktbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773412565; x=1774017365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
        b=OHtN0vcjn8vPBoEPCjRNNwpd/v8rJlIfe1bWU3iq3Ii3pNBGXTD5NNgSkfQJPsBkbn
         XXx5vHbj2YB4kT1Xu7AmgtvUEaSGQbjvGfykL/VUGzfCJCoLjF3RC+LH5O37/TcW0fes
         nuY5qWLf+Dtkl8w11W9YrCfZMjmTttNtL+6v+ub3djxT8TIMhr0HumayysblADnsDOj7
         aGj5xRdz+j86PGM1Ea6hCLo6cuH4CONejZ2rPIxrlDRG0kUGzFXpulFHawBPJGLhYSaH
         tj3zy/SzlY/xUXYEPVsIdz/k8kJyrTBcWc9F7pq0Iwh5Se7Kz3VLhp/qUBLm0asvz7ea
         kgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773412565; x=1774017365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
        b=A+K+FKU+cXBDMHZ4Lqj2N5B5lpsEhf/hk6ByzoMS5jejElsr1tDH6aAx6Xkp+ayRX/
         ETaT+DcPaKGIZNNiesrX0f5EwsWRXlTbdiLt1D/u65aIRjjJonzRm25GODiEgsi9cMda
         L0pnJ4lBZ1U4tURGijx+orVwDgnjZCjF8MSBQ9gPz3l44cqXqsKBrJSh0S9e8WND7TG6
         swCxC6PyF6xi8fLezxRMiqWcPT0nIILLyR9kjb1TrYgurGHv6j+DmTqZnT1FoDQy4/u+
         7x3VVi5tHyz/5CYJMqEVDFBufQG1bLv5EhBBm7Dy5QrpM+1R4kaam2RkG3Br29Y7rwa9
         yA+g==
X-Forwarded-Encrypted: i=1; AJvYcCUXHCTR4lWV/AF5JYx1Pqup1Gz3Rys/2QTZ5mVIDnYIrdSfg5g4lYAqNHlZ7JOWc1XeH3SJ4eQHDKZoNfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiyOUApP6iRObGnk1AplT0LcvydDKSTHKlhCIDY/wgFWTAAY1m
	vIGfjMIOHraS8/44OCd3wvrg1EAWgXz4n7Jdv56poUwoCXXI/FCOVm5dTTGfuax/ASufrEoQvL9
	UtfOM/xV1pXSOiNRRBp0nb2PDl7QD2DfFNjSLgrn1Pb4csBTANz5Ur9pkx/Rb0jlm86xnyUk+8M
	Xi72VufIpUCC8TzS582kbVSYKVyA4m96z535rlf90H
X-Gm-Gg: ATEYQzwHo8slWpCKgLfOiLM/qAwnYfihcGEgESNY//OQAVZCH9N03pMEI6ezuGEvURh
	S0uPjdKgW7DSVoZ6om+Kuo4dbkyVTlmLGSUrVS2UzywA+zv9vzqTkuHUHCc3mlcr5n20D6/WrM4
	At+8NCbU/lj8P2DoZ0+6cL+5fPYzxO7Mmrk1ZiH7IUOsbvy84kVBO7pyYnT3U3Lgg+yj2/uf+yW
	umCiQEUOjwxoJVVJm16DyyWntxjUagNsBCnQZYpwFr3C2eH5EHzlwdzaxSEgu5yAA==
X-Received: by 2002:a05:690c:c1d5:b0:798:711f:a0a5 with SMTP id 00721157ae682-79a1c10febemr31150407b3.29.1773412565242;
        Fri, 13 Mar 2026 07:36:05 -0700 (PDT)
X-Received: by 2002:a05:690c:c1d5:b0:798:711f:a0a5 with SMTP id
 00721157ae682-79a1c10febemr31150237b3.29.1773412564819; Fri, 13 Mar 2026
 07:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304190424.291743-1-agruenba@redhat.com> <abQHNzJ0FR1EF0NX@shinmob>
In-Reply-To: <abQHNzJ0FR1EF0NX@shinmob>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 13 Mar 2026 15:35:53 +0100
X-Gm-Features: AaiRm50KyYlBUXDBLdnEEHXDx37wzlGjPP-UmRDDKX74QQoo2rYJKifETYROgh4
Message-ID: <CAHc6FU7bab0+snOVBog-FZkn_sy3AHoEP2SNFxdZ-n13tAE5Ng@mail.gmail.com>
Subject: Re: [PATCH 0/4] simple bio cleanups
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, 
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
	"linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 1:54=E2=80=AFPM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
> On Mar 04, 2026 / 20:04, Andreas Gruenbacher wrote:
> > Jens,
> >
> > here are some simple bio related cleanups.  Any thoughts?  Can those go
> > in via your tree?
> >
> > Thanks,
> > Andreas
> >
> > Andreas Gruenbacher (4):
> >   block: consecutive blk_status_t error codes
> >   block: get rid of blk_status_to_{errno,str} inconsistency
> >   bio: rename bio_chain arguments
> >   bio: use bio_io_error more often
>
> Hello Andreas, during blktests CI trial runs, I noticed that this patch s=
eries
> triggered failures of three blktests test cases: scsi/004, scsi/007 and
> throtl/004. Do you see which patch triggered these failures?

Hello Shinichiro,

thanks a lot for the report. I now see that patch "block: get rid of
blk_status_to_{errno,str} inconsistency" is broken in its current
form.

Andreas

>
>
> scsi/004 (ensure repeated TASK SET FULL results in EIO on timing out comm=
and) [failed]
>     runtime    ...  3.855s
>     --- tests/scsi/004.out      2026-03-12 15:23:54.664435639 +0000
>     +++ /home/fedora/blktests/results/nodev/scsi/004.out.bad    2026-03-1=
2 18:13:40.059747989 +0000
>     @@ -1,3 +1,2 @@
>      Running scsi/004
>     -Input/output error
>      Test complete
>
> scsi/007 (Trigger the SCSI error handler)                    [failed]
>     runtime    ...  115.385s
>     --- tests/scsi/007.out      2026-03-12 15:23:54.668435644 +0000
>     +++ /home/fedora/blktests/results/nodev/scsi/007.out.bad    2026-03-1=
2 18:15:55.054944537 +0000
>     @@ -1,3 +1,3 @@
>      Running scsi/007
>     -Reading from scsi_debug failed
>     +Reading from scsi_debug succeeded
>      Test complete
>
> throtl/004 (nullb) (delete disk while IO is throttled)       [failed]
>     runtime    ...  1.643s
>     --- tests/throtl/004.out    2026-03-12 15:23:54.710435695 +0000
>     +++ /home/fedora/blktests/results/nodev_nullb/throtl/004.out.bad    2=
026-03-12 18:20:46.314368581 +0000
>     @@ -1,3 +1,2 @@
>      Running throtl/004
>     -Input/output error
>      Test complete
>

