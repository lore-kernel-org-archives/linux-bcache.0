Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D16848B385
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 12:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998995; cv=none; b=eGbzeBGA7ULt7o6H816wsUQmnD3CKhZlFMP44GXTuPV0a6XQGy9kZvv6RlT4/rSXiYNkVAZ37kRdby1CagnsnVokfR1iCfLrHzPXgtx0UVHxG62qkPx4kZPRf4G8u5ryI96RzVdsIUO41C04G/zIf6R9iVCLmMoAkBRxc+Sl+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998995; c=relaxed/simple;
	bh=BHt3Yg56RB1BYd7f8HjwyhlFnNJaRmTd+f51TDTXjDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBfMxxhGEjey4dwFg3wb9o5CW4HKvsd/1aBwECM22WSt09EB2vKPjkj8OR8AJgyZOTUh78wvm0FoP/BvgRqPNsdlr5H9EFyDOrw7Oi5looYuy0BheW0SeTyrUTJSWRHgu4ffK5fp+5nTV3FIAoCJaYwsiwXm9i00LFme3KgRWgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b438SPpK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Au2Wtalc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b438SPpK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Au2Wtalc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b438SPpK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Au2Wtalc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b438SPpK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Au2Wtalc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E0FB5BCFE;
	Wed, 21 Jan 2026 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768998992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHt3Yg56RB1BYd7f8HjwyhlFnNJaRmTd+f51TDTXjDY=;
	b=b438SPpKggth3qZQQ9104HcV/w72js38KcdBaseJlxHYlXH40p80O5FTxKsZREc9qK3wnr
	SmfPeQj9L3/9ARfaB6dIbsHuiI1nLg51f5LpOzwQALJeSuu1aP+ywfSpCchARP7eTM2P7t
	CcxFTQsj7706JMthCE3WYS7BhuGwat8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768998992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHt3Yg56RB1BYd7f8HjwyhlFnNJaRmTd+f51TDTXjDY=;
	b=Au2Wtalcpso3foWFHc8FXSz+RdxH+Zt+CUNFzQDpNoSc/e1je5DjB3iC81sEbNHgIv6MtH
	hP4mEOkv/2RDMZDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b438SPpK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Au2Wtalc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768998992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHt3Yg56RB1BYd7f8HjwyhlFnNJaRmTd+f51TDTXjDY=;
	b=b438SPpKggth3qZQQ9104HcV/w72js38KcdBaseJlxHYlXH40p80O5FTxKsZREc9qK3wnr
	SmfPeQj9L3/9ARfaB6dIbsHuiI1nLg51f5LpOzwQALJeSuu1aP+ywfSpCchARP7eTM2P7t
	CcxFTQsj7706JMthCE3WYS7BhuGwat8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768998992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHt3Yg56RB1BYd7f8HjwyhlFnNJaRmTd+f51TDTXjDY=;
	b=Au2Wtalcpso3foWFHc8FXSz+RdxH+Zt+CUNFzQDpNoSc/e1je5DjB3iC81sEbNHgIv6MtH
	hP4mEOkv/2RDMZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1CED3EA63;
	Wed, 21 Jan 2026 12:36:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uLgKOk/IcGkveAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Jan 2026 12:36:31 +0000
Date: Wed, 21 Jan 2026 13:36:31 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests] bcache: add bcache/001
Message-ID: <740e43f6-549b-4c9b-b1e0-0eebd0c2323b@flourine.local>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
 <bc45323c-d261-4ff4-8174-28fbb0676237@wdc.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc45323c-d261-4ff4-8174-28fbb0676237@wdc.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,flourine.local:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 0E0FB5BCFE
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Wed, Jan 21, 2026 at 08:19:08AM +0000, Johannes Thumshirn wrote:
> It's either my MUA or there's some mix of space and tabs here.

I had a mix of tabs and spaces and didn't realize it before sending it
out. I've converted it all to spaces. I'll sent an new version, so it's
actually readable. Sorry!
