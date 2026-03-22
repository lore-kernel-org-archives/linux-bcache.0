Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E650C1B4F2C
	for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2026 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774189843; cv=none; b=W74/fUSg/RAfTITnKGxeajajgoO6scw0sSpd1jiImuURgmh9R96+lVTUMOFBw4yxqIWBvdBx+CbRhgC6VlNmITSNgSuKLXdIZ+78fJEdUmgmTKFZQrRRDN8C3kbMVFCFV4t/2THu+BalptzS3eckJk29xPTXL3kJdKkbvo6wzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774189843; c=relaxed/simple;
	bh=V+YRdvkTSoa/d+GYqQRAYGQCkJMJpcL8Htec9eIAdgY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=afxEUe15qVg3NbItNlivWm66ZrF/uiG9C/qrjpzc/UjP1f1x8iCDHS12WzDoKG95QPQgp4uUjQZ8eeeFsrj9JBpJV/L5Qp8/jZyWkFo7URiQ9b5NT//EQeJLk5FfflEhH6iUjMd5lxU3l7tUyka81kRNRdyGPPHAjLasnWPbGVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q0Hl8Vt2; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q0Hl8Vt2"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-466f1c3c627so1304191b6e.1
        for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2026 07:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774189841; x=1774794641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHK1YAHhATX+BOrgvNcOMGXM1iLk+EcLOH7Ra7adyWU=;
        b=q0Hl8Vt2E/hKdFWOG7lJfkpSPyMe40OS9nVR99NMW0WPhu1wXp59/kL/vMe9Dm7E1D
         ihM4MhftzEtJXRYwvF0JHF+reFf2ql4ayZGTYVbe5gwXDRHigKK23lhHLn3x/Xj1Eqjd
         Zf0aRu30Ls8lZHY1kEFAJlfA2pJUfsXwqfNqYXse/bzGjEWFN69juAyldy97thzN1jeP
         q2QyGI4EG1BuD63gJCV61xlvHlmhKJFsgOQ43YUzDMQJpTwNiiPyLjsITayF5Csh6wWX
         /UZ4YXaZRLg2NSbdscuY1g1vxmKTudr7C5jO0Fu7PGhTxvNoAEztyYpSm2ohz500lmkq
         rrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774189841; x=1774794641;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HHK1YAHhATX+BOrgvNcOMGXM1iLk+EcLOH7Ra7adyWU=;
        b=gl7IqnmRgIy2JIv8+bfD46hMVd/R2jDmTAkinNdBx72ipEOUWYJ6hCLgCqL3bwgkcx
         dYI7c1r8EIjkzqUoeASlDXfdIqmmXE4IlgGMZyDAGulYBhxc5hfOIW+peUeQ2zl9XIbU
         1mZgiH9h/+8aPlMU2NvaYVN3GPK8VtYlNTv0pxBNueGQExjyuVXKsQb4CtSPPlyTjzrn
         G5sqLn9de88UV1hHFtlWQjjsmYLFAg0CwT9iOcRz3c12rQVRDKGXuPNlMI0XKr5Qk+qN
         2sitD5hpAMLtYkYcGK9YlkDePS5orS1/Mril28qYFFUm+xaoY+mvm4bxCQBYVOzkGWlX
         La8w==
X-Gm-Message-State: AOJu0YxugqLwK1ky0PzN/TPqxKxggN+Ku5Km/n99ckX/gtOUwKMEOua9
	HdmTOiECufJKGnZuP7DOad19f+TZENYscTOc8IyUTR0vxmjVVvw+zUcIR4uEAEonyo4=
X-Gm-Gg: ATEYQzxYV1GDXvQ3sAcyBlLf+hkR61p2Yxn8lbTRP3S4K4z50vpEW34uHiBb6Vw+7EH
	1Dc3ouaL4KlsbzxMtjFG11p+brGsZ8BW2TDyfNEUA6YS+mMeZ1CF35Xh1XNWDBoO4RZM4177nm0
	wM1XFg9OrPVN8DKzVVC0+6+iKC566yo6OZAFCJWcgY/C/Uxi9xIegOMqiPY8fznu/D8+aTOaFkO
	xnTFqXQnhSJdVStzeiVkqgAMDaFG3bMPG7RwSYp9bZ2f5ypIQ6g+ZogPdqq04pKSSaiFzHjuQ/o
	5oPmzjltiuayN8l20hkD+n5CiSenna5WuJrGjEETEZx3rm8c0STlICFOcxq/Z1zeXwd/Nbm/c8b
	TAUThbEeA1rG9ThWlkxRoTnFdZRicq5ootdspL0cqIMuDbhjiNt79snJBfynguHgtUOFzBy7Ej+
	tLf8OIb5KV+kFIrKSx6RD5BRKP7xYzI9hOD+jEdwlG/iqwh5b/zOlTPrAqhi6wg/6BIzj8lXzb5
	um0
X-Received: by 2002:a05:6808:c1b2:b0:467:4939:967f with SMTP id 5614622812f47-467e5fcc1fdmr5356813b6e.48.1774189840902;
        Sun, 22 Mar 2026 07:30:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14d64fbbsm6629011fac.9.2026.03.22.07.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 07:30:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: axboe@kernel.org, colyli@fnnas.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, 
 Mingzhe Zou <mingzhe.zou@easystack.cn>, stable@vger.kernel.org
In-Reply-To: <20260322134102.480107-1-colyli@fnnas.com>
References: <20260322134102.480107-1-colyli@fnnas.com>
Subject: Re: [PATCH v2] bcache: fix cached_dev.sb_bio use-after-free and
 crash
Message-Id: <177418983975.306181.7832678653109865447.b4-ty@b4>
Date: Sun, 22 Mar 2026 08:30:39 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.0


On Sun, 22 Mar 2026 21:41:02 +0800, colyli@fnnas.com wrote:
> In our production environment, we have received multiple crash reports
> regarding libceph, which have caught our attention:
> 
> ```
> [6888366.280350] Call Trace:
> [6888366.280452]  blk_update_request+0x14e/0x370
> [6888366.280561]  blk_mq_end_request+0x1a/0x130
> [6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
> [6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
> [6888366.280903]  __complete_request+0x22/0x70 [libceph]
> [6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
> [6888366.281164]  ? inet_recvmsg+0x5b/0xd0
> [6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
> [6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
> [6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
> [6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
> ```
> 
> [...]

Applied, thanks!

[1/1] bcache: fix cached_dev.sb_bio use-after-free and crash
      commit: b36478a1fece72b5d4540141fd31024dcba1d241

Best regards,
-- 
Jens Axboe



