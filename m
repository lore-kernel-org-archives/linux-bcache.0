From: Ming Lin <mlin@kernel.org>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 29 Apr 2015 11:00:02 -0700
Message-ID: <CAF1ivSZMg-LeoEqODzDprKkF4jY_cB6yuKUR9-z12Bs9FeqQrw@mail.gmail.com>
References: <54A66945.6030403@profihost.ag>
	<54A66C44.6070505@profihost.ag>
	<54A819A0.9010501@rolffokkens.nl>
	<54A843BC.608@profihost.ag>
	<loom.20150105T010336-763@post.gmane.org>
	<tcfnqb-u59.ln1@hurikhan77.spdns.de>
	<CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
	<alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com>
	<55257303.8020008@profihost.ag>
	<alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com>
	<3ldgvb-het.ln1@hurikhan77.spdns.de>
	<CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com>
	<5a1mvb-6k.ln1@hurikhan77.spdns.de>
	<3k5mvb-c14.ln1@hurikhan77.spdns.de>
	<CAPL5yKdfdtwPOQM-edwNJPkQDoBR2Oyagb6JWRP+-26xQvxyKQ@mail.gmail.com>
	<CAPL5yKcGvjC7ubzdKNjCFX6ZLc+qrr-Q0BQCX6W0zbueTkndPg@mail.gmail.com>
	<bf0nvb-uvd.ln1@hurikhan77.spdns.de>
	<CAPL5yKfpk8+6VwcUVcwJ9QxAZJQmqaa98spCyT7+LekkRvkeAw@mail.gmail.com>
	<albovb-v7m.ln1@hurikhan77.spdns.de>
	<CAPL5yKdFhQ+7wwfTj-8i6bm1RHGKZbMPNzEEt=rffKqeRQEn=w@mail.gmail.com>
	<CAPL5yKe63Q4mTkNqvVW1jYAsdU=ftS3eQS+RzhCpX1WxcXg3hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59833 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031701AbbD2SAF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Apr 2015 14:00:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 34CC2201C8
	for <linux-bcache@vger.kernel.org>; Wed, 29 Apr 2015 18:00:04 +0000 (UTC)
Received: from mail-vn0-f50.google.com (mail-vn0-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 4693F2015A
	for <linux-bcache@vger.kernel.org>; Wed, 29 Apr 2015 18:00:03 +0000 (UTC)
Received: by vnbf129 with SMTP id f129so4295118vnb.9
        for <linux-bcache@vger.kernel.org>; Wed, 29 Apr 2015 11:00:02 -0700 (PDT)
In-Reply-To: <CAPL5yKe63Q4mTkNqvVW1jYAsdU=ftS3eQS+RzhCpX1WxcXg3hQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Dan Merillat <dan.merillat@gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org

On Wed, Apr 29, 2015 at 10:48 AM, Dan Merillat <dan.merillat@gmail.com> wrote:
> Killed it again - enabled bcache discard, copied a few TB of data from
> the backup the the drive, rebooted, different error
> "bcache: bch_cached_dev_attach() Couldn't find uuid for <REDACTED> in set"
>
> The exciting failure that required reboot this time was an infinite
> spin in bcache_writeback.
>
> I'll give it another shot at narrowing down exactly what causes the
> failure before I give up on bcache entirely.

Don't know if it helps or not.Maybe you can have a try these patches:
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=bcache

Ming
