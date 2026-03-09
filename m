Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1944337BE6D
	for <linux-bcache@vger.kernel.org>; Mon,  9 Mar 2026 09:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773049248; cv=none; b=ajDxl7hM2o9GFbDTAorxQ3kZ9p0qAWjsjm2XbDURkks86Q+hXaJ5sqWO/XW5JTsxPnoh2lKpn6xmFimbmtJXOMEV+3m2LrwoQS11xKUzlFYzqzwiL2kM8SbHbXE4OXg4fHmbJ+2Yy9ApPg7CNZTvM9uQl9+o8XwYy6PK2q0PNYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773049248; c=relaxed/simple;
	bh=k5buxHRIZWjpTnXw0EcJlrekSX4x6Cy9tnCX+2Pi8TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bauma4IbS4sE/PAV6GMfzGMIuYKnXxuzSTb0zJnnvw9dWNu9aIYmRG/CY+MnJbv+tpBGQdPjp7jeYjLn/fMwcKM7IULmDQ6APaqXikj8dEPmtVXgmEyyNL6q/W62t/7YlY9W771pUZJgU2iuVXwSMQ/fY1sCt4NuKf3Kq8reKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q6GfOWS8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XJ01uJRd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q6GfOWS8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XJ01uJRd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q6GfOWS8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XJ01uJRd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q6GfOWS8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XJ01uJRd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DB434D20A;
	Mon,  9 Mar 2026 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773049245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zVxFaAHbg3bDXiJQqBzLYbhKHtrZj5HCyqeBP33Jr2U=;
	b=q6GfOWS8mvTJh9V3SB/EANnHssgZCC8jaIgJig9hYYOe1fOHwABI7j5IpHpvsfWUk3HFGE
	XIb3PwBgVna0ebwCuaec2Dt26nwAJfRYsGTOxMBSbrRB8KW4iRkeEapdwbQ5TcSKUncKiq
	/pg8JSsN2+NqD9WuvZpNNVol3S4ZkRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773049245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zVxFaAHbg3bDXiJQqBzLYbhKHtrZj5HCyqeBP33Jr2U=;
	b=XJ01uJRdjGTzs6RLVgkSp2VE9US9hFKIFXkjuChCYU2O9gnuUoA1buxZ58YLudrqv5IbXB
	B515zOacEjlsj4AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q6GfOWS8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XJ01uJRd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773049245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zVxFaAHbg3bDXiJQqBzLYbhKHtrZj5HCyqeBP33Jr2U=;
	b=q6GfOWS8mvTJh9V3SB/EANnHssgZCC8jaIgJig9hYYOe1fOHwABI7j5IpHpvsfWUk3HFGE
	XIb3PwBgVna0ebwCuaec2Dt26nwAJfRYsGTOxMBSbrRB8KW4iRkeEapdwbQ5TcSKUncKiq
	/pg8JSsN2+NqD9WuvZpNNVol3S4ZkRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773049245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zVxFaAHbg3bDXiJQqBzLYbhKHtrZj5HCyqeBP33Jr2U=;
	b=XJ01uJRdjGTzs6RLVgkSp2VE9US9hFKIFXkjuChCYU2O9gnuUoA1buxZ58YLudrqv5IbXB
	B515zOacEjlsj4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 089073EE25;
	Mon,  9 Mar 2026 09:40:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I3prAJ2Vrml/dwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 09 Mar 2026 09:40:45 +0000
Date: Mon, 9 Mar 2026 10:40:44 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 0/3] bcache: add initial test cases
Message-ID: <d9aae3e1-4a91-42bc-b65f-81491b5ac964@flourine.local>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <aav89rnofa3mpOM-@shinmob>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aav89rnofa3mpOM-@shinmob>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 1DB434D20A
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On Sat, Mar 07, 2026 at 10:27:08AM +0000, Shinichiro Kawasaki wrote:
> Daniel, thank you for this effot. FYI, I applied the 1st (with my fix) and the
> 3rd patch. Let's do some more effort to confirm the value of the 2nd
> patch.

Thanks! FWIW, it should be hopefully fairly simple to add some more
tests based on:

  https://evilpiepirate.org/git/ktest.git/tree/tests/bcache

This should cover some more ground.
