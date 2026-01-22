Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43030BF75
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769077709; cv=none; b=IY31GPMoe+QDHPjmemTWDbwuKdh4CySGNhgcx7M+t5w0a6WeG2j1AN/iTOo43m1no861A2UxfYISNbsTvxvciyCXfNakC/d//wRbcPmEzU3j72D/b+K8z7RREFnOIZlQB3PTaaFbOup8MoYGe1J0hMms/SPeId+TPiwPLS+j5iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769077709; c=relaxed/simple;
	bh=gcdwqHsD2Ab03j8tRkfU0PXKCNk5HOTFzfi3oyO9urI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWg/rw9QsdImdDXq9wZe5Co7osPMwTW/HgYiB6ujNxGngFCL8LxPgpRiW0E/yKL/zePjxVTFqL70ZYbv/G0bqoMZNS2PpgXyr3sjz7eZqnHmSb2xkxrDDpvRPcuhN5WFezxmACSd9TtBy5AdWDNagNu6ly4Z6r99FUCK7UHPf/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G+PWm0Dk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKuv3w+0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G+PWm0Dk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKuv3w+0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G+PWm0Dk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKuv3w+0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G+PWm0Dk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKuv3w+0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54C2C336AE;
	Thu, 22 Jan 2026 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769077706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLO628HhJmeoTzGNfMA1BwmTSROgN3V8LaRmypF0eDk=;
	b=G+PWm0DkMSWKTS6KStpLO+P+w8o/BKPR5FlCjyJuXOyj/b59HtCsxsTodXCvzBpzgM3XQV
	wOCPj3n+qEayGELixfvSxSu3zsVlqu34fj833To/T+ruvDeqmFjTuBGDDfgm6tNIaCNuO9
	vgXVg2Krhqn+s4PLC3zPgZx6wZOUOtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769077706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLO628HhJmeoTzGNfMA1BwmTSROgN3V8LaRmypF0eDk=;
	b=BKuv3w+0k+PNV2OdoWZFcYBTJnqSQ2Hp5DeLpPuXnqbZIcoRiopoHtuqsWnnaBFurx+C/J
	g5fUhpwH6ZucthAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G+PWm0Dk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BKuv3w+0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769077706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLO628HhJmeoTzGNfMA1BwmTSROgN3V8LaRmypF0eDk=;
	b=G+PWm0DkMSWKTS6KStpLO+P+w8o/BKPR5FlCjyJuXOyj/b59HtCsxsTodXCvzBpzgM3XQV
	wOCPj3n+qEayGELixfvSxSu3zsVlqu34fj833To/T+ruvDeqmFjTuBGDDfgm6tNIaCNuO9
	vgXVg2Krhqn+s4PLC3zPgZx6wZOUOtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769077706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLO628HhJmeoTzGNfMA1BwmTSROgN3V8LaRmypF0eDk=;
	b=BKuv3w+0k+PNV2OdoWZFcYBTJnqSQ2Hp5DeLpPuXnqbZIcoRiopoHtuqsWnnaBFurx+C/J
	g5fUhpwH6ZucthAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AE211395E;
	Thu, 22 Jan 2026 10:28:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PixwDcr7cWmFEwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 22 Jan 2026 10:28:26 +0000
Date: Thu, 22 Jan 2026 11:28:21 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v2 1/2] bcache: add bcache/001
Message-ID: <3da39ef2-702c-4314-abc9-8f1f084a1e4f@flourine.local>
References: <20260121-bcache-v2-0-b26af185e63a@suse.de>
 <20260121-bcache-v2-1-b26af185e63a@suse.de>
 <aXHWBswguTmf8VCx@shinmob>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXHWBswguTmf8VCx@shinmob>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 54C2C336AE
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Thu, Jan 22, 2026 at 08:05:04AM +0000, Shinichiro Kawasaki wrote:
> Hi Daniel, thank you for working on this. It's great to extend the test
> coverage :)
> 
> Please find my review comments in line. I ran the new test case, and observed a
> failure. I noted my findings about the failure as one of the inline
> comments.

Ah sorry, saw your response after sending out v3. I'll work on v4 after
I am back from my vacation.
