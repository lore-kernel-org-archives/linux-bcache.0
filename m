Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C123750B5
	for <linux-bcache@vger.kernel.org>; Tue,  3 Mar 2026 08:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772525085; cv=none; b=oad/bi2s8cEe0QhTnS2FxzLl40UNOhao759O5QnEdkViE5qs0s8jJN4L94nLE864uk1qJAX556UIoV+mZ68D1gnVvTrosTSLBU0BZ7qhpDwRZmxZATAoubPUUf/OAdC14NdnMLnzJLp6yOYVPSoc4rEQ8BV/RN20kJtUsviAgJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772525085; c=relaxed/simple;
	bh=fXY1VaLBF865FRc67gKSJd4OVrlGYZYBUEHBgFgjudE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7b9h1ap/mOCVBB1MidjXvq+gMxTAUo0s0P07LKZOLhj8PBbR4fWD9TUM9FWNrtCCpsYuDFFKikK5VWUyAQzalRk85kZPhzopXbqtvkzUo+4mWaR5vo8Qdt1v/WfDhe6JDx0wnrhxCYN7wG8ieNbVnvGTf0cQkTLP9YZqK6z9JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U7b2B/B/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O0UJX6XW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U7b2B/B/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O0UJX6XW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U7b2B/B/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O0UJX6XW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U7b2B/B/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O0UJX6XW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CE3E3F900;
	Tue,  3 Mar 2026 08:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772525082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7z8rz4sJXbLEBbjPa23l499jQIycn/gGGJXbkQ5pJRc=;
	b=U7b2B/B/asBIedHzO7ogSmM7ZrARFTezdRCOFlkXQRTOSZGgYcBdlMdHM/Orgh9/yQGR5+
	JVbC57CYc5HX5+5FeG0LYAH7k8S+NBL4jzKTaouc2MNoqic9w6d/0Dd35PN+YwQkCKR19g
	0MwcDlmpc6ZW6VxanaLtu/o1EKfGCiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772525082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7z8rz4sJXbLEBbjPa23l499jQIycn/gGGJXbkQ5pJRc=;
	b=O0UJX6XWwY+LQSVOgpIlosmqgaBDqE1uAQg7ZYKNL6WWRP0Amf9WsXZmBfos+eQkhI4gUC
	UsJM/La/gQ/1rLBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="U7b2B/B/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O0UJX6XW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772525082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7z8rz4sJXbLEBbjPa23l499jQIycn/gGGJXbkQ5pJRc=;
	b=U7b2B/B/asBIedHzO7ogSmM7ZrARFTezdRCOFlkXQRTOSZGgYcBdlMdHM/Orgh9/yQGR5+
	JVbC57CYc5HX5+5FeG0LYAH7k8S+NBL4jzKTaouc2MNoqic9w6d/0Dd35PN+YwQkCKR19g
	0MwcDlmpc6ZW6VxanaLtu/o1EKfGCiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772525082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7z8rz4sJXbLEBbjPa23l499jQIycn/gGGJXbkQ5pJRc=;
	b=O0UJX6XWwY+LQSVOgpIlosmqgaBDqE1uAQg7ZYKNL6WWRP0Amf9WsXZmBfos+eQkhI4gUC
	UsJM/La/gQ/1rLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 582A53EA69;
	Tue,  3 Mar 2026 08:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0rjeExqWpml6bgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Mar 2026 08:04:42 +0000
Date: Tue, 3 Mar 2026 09:04:41 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, 
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Coly Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v4 0/3] bcache: add initial test cases
Message-ID: <f7cff08f-a3e8-4b2e-ac7a-a56d8ed3f2d5@flourine.local>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
 <37e2c5a5-d797-4176-98c7-0e43abaa1af8@flourine.local>
 <aaYwWwGHdoc1uMCu@shinmob>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaYwWwGHdoc1uMCu@shinmob>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
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
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 6CE3E3F900
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 

Hi Shinichiro,

On Tue, Mar 03, 2026 at 12:57:18AM +0000, Shinichiro Kawasaki wrote:
> On Mar 02, 2026 / 14:54, Daniel Wagner wrote:
> > On Thu, Feb 12, 2026 at 04:23:30PM +0100, Daniel Wagner wrote:
> > > I've updated the v3 version with the feedback from Shinichiro for v2.
> > > Shinichiro, please note I did rewrite some of the logic in v3, thus some of your
> > > comments didn't apply. But hopefully I don't made a big mess :)
> > 
> > ping
> 
> Daniel, I wonder if my replies [1][2] reached your mail box.

Sorry, no, they didn't. Yet another hickup with our mail server...

> [1] https://lore.kernel.org/linux-block/aZQZkjEUw9VnVauX@shinmob/
> [2] https://lore.kernel.org/linux-block/aZQcH-d-ZcgtMoJb@shinmob/

I'll work on this then.

> Today, I tried this patch series again on v7.0-rc2 kernel with the
> TEST_CASE_DEV_ARRAY below:
> 
>   TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme4n1"
> 
> And found that new files named "nvme?n1" are created in the current directory.
> Do you see the files created in your environment?

Will check.

> Also I saw the failure with the message "ERROR: Accounting leak detected!" as I
> noted in [2].

I am not really sure if this test case should go in the current form.
I've just used Stephen's test case as input for figuring out what kind
of API is useful. I also see the leak error with v7.0-rc1 which has
3ef825dfd4e4 ("bcache: use bio cloning for detached device requests").
I might have done something wrong here.

BTW, iostat could be replaced by reading directly from sysfs,
e.g. /sys/block/nvme0n1/stat

Thanks,
Daniel
