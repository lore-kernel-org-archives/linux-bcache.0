Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A4346C4A5
	for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649561; cv=none; b=YRvDohOYJXhwj7WmYWhbf3CCU/NSWUGa4l9Lwwkej7eECHcGPoX0mbwPLQ4D9vkNHMaWm4kcvLgzGX+Y+/Reg7ZU++qLrLrW8/+a020LxjbXCXQf47YbR0vvvaojpY0PqY03nHGz/KtoXBKnVBPP5RgFbJo9dDjufMhdzhyHPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649561; c=relaxed/simple;
	bh=qwHbx2jV7SFI/v/1k/rAgWYOMTSq5LiDCWOfmWedO1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKUzEt0C9tugwlDgDdFtQUhzaDaKc06hUVmtrmri+AtxYbZRMzfm5TS8mk4dD8RUuZCWmDtQzEk1h1GkZyeYqZXJf8TfY1Nm3ufM+frORzi6kAF4XKRekygX7563woJzR90BQQvI6MZdy8mgM1iJmcr/kZnF1+vAHXOFVBv6AEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z655I5Ch; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z655I5Ch"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2caf4173b1cso165109005ad.3
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2026 08:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784649559; x=1785254359; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dp9XP4/tBbCGxcyaahXau3Cz1lTBhAkt8+2pZA6U+mM=;
        b=Z655I5ChZmZzY6XcDwjRBmsh3uvEeWQpim/r0OaowE5kwYUjlT6/VxGfzBhoF9kV1R
         Zj8xapigOwuB1VVgKt0hUuOZ6ngsZm/O7pH+26Dholoyc44BYZfxYcO8pvQN3CveWeXv
         7K21r/7+WPcpqnrPx28Ht6nBwWrpV+Cq538cnW4dbZjuj4k0xgQzXkXy6TEP43XWdRsK
         6PQp6FPv4IdaFA9hCVRc18WPWAD2kcSUGpqzbyIITmWuJ1YkhAyC0GrEmQiw3sg8tTpL
         RGvGNKm/F+fMaI4/wCqjfZ/Pf/m8MSnS0+0oHBo1aRuBCDnBTjsFeA489mm0pRB8jgrN
         NVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784649559; x=1785254359;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dp9XP4/tBbCGxcyaahXau3Cz1lTBhAkt8+2pZA6U+mM=;
        b=BANF/kbD8moQrIPSgdrlUwIRO13Yhg4uB9phAF37lVup8yrZ/e5JT9zeD5VrGqRjSH
         Jwu/rINtMZ5AuKckEBNBY2kNCUP8WpaPKgVZty3tzO1eiS1iuXi3rmi7VoomNv8r6tul
         clXmvo/XjerUL8Usk5SQ9NPgG8bXX3bEc2WrlVBrNU+4X3MiRTD96U7NJFa5ZfKhld0T
         bcuAc/Ez8v4wsjvBJCReFOvHt8lSaoyN97DGpQU1TzfldtO5Rb9NYA6zYCePBFx5BkoF
         whZSuuMMGyPD1iHJsMuR9DULCN12zd7Dy5k+21gtVHsQ54NhIYGZ5VeN7QWI/Ec4yN5K
         ym1w==
X-Forwarded-Encrypted: i=1; AHgh+RpFQ0SYyWQX3c8fDPBFMMhEyLnMZXKpn4jdR7mpbdM7bTJ7k94EiVnconkFZH5iL9HIDhmZxOna/Rjen6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLEESOoxWXfSt5gi0Kxv0/PseDoTdOh0Sp9klAS7ENJ0dD9A1X
	rp+jjJ/U1CYKaDhkIkMwW2AZ0Mtc5QPHoGVjbxtCgK0mk8HTUNMLLPkRcxNK05adjOa0AghqQSd
	xEn5kEmX6UQ0IyQ==
X-Received: from pldr4.prod.google.com ([2002:a17:903:4104:b0:2c6:a4ed:efee])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d984:b0:2ca:11af:5ee9 with SMTP id d9443c01a7336-2cf3494b34dmr210203205ad.25.1784649558421;
 Tue, 21 Jul 2026 08:59:18 -0700 (PDT)
Date: Tue, 21 Jul 2026 15:59:16 +0000
In-Reply-To: <aktbz_M12q5TpGEu@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aktbz_M12q5TpGEu@studio.local>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260721155916.3238369-1-ankitkap@google.com>
Subject: Re: [PATCH v2 1/1] bcache: track active bypass writes to prevent
 stale cache reads
From: Ankit Kapoor <ankitkap@google.com>
To: colyli@fygo.io
Cc: ankitkap@google.com, kent.overstreet@linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Jul 2026 13:14:52 +0800, Coly Li wrote:
> Hi Ankit,
> 
> This is not an easy and simple fix, finally I find a long enough and
> peaceful time to reivew the whole patch.
> 
> Thanks for your patience. I add my comments inline in your code. 

Hi Coly,

Thanks for the detailed review and your comments. I am currently working on incorporating your feedback and will send out a new version of the patch soon.

Thanks,
Ankit

