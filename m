Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA93FB05B
	for <linux-bcache@vger.kernel.org>; Mon,  2 Mar 2026 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772459684; cv=none; b=IoWbQyrpiZ1ZJGGllTK+ydlg3CwlGhtKTOofYup8BHnnABL85ewCb1896sIdcywfANK/7tbBQBmzwUVWeqM6Jl7ANCmqnEPh5KBGJX3mC+oPovFgb74gnOySn8qgX/DeWgcKxEoJJ8mORdvzYlf2la73P1x5o9Ku2bOwC24cDFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772459684; c=relaxed/simple;
	bh=wt3izgHLfD805jVuliEnjufAUwiyQU+D2zGa5JPauu8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgEbZRlnmWjIw6/9v7QOzezKnL2zZV3BBqmPLD0WO5iSbYfZFY4Hv30G1GrRiDY63Gd4Pg2t+KsKHisg7hqLg9CwDYH3s/m49jBnIOgbyT9ZrVKKyWVmXP3Uf2/6NW8n8V2Hwb+pIazjDE8S0rD58wpsf3blFIlB0fbKR6PMvwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jkts9SW0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iqbXWlBq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0iTN9rox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dOayxBBm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jkts9SW0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iqbXWlBq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0iTN9rox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dOayxBBm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EACC25BD4A;
	Mon,  2 Mar 2026 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772459680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wt3izgHLfD805jVuliEnjufAUwiyQU+D2zGa5JPauu8=;
	b=jkts9SW06bfaxjM5ZD6fH2N45Ict2M/RvvjelXMatU3R7s7RWdQsJPf3a6GEVABqOZOqc+
	TA9biTnacWsg3doSsIRgoDfqCRKFTuUv9c/ay3j8aUZAMHWodr+bo6CbMcKf6wVaBoMXrO
	u9q8xUWzLlTVKMY7IAFQ09mHT/dhUgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772459680;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wt3izgHLfD805jVuliEnjufAUwiyQU+D2zGa5JPauu8=;
	b=iqbXWlBqc0CCHEEy5PyHKJbhsl0z94cwy4hd+luG7gGLUkL5aCIfYv1/lw1owYHMQCir+b
	F/FgOy7+nIJMTtDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0iTN9rox;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dOayxBBm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772459679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wt3izgHLfD805jVuliEnjufAUwiyQU+D2zGa5JPauu8=;
	b=0iTN9roxcGMt2NWnOoYc5BUi9/GZHgaitzCiRa3vnJv81jN/vLYyJvNcq4DRrLpFkXm5MI
	iY0by8MT8re/XH9VUg3wKSVmAoGNipzf9WdiopZyfzAGCwyYWbUyGrhitq9x0dwdEZcdX9
	SGCW4sWq2JLj+Ck9MnyERjJtXdVxro4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772459679;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wt3izgHLfD805jVuliEnjufAUwiyQU+D2zGa5JPauu8=;
	b=dOayxBBmwdooLk+H6w+HYDbALTtpmLC+aAoHTLunRr0OUfaHSl/R+A7sL7V8hwi7wgAxs+
	vG9la633Zf/rteAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD78A3EA69;
	Mon,  2 Mar 2026 13:54:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z9VpNJ+WpWnEFQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 02 Mar 2026 13:54:39 +0000
Date: Mon, 2 Mar 2026 14:54:39 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH blktests v4 0/3] bcache: add initial test cases
Message-ID: <37e2c5a5-d797-4176-98c7-0e43abaa1af8@flourine.local>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EACC25BD4A

On Thu, Feb 12, 2026 at 04:23:30PM +0100, Daniel Wagner wrote:
> I've updated the v3 version with the feedback from Shinichiro for v2.
> Shinichiro, please note I did rewrite some of the logic in v3, thus some of your
> comments didn't apply. But hopefully I don't made a big mess :)

ping
