Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58D2222AC
	for <linux-bcache@vger.kernel.org>; Fri,  6 Mar 2026 13:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772802885; cv=none; b=tGUe4nBhTTwaycEqzQL+2pfBc6Lw1Oh/KXVKcBwGZ/I6OvdqbYFrg1m3aVM3uyehaib5vG7KDXeEqbixyzlQjeoZisd1jWgt7WKDJzzJpnp95GSLpTpl2IZymUXqIljr0yX0vs01MZxURJCytB4nqu+FrkrxZWkzW/2mtbLWA70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772802885; c=relaxed/simple;
	bh=0UPSJIeo/JJvd/qYCZajeRPsdMgtU5mDlOQrWloj5pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dtr3tgMrOqrpNTMZ4sOFlqCVKMj6F/z3xRz4od8e2XmnHHMHRnzoHdbiXWFlNbC3GuHFV0cy5BA6X7sG8m3mXKx3KPzBfkWC4KaLluNQivDvysyYwVnhjXqTcHYoGoQE9absUaKjuzRt7p7l7AMysH36XhWVNJwDFo/w7+YsN80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z9gyY4DG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5MWZKh9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z9gyY4DG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5MWZKh9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z9gyY4DG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5MWZKh9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z9gyY4DG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5MWZKh9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 133F75BE2A;
	Fri,  6 Mar 2026 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772802883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tuo/M54ZYoIpZVfc9Tj3P0rGNr9hcET3MKrZ/9AEN/g=;
	b=Z9gyY4DGuk3OK1kcnHqsW88eZQ7po2TUUAA0C19QMq+E3LBu2kLq843qdHcSZKKWzRr6wT
	UVM078iBEOrUBWqPWFnUv02aGUsfoMMpEthXe5f6EtEmqp8JoCiIciW9glBXEFeIPBPcSP
	wQKrrr5GqjdZOOVkO46/CkOlQeP4VKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772802883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tuo/M54ZYoIpZVfc9Tj3P0rGNr9hcET3MKrZ/9AEN/g=;
	b=u5MWZKh9U1ehMrPjJKGfKvU5/lYEYEsgbl8WJCQBB/A/Wdy66DsEVeeVJIPf+68Kmnu9xu
	WC54tlTo9pPmfoDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z9gyY4DG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5MWZKh9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772802883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tuo/M54ZYoIpZVfc9Tj3P0rGNr9hcET3MKrZ/9AEN/g=;
	b=Z9gyY4DGuk3OK1kcnHqsW88eZQ7po2TUUAA0C19QMq+E3LBu2kLq843qdHcSZKKWzRr6wT
	UVM078iBEOrUBWqPWFnUv02aGUsfoMMpEthXe5f6EtEmqp8JoCiIciW9glBXEFeIPBPcSP
	wQKrrr5GqjdZOOVkO46/CkOlQeP4VKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772802883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tuo/M54ZYoIpZVfc9Tj3P0rGNr9hcET3MKrZ/9AEN/g=;
	b=u5MWZKh9U1ehMrPjJKGfKvU5/lYEYEsgbl8WJCQBB/A/Wdy66DsEVeeVJIPf+68Kmnu9xu
	WC54tlTo9pPmfoDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 032053EA75;
	Fri,  6 Mar 2026 13:14:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rswlAEPTqmmtaQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 06 Mar 2026 13:14:43 +0000
Date: Fri, 6 Mar 2026 14:14:42 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
Message-ID: <baa3a723-2f9c-4e10-9d42-b4152de92df2@flourine.local>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
 <aarFVqxrXF9Bah31@shinmob>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aarFVqxrXF9Bah31@shinmob>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[flourine.local:mid,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 133F75BE2A
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On Fri, Mar 06, 2026 at 12:27:51PM +0000, Shinichiro Kawasaki wrote:
> On Mar 05, 2026 / 16:01, Daniel Wagner wrote:
> > Add test case from Stephen Zhang [1][2], which is
> > 
> > 1. Wait for fio to complete (wait $fio_pid)
> > 2. Wait a few seconds for I/O to drain
> > 3. Then check the utilization
> > 
> > If utilization is still > 0% after I/O completes, then there's a real
> > accounting leak.
> > 
> > [1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
> > [2] https://lore.kernel.org/all/CANubcdU92Uv7wNdZH357LLTnfwPouekXNTPSjHnzYzK99-eZ9w@mail.gmail.com
> 
> Thanks for the updates. It's good that we do not need iostat :)
> 
> I ran this test case with v7.0-rc2 kernel, and it passes. Good.
> 
> I also ran this test case with older kernel without the kernel fix [1]. I
> expected failure, but it passed. I ran the Stephen's original test script and it
> did not fail either. So I guess my test environment does not fulfill the
> conditions to recreate the failure. Daniel, did you observe this test case
> failed with any older kernel?

Same here, it doesn't fail on older kernels either. Maybe we should just
not merge this test then? Maybe Stephen can have a look and figure out
what needs to be done to trigger the condition more reliable.

> Let me leave nit comments in line. If this patch does not respin, I can fold in
> the changes for the nit comments.

Sure, just fix it up if you decide to apply it.

Thanks!
Daniel
