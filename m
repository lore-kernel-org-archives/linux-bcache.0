Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C522DAFA2
	for <linux-bcache@vger.kernel.org>; Fri,  6 Mar 2026 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772801119; cv=none; b=YcTkO9tGlero5OW7S/kUkzc9TXIGNfABVwl8a2M0udxov5jFzHahG15ui835VzP4v2taJrswJHHqa5JfW8PCQXDtX+U9JBROhYpoh6+DFR9z2LtvpdDFIaegPIX8BhjGAGD7owbda8PawxOGoqpRhiGniQL725FSwr8Jarbn3Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772801119; c=relaxed/simple;
	bh=yrCZ99EPvfLGgj+SKJJidrJwk8NHatbQj7HD1VvslRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsdrK8YkgftSJC3KAYK6zF8zCW3i+gGRsUI78BoRfLdxT2iYAru5m9arvad6YvjyuiYg3tDiArv5sSZLs6vjCPXVldU9NiT3v1vIBH70I314BWj1AfEPCO864WU2jrGIB5g3Kks4AEMmJ5wtQhl/9x/vgn4d3yvg/5oS0Hh9hZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GXjqKC/N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/y/bzS3J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GXjqKC/N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/y/bzS3J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GXjqKC/N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/y/bzS3J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GXjqKC/N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/y/bzS3J"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 34A695BDCE;
	Fri,  6 Mar 2026 12:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772801115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/+YnNFbhkPA/KtYWglC+2E0CvDXaeQfVrvA/zIIkNW0=;
	b=GXjqKC/NcvmiovjQxNpiIaSTOAho+60IEdVE/B17XUynbeIA72ktzdpynKsWbYm4A24XJ0
	ZmDzhOllxzomQm1D6S6cqf4deE9CoiDuFdYj31HsSXlYFoGdi3IqYuJSQDsBzJOqkbr2hP
	cQZKwRdP2AOKtwHa2E2xX+H22Staz0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772801115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/+YnNFbhkPA/KtYWglC+2E0CvDXaeQfVrvA/zIIkNW0=;
	b=/y/bzS3JWM3JokdGD+9rOVJ/FAmUpmuqPXmFLnW4e7S1UtPYqP263GPYs8e0UFyRbT7cEA
	QDi+aWKxjv88xvBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="GXjqKC/N";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/y/bzS3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772801115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/+YnNFbhkPA/KtYWglC+2E0CvDXaeQfVrvA/zIIkNW0=;
	b=GXjqKC/NcvmiovjQxNpiIaSTOAho+60IEdVE/B17XUynbeIA72ktzdpynKsWbYm4A24XJ0
	ZmDzhOllxzomQm1D6S6cqf4deE9CoiDuFdYj31HsSXlYFoGdi3IqYuJSQDsBzJOqkbr2hP
	cQZKwRdP2AOKtwHa2E2xX+H22Staz0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772801115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/+YnNFbhkPA/KtYWglC+2E0CvDXaeQfVrvA/zIIkNW0=;
	b=/y/bzS3JWM3JokdGD+9rOVJ/FAmUpmuqPXmFLnW4e7S1UtPYqP263GPYs8e0UFyRbT7cEA
	QDi+aWKxjv88xvBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2746D3EA75;
	Fri,  6 Mar 2026 12:45:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m+SeB1vMqmkhSgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 06 Mar 2026 12:45:15 +0000
Date: Fri, 6 Mar 2026 13:45:14 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 1/3] bcache: add bcache/001
Message-ID: <3c3825d6-820a-487e-83ec-a089b5e3ee7d@flourine.local>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-1-04cd4c9080d7@suse.de>
 <aarDdfJPu1NBuuvM@shinmob>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aarDdfJPu1NBuuvM@shinmob>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,flourine.local:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 34A695BDCE

> > +	# add /dev prefix to device names
> > +	cdevs=( "${cdevs[@]/#/\/dev\/}" )
> > +	bdevs=( "${bdevs[@]/#/\/dev\/}" )
> 
> Here, /dev/ prefix is added to arguments of _bcache_wipe_devs() call below.
> 
> > +
> > +	# make-bcache expects empty/cleared devices
> > +	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
> 
> [...]
> 
> > +_remove_bcache() {
> > +	local -a cdevs=()
> > +	local -a bdevs=()
> > +	local -a csets=()
> > +	local -a bcache_devs=()
> > +	local uuid
> 
> [...]
> 
> > +	local timeout
> > +	for cset in "${csets[@]}"; do
> > +		timeout=0
> > +		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
> > +			sleep 0.5
> > +			(( timeout++ ))
> > +		done
> > +	done
> 
> However, /dev prefix is not added here for the _bcache_wipe_devs() call below. I
> added the hunk below, then observed the nvme?n1 files are no longer created in
> my environment.
> 
>        # add /dev prefix to device names
>        cdevs=( "${cdevs[@]/#/\/dev\/}" )
>        bdevs=( "${bdevs[@]/#/\/dev\/}" )
> 
> Other than this, this patch looks good to me. If you are okay with it, I can
> fold-in the change above when I apply this patch.

No objection from me, please go ahead!
