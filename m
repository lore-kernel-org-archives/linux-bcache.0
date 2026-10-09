Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19253DA7D3
	for <linux-bcache@vger.kernel.org>; Fri,  9 Oct 2026 04:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791521698; cv=none; b=JpfXXEZNXfwQeXwJ9IgHMpCtRHA7TgaHyC8RwyyYBFSbOJupEElcJx8C4KoyPYhEhYPHyuLoXsyQQKJP3tYrr74Ero77INdoKZTs6dRwbFd2hKtAKjxsfep6BuZIpdr9Odw9WNEnAhhihUdoN5FwND/T+s0SDfFM6uKW0qKd3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791521698; c=relaxed/simple;
	bh=DIRk21HokdTSAgRLFnpl2MTrUjmorc2ECQiIsB258+k=;
	h=Date:Message-Id:Content-Type:To:Cc:Subject:Mime-Version:From:
	 In-Reply-To:References; b=Q+hFdHKXCHZ8NLVsstRir4t9fpDjpbgAyOPoEjwnzsNzRa4fcXXr8NhLeUU9UAmbIkXMqf9a1yAP406Kh1kBQl5+Uh74cI+MSpyfhY4hR+Gs5E2l315CKaEMdi5z4upBg+0yLxMT3AbNQsDhNiaHcpW+ew5o8L78gKM8nIjWyWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=LQ22D4rA; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="LQ22D4rA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791521683;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lMxLojdbWEodOf0rB6+VR3CT5U8sc69zm9YL1rBCKX8=;
 b=LQ22D4rAOsTeY95Y92I1UP0WIIV1TUzgrbGHSWNc/4BqQeae+x+2vzdM6PtNBVsPGLQ7hw
 UlEokgHYYcyszwnHM5LuvXTdR0KZam4FTaI45JxnbRf0neupWs+35TylZHVvb2xNqdoi1U
 x+9eeAnl75YceaAJ1SXU5PX7jGNlfev9wUSHEv5udvpcTASVn56O5wDwJpT5dMVWCED1GA
 PCyHOcbJVLNo0cN/ffEjtkhTgnYndSzgyOcqzkBg6xd1Fd2xqc8umZpsEB0XCX8cTleawl
 WobvGa6Vv9L3R/vXgzzoYcw9v8PTLkRWQp7lWC8l8wtqocQUueY6pe+FA3LXuA==
X-Original-From: Coly Li <colyli@fygo.io>
Date: Fri, 9 Oct 2026 12:54:29 +0800
Message-Id: <2051AAAB-4FC9-4093-825A-ADFEE5438EB7@fygo.io>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
Content-Type: text/plain; charset=UTF-8
To: "Rosen Penev" <rosenp@gmail.com>
Cc: <linux-bcache@vger.kernel.org>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: fix kernel-doc warning on CLOSURE_CALLBACK
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ac87392+b8c202+vger.kernel.org+colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
From: "Coly Li" <colyli@fygo.io>
Received: from smtpclient.apple ([120.245.64.82]) by smtp.larksuite.com with ESMTPS; Fri, 09 Oct 2026 04:54:41 +0000
In-Reply-To: <CAKxU2N8WtY+=dhSTfyu=8ujEwnkcfV9PEkXxuTLHthwksDhTxw@mail.gmail.com>
References: <20261004233523.516891-1-rosenp@gmail.com> <ashiQ98Qmie63mB2@studio.local> <CAKxU2N8WtY+=dhSTfyu=8ujEwnkcfV9PEkXxuTLHthwksDhTxw@mail.gmail.com>

> 2026=E5=B9=B410=E6=9C=889=E6=97=A5 12:09=EF=BC=8CRosen Penev <rosenp@gmai=
l.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Oct 8, 2026 at 8:41=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
>>=20
>> Hi Rosen,
>>=20
>> On Sun, Oct 04, 2026 at 04:35:23PM +0800, Rosen Penev wrote:
>>> bch_data_insert() is defined through the CLOSURE_CALLBACK() macro, whic=
h
>>> kernel-doc cannot see through, so the kernel-doc comment above it
>>> produces:
>>>=20
>>>  request.c:308 function parameter 'bch_data_insert' not described in 'C=
LOSURE_CALLBACK'
>>>  request.c:308 expecting prototype for bch_data_insert(). Prototype was=
 for CLOSURE_CALLBACK() instead
>>>=20
>>> Turn it into a regular block comment, and drop the @cl line along
>>> with the kernel-doc markup.
>>>=20
>>> Assisted-by: LLM
>>=20
>> The patch is fine to me. Can you provide the detailed LLM name here?
> It was Opencode's Big Pickle IIRC. Current documentation says to just say=
 LLM.

Documentation file coding-assistants.rst suggests,

 43 Attribution
 44 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 45
 46 When AI tools contribute to kernel development, proper attribution
 47 helps track the evolving role of AI in the development process.
 48 Contributions should include an Assisted-by tag in the following format=
::
 49
 50   Assisted-by: LLM [TOOL1] [TOOL2]
 51
 52 * ``[TOOL1] [TOOL2]`` are optional specialized analysis tools used
 53   (e.g., coccinelle, sparse, smatch, clang-tidy)
 54
 55 Basic development tools (git, gcc, make, editors) should not be listed.
 56
 57 Example::
 58
 59   Assisted-by: LLM coccinelle sparse

Yes,  only listing LLM is the bottom line, and list the detailed model name=
 is better.

If you don=E2=80=99t want to post v2 patch, you can give me a line of Assis=
ted-by: , I can replace it in the patch.

Thanks.

Coly Li


>>=20
>>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>> ---
>>> drivers/md/bcache/request.c | 3 +--
>>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>>=20
>>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>>> index 3fa3b13a410f..e7f097346d64 100644
>>> --- a/drivers/md/bcache/request.c
>>> +++ b/drivers/md/bcache/request.c
>>> @@ -285,9 +285,8 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
>>>      }
>>> }
>>>=20
>>> -/**
>>> +/*
>>>  * bch_data_insert - stick some data in the cache
>>> - * @cl: closure pointer.
>>>  *
>>>  * This is the starting point for any data to end up in a cache device;=
 it could
>>>  * be from a normal write, or a writeback write, or a write to a flash =
only
>>> --
>>> 2.56.0
