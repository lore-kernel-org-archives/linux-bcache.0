Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2475337F8B9
	for <linux-bcache@vger.kernel.org>; Wed,  4 Mar 2026 06:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772606509; cv=pass; b=CyrEpdX/pSm6BqXmn5FXxzbMdzeXiL8+vb9dgYUfNzDIFgGDAWhpU5HjcXCWWLBI9NO1xdkjN6Fz2FxNrth7jXWXGsqukr3KhIATuYlNH4r/HIiWKcELQbv716M744P8O9E81eijK73wMl4lvG/7HRraoGyGkeBQpOjmtt2PEY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772606509; c=relaxed/simple;
	bh=x/1AQIzKqy3eeGcRuT6KpUmiqylazmvdAnXXk9TfUJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uurGLeVQ7ihPnw7mmvJtJWfqR9FCf0DkrfTB1UJh0fPgH8fYdrNFx6S98+P2189Ilp7CMHl4YTXx0XPLdSkMWq9pEvO++C6lQO4cheRyEmTDYL+rTiVqohXSH3WnDam0WZlrR3wciQfXB3SoBgKd2hO5ukl3Y+296y3vlxNOQp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Izzjk3h1; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Izzjk3h1"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50336cffef9so57061201cf.0
        for <linux-bcache@vger.kernel.org>; Tue, 03 Mar 2026 22:41:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772606507; cv=none;
        d=google.com; s=arc-20240605;
        b=i5h5EY3bRwgDTWlEEnrLaPvPFMHc5RXT7vjjaZJb13mAryPg52hS/Hf3gCJeP0znXI
         jV67nHP0dW28ZYxVQjrzCRVou6ihn2jVNWaYqsN7FLPeznJnUp36kXmUUNULLkqZ0P9+
         uGPeLqnBbsSbFFvhlYeZ1EDbMPGd9PtbBmXkfVRKGK/sF2x016R5d+j3kY5r0aXrMt7v
         V8i88teY7yhV4P/cyVUETHgXVl0l8bJ/6DiXOMt2KCQ+pQTGSWUVIHQU4GmbI+JlLcj1
         ooRqokFIJni82MWEe/k9KTGicWJTIOt1YSr0BtAmtWv09oCX0IMetWMB2gUul/KQ5jCX
         Birw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fY5RR3f2cBt4YkmJTXjStwDUAMcp57BFkt8Mktxrb0w=;
        fh=iX+PZ9lXmsJqZJpzYVLDFfJRvEa05xGXuRH/DBPYNq8=;
        b=WhSLT1vB0bGy2QggybxVs2xjmXI131zpQJXPQjaIT9PM91JmZ+SQY0Z1txYcIJivgo
         xDCvX2rQGBwAr5BykL521O6J3Rrydjjc4NWfZnsihSRo4wrzFBQWp5iFLo69rUh4x3e5
         mSNCUvIz4VZhVWbsGgcjk67gTZOoD1JTPA3Wb5SMLSpjZpyHhgr4inbi63ak2HznAOKO
         HxnFzFSLp0nyjuUaKokqi8whI/vP3PwmOhOcbHeteZPD1tln14SyDvw++WEvi9M3B6O7
         LEd6RTJdVJc8NJTWP2+yi5aEbIdd5Wy7OkSlxUMBCvPxb/4nwi9EhEf3XDKxU/EJkTRX
         F1uQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772606507; x=1773211307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fY5RR3f2cBt4YkmJTXjStwDUAMcp57BFkt8Mktxrb0w=;
        b=Izzjk3h1cixtDsbVl43RD+4DcYQiY+2FCz5O9UEYUqeX8F5N47MWh6BF56uiM6O3Iy
         37IJcGQ/4SVg5bYEM6JHezJPRXHliwGocZEwGfV9aEfaT3yJ/O4amznXE/GYtDknSJu8
         toua3y9QplyRV33C9HAPIP2jFJnvErJ5uIgsnV3fH9wbD1aPXX7qeujJNbPhixbEoZRF
         cm3LFfNGY/HnlS1L8L1760TLpFmQUrdskytgjRO/lo3h+DBGuclYBFCDVcsU3Li7Zsb6
         QACm/+b8i1wvM1Gm+btaY+DMj2VVU1G4M0nRgW0jd+jGnzPKMtHlrJkdPFcnNnwXILg4
         p09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772606507; x=1773211307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fY5RR3f2cBt4YkmJTXjStwDUAMcp57BFkt8Mktxrb0w=;
        b=UuLxlRxZzJMX25Lfrwq0+J8bjgQn6HOyGX7C6agURavEmIt38b5OTo68T254DvAiu0
         iObFFAKrrHj1HdiXu9MNwDteJj/abk2zkWeOTx0BFnKGNfyU6vQHPLXNMVljeDRaoW/3
         84aRDyXiNy8xcpOdea3w6s42Gsb2PxK7CdTv4szEJv8kCzYexuGNvlbsrsFERKs9n19I
         tzPoeUc8/dqF5e/VzjE4XBoI6C1ITrUPVJnmOFqLC6MPs8oobggDpRLENRkThaDrIkrH
         ChBj/ehWHnsf4kG2fYPjhzDnU3qDC0VXScVVg6OCl1z/qXRL5j73FjZQm/tnXCpUC/Pe
         F4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUypDIpZodhed+wgf5fUd7jYgmLko/fJp3Jr+5KWysRo8xlddMSnNJAkaNFYtn5i+bXrjX3PSQJhGAy5Hs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6swBM3Kal9/gq+yZii0vIGvtaGRGP+dNpo64S0ZlCU5ir3eqm
	ruc/mZQkZ4/oBxCg4aTX66VzBtwNEhLBHFC7tuzhrY6/AW0EreW3Jkqk5xiXglYOkv6USCwjmg+
	G/YoVi67yERJJH536ZO72N9GZ3NicFiFaETZLd/k=
X-Gm-Gg: ATEYQzwvc1QKEXloinB8zvnEOc9whymdIPP0skAbYRJMhJlwt6jvMqZCweWYajdywbM
	+Sq1JNfyQSv5E/BeS5CqgmuzJfpm9jbFn8pS6b5XwglBX13TRpr46meYUrBSk4R8ApH7UUp79pd
	JBrzc+WmJ1TimYoc4QqbfjXY7Lf1FqwkHw1YBNdmociJgfV5ExHxNQhpI0e//AywMNQrdkLvvcL
	PwaZMvBhKG8LD610X22DLX7xr/rOKoakr7SuR0xqj38fg2VBCi1hKk3bxCLfloXRa5x4WniiN0S
	pwBlbw==
X-Received: by 2002:a05:622a:11d0:b0:4f4:c104:8e9f with SMTP id
 d75a77b69052e-508db41c1fdmr12539911cf.75.1772606506980; Tue, 03 Mar 2026
 22:41:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de> <37e2c5a5-d797-4176-98c7-0e43abaa1af8@flourine.local>
 <aaYwWwGHdoc1uMCu@shinmob> <f7cff08f-a3e8-4b2e-ac7a-a56d8ed3f2d5@flourine.local>
In-Reply-To: <f7cff08f-a3e8-4b2e-ac7a-a56d8ed3f2d5@flourine.local>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Wed, 4 Mar 2026 14:41:11 +0800
X-Gm-Features: AaiRm53iNAp6g1g2jz5IP61Qal0wvsHlURp_wIEZA5Nd2eRgAa8MqeGIj0LN7AA
Message-ID: <CANubcdU92Uv7wNdZH357LLTnfwPouekXNTPSjHnzYzK99-eZ9w@mail.gmail.com>
Subject: Re: [PATCH blktests v4 0/3] bcache: add initial test cases
To: Daniel Wagner <dwagner@suse.de>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "hch@infradead.org" <hch@infradead.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Daniel Wagner <dwagner@suse.de> =E4=BA=8E2026=E5=B9=B43=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=BA=8C 16:04=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Shinichiro,
>
> On Tue, Mar 03, 2026 at 12:57:18AM +0000, Shinichiro Kawasaki wrote:
> > On Mar 02, 2026 / 14:54, Daniel Wagner wrote:
> > > On Thu, Feb 12, 2026 at 04:23:30PM +0100, Daniel Wagner wrote:
> > > > I've updated the v3 version with the feedback from Shinichiro for v=
2.
> > > > Shinichiro, please note I did rewrite some of the logic in v3, thus=
 some of your
> > > > comments didn't apply. But hopefully I don't made a big mess :)
> > >
> > > ping
> >
> > Daniel, I wonder if my replies [1][2] reached your mail box.
>
> Sorry, no, they didn't. Yet another hickup with our mail server...
>
> > [1] https://lore.kernel.org/linux-block/aZQZkjEUw9VnVauX@shinmob/
> > [2] https://lore.kernel.org/linux-block/aZQcH-d-ZcgtMoJb@shinmob/
>
> I'll work on this then.
>
> > Today, I tried this patch series again on v7.0-rc2 kernel with the
> > TEST_CASE_DEV_ARRAY below:
> >
> >   TEST_CASE_DEV_ARRAY[bcache/*]=3D"/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2=
n1 /dev/nvme4n1"
> >
> > And found that new files named "nvme?n1" are created in the current dir=
ectory.
> > Do you see the files created in your environment?
>
> Will check.
>
> > Also I saw the failure with the message "ERROR: Accounting leak detecte=
d!" as I
> > noted in [2].
>
> I am not really sure if this test case should go in the current form.
> I've just used Stephen's test case as input for figuring out what kind
> of API is useful. I also see the leak error with v7.0-rc1 which has
> 3ef825dfd4e4 ("bcache: use bio cloning for detached device requests").
> I might have done something wrong here.
>

Hi,
I noticed an issue with the test. The 100% utilization shown by iostat
during active I/O is NORMAL! The test is flawed - it's checking
utilization while fio is still running.
The test does:
1. Start fio in background with --runtime=3D30
2. Sleep only 5 seconds
3. Check iostat immediately (while fio is still active!)
A real leak would show persistent utilization AFTER all I/O completes.
During active I/O, 100% utilization is expected behavior.
To properly detect a leak, the test should:
1. Wait for fio to complete (wait $fio_pid)
2. Wait a few seconds for I/O to drain
3. Then check iostat
If utilization is still > 0% after I/O completes, then there's a real
accounting leak.

Thanks,
Shida


> BTW, iostat could be replaced by reading directly from sysfs,
> e.g. /sys/block/nvme0n1/stat
>
> Thanks,
> Daniel
