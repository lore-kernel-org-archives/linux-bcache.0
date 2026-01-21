Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D8340279
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011710; cv=none; b=h9X2YKE53nim//giLmfprXP3e47EddATUrNrY7/pu1+TA/cZJBc8QzBKFmow5/SP0pQht+X6SK1Aw/BGJKSEMPIp6X8M9tl9LeQtlKapLuFt2FL/iW2pdGVBeDR8dW3pNqGkYw5QM+5IcndOGlwrBmbE3uB0g5627wMne2gZUj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011710; c=relaxed/simple;
	bh=y6tD38Zj+RuOBlTV7bergBsugziQzpyI1RNbVVOWmDM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNet7UUz0t+zrMGYcDaQ1BoKsUsnTxEqGs0WsjNm8XJ0Poqkmo/j4AFae+xFt6Q77MrnlPitLTejCQ5twMNXB2ICy9OOtul4L/q9tpIO9RWA/pvoYeVifYTWTNQTXqGgP0xnmmbgvr9hFX+iwLRHZMGlqFRtyzglO8cTNomSi70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yUq75hlZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0sTU/GAi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yUq75hlZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0sTU/GAi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yUq75hlZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0sTU/GAi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yUq75hlZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0sTU/GAi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9942E5BD3B;
	Wed, 21 Jan 2026 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769011705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6tD38Zj+RuOBlTV7bergBsugziQzpyI1RNbVVOWmDM=;
	b=yUq75hlZQhdc3afbzBnk9dCuUohy+uVsAk9xitRAKBZoxj/DE9YaGPlnnZR4i+q7Nr0iiY
	6u2qe0Rbj8YwEgZoiLMyx9FQcmIZO5WWvdokD53fEDqd34/WO83hOc3VgEEh3k6Yp96FG8
	DrciWkEgq5S4paIPv9hMmjkuI0c/ock=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769011705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6tD38Zj+RuOBlTV7bergBsugziQzpyI1RNbVVOWmDM=;
	b=0sTU/GAiWkMSUYr3DQ7srku9SYuGsXLWGvTHdhBD5kUEgd5sT6EVN4n4ll+VLgbU/5ovcv
	cLyrsqchEEQcGJAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769011705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6tD38Zj+RuOBlTV7bergBsugziQzpyI1RNbVVOWmDM=;
	b=yUq75hlZQhdc3afbzBnk9dCuUohy+uVsAk9xitRAKBZoxj/DE9YaGPlnnZR4i+q7Nr0iiY
	6u2qe0Rbj8YwEgZoiLMyx9FQcmIZO5WWvdokD53fEDqd34/WO83hOc3VgEEh3k6Yp96FG8
	DrciWkEgq5S4paIPv9hMmjkuI0c/ock=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769011705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6tD38Zj+RuOBlTV7bergBsugziQzpyI1RNbVVOWmDM=;
	b=0sTU/GAiWkMSUYr3DQ7srku9SYuGsXLWGvTHdhBD5kUEgd5sT6EVN4n4ll+VLgbU/5ovcv
	cLyrsqchEEQcGJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AF903EA63;
	Wed, 21 Jan 2026 16:08:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jJHmIPn5cGlRTgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 16:08:25 +0000
Date: Wed, 21 Jan 2026 17:08:25 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Christoph Hellwig <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH blktests v2 1/2] bcache: add bcache/001
Message-ID: <6909f738-6156-4e52-96ce-66a877e646e5@flourine.local>
References: <20260121-bcache-v2-0-b26af185e63a@suse.de>
 <20260121-bcache-v2-1-b26af185e63a@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-bcache-v2-1-b26af185e63a@suse.de>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,flourine.local:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

> +declare -a BCACHE_DEVS=()
> +declare -a BCACHE_BDEVS=()
> +declare -a BCACHE_CSETS=()

I've change _create_bcache so it returns the bcache device, thus I can
hand those into the _remove_bcache function thus no need for globals
anymore. So don't spend too much in reviewing this :)
