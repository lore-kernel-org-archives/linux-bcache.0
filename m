Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBF30AAB8
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768999711; cv=none; b=tGCtEkIyaLoeHfunj5SP4mhCc3/AE490ypFhdTpYbnWI5C5gh0ktvsvXMC8PFblL8X0197tVU5AUQreh5dp5KscjpboHLXcfpWdlTYm/C57IKoCUuzaQtKXXkB584I9/RnJx3wgxQYs7JfjXIbD4/94JVTHHsQF1RRkWEff4I6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768999711; c=relaxed/simple;
	bh=MQUwqdHyd/BOxoWEu9xk4LKrRqcZUSaOJ8tsfHYDvDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5eYIpI54aBWc0vXh+tMDfqb/FWEJsEAZdF4mJ5UnINNdEywQp/forTIMnlVpn3sNArZ3o4idNDPjaLoIsqbmwIq0OSSB02rIwCjhW7/D89QewFgMF0m86boDHyfq/c3OEqhxu1IYFszz/DJMOYILQSw18+F/NvzZCFwo2tsV9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g6v6oxje; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wuP4Ta1S; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g6v6oxje; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wuP4Ta1S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g6v6oxje";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wuP4Ta1S";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g6v6oxje";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wuP4Ta1S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D56A5BD01;
	Wed, 21 Jan 2026 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768999708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faEXmTyOTXLohN/DbSvHrX9xwFhdeS+KvDdK6U4EqeI=;
	b=g6v6oxjelf/AkRvp2Qnn6bhMtGAnTK5B7e9p46adA9i/S+Ju/1lL2pEaTwOUoeaYuRBjXT
	XPcSBCe9w9+Nfvjmi+MXij/NCqs5OdLOmgC2kM/RizKzCRkv0yJlG3D3O3pSOv4hH4RgKq
	J4Xb/rQd/0oh4S0us32P0rPfJ5kHaj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768999708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faEXmTyOTXLohN/DbSvHrX9xwFhdeS+KvDdK6U4EqeI=;
	b=wuP4Ta1SZHOKpmXuKoXdJVvbw4LgZvXXqy5cpopA1hPshTTsvkgMRVCa19cmMoFdSJqkmk
	fyvSWIaDT+J/WPDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g6v6oxje;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wuP4Ta1S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768999708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faEXmTyOTXLohN/DbSvHrX9xwFhdeS+KvDdK6U4EqeI=;
	b=g6v6oxjelf/AkRvp2Qnn6bhMtGAnTK5B7e9p46adA9i/S+Ju/1lL2pEaTwOUoeaYuRBjXT
	XPcSBCe9w9+Nfvjmi+MXij/NCqs5OdLOmgC2kM/RizKzCRkv0yJlG3D3O3pSOv4hH4RgKq
	J4Xb/rQd/0oh4S0us32P0rPfJ5kHaj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768999708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faEXmTyOTXLohN/DbSvHrX9xwFhdeS+KvDdK6U4EqeI=;
	b=wuP4Ta1SZHOKpmXuKoXdJVvbw4LgZvXXqy5cpopA1hPshTTsvkgMRVCa19cmMoFdSJqkmk
	fyvSWIaDT+J/WPDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CEEA3EA63;
	Wed, 21 Jan 2026 12:48:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n9EtAhzLcGlRBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 12:48:28 +0000
Date: Wed, 21 Jan 2026 13:48:27 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Zhang <starzhangzsd@gmail.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH blktests] bcache: add bcache/001
Message-ID: <512c18ed-feed-416d-9de6-c9183da98efc@flourine.local>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
 <aXCGseCNoaX8rQ83@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXCGseCNoaX8rQ83@infradead.org>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[flourine.local:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,flourine.local:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 1D56A5BD01
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Tue, Jan 20, 2026 at 11:56:33PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 02:28:18PM +0100, Daniel Wagner wrote:
> > So far we are missing tests for bcache. Besides a relative simple
> > setup/teardown tests add also the corresponding infrastructure. More
> > tests are to be expected to depend on this.
> > 
> > _create_bcache/_remove_bcache are tracking the resources and if anything
> > is missing it will complain.
> 
> Not really an expert on bcache, and not that much in blktests either,
> but having some testing for bcache readabily available is fantastic!

I think so too. Anyway, I'll hope, I figure out to make it more
stable/consistent. 
 
> > Note: to run this tests blktests TEST_CASE_DEV_ARRAY needs to be set:
> > 
> >   # cat config
> >   TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"
> 
> Can you add a blurb to Documentation/running-tests.md about this?
> 
> I also wonder if we could have a generic TEST_CASE_DEV_ARRAY that
> would just work for all tests needing multiple devices?

Sure, I'll update the documentation.

On this note, It took me a while to understand that using
TEST_DEVS="/dev/nvme0n1 /dev/vdb /dev/vdc" is not populating the
TEST_DEV_ARRAY array.

Commit 653ace845911 ("check, new: introduce test_device_array()")
explains why:

    As to the test target devices defined in TEST_DEVS variable, blktests
    assumes that each test case with test_device() function is run for each
    single device defined in TEST_DEVS. On the other hand, it is suggested
    to support a test case for not a single device but multiple devices.

Maybe we could add a default config with all options listed and
documented but commented out.
