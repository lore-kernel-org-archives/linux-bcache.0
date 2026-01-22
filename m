Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095C33A89BE
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769075841; cv=none; b=S729AbVoS6pv+BRYizLJ7u4s3WDtDzi6vGoSVxKHfUEOP7bDczxP18CocCa31eTjQvEx4cRv490/7zNWttTfx8WBre0kTxImlrIz46VyBL5bkRCBBMskjlU/Rj5RhARXV8BXDAZ+NQcTR3WA03ekJ2XPwvnoYoQc4ztbbLS2X6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769075841; c=relaxed/simple;
	bh=NwKM766jve6cwdRMlWgSLgJPeEpUyWaH5Qzxv/0YWnM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=oQEROhie7B1w9jfVhdVJjwK9RCH3nfNZx46l/pRQZZ1Po/waL76wjh02zcM5mGhqmGbPIICJVCxR5rzNmJKPfrt5MC1rHz8MBZiod9++x/2TGQpo7e1sPXRokvTShkU1I4RMuKsCn+5Sfm7ME5dPzRVCVKMT2ZjpF7YpgWJECJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=f3E6zAk8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u4q6iUI7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z5wVksZp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Kg2c+Ai; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="f3E6zAk8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u4q6iUI7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z5wVksZp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Kg2c+Ai"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ECB9F5BCE6;
	Thu, 22 Jan 2026 09:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IgzyTsBFZLO0ugTNs8K7WRXuwUlDB1zpFclRdktsbN0=;
	b=f3E6zAk81ekaKSw0cRmYiQBU9AqHwcabxd8IPpR4FYRFQ927oN+R3N/1TBstVdRN0GfOfa
	p3XPQaw9OJ0cB7u62QfzY8+fKrzQVVgElNQHBHbIyPRRMddrRv2ux35sAPeB+YD8Wep9aE
	3taxy2GD7Y/tlf+NkpZWOH2KGfOwTEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IgzyTsBFZLO0ugTNs8K7WRXuwUlDB1zpFclRdktsbN0=;
	b=u4q6iUI72kUcDvJSSrCRlYefIhWM02OIAW2fi/UFJko0UcbsVEID69/ME2SZeaoDsx8pzT
	8UkMyrB4n7z80GCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5wVksZp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/Kg2c+Ai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769075837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IgzyTsBFZLO0ugTNs8K7WRXuwUlDB1zpFclRdktsbN0=;
	b=z5wVksZp079El++j2wkgL+CyDcLeYg9VfH3gH52M+yyeDwDVLPNMVz+xVp6cY43BNhBbX5
	dr+9G6mA4EohYCZbKHkQbyHnrPe+bgKjhqORLx2fJDx84nGm0mkR9yKKPgyXvsb2fgwTJG
	dcDfU1E0zThkFr0smENF4hVbZmrc9sY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769075837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IgzyTsBFZLO0ugTNs8K7WRXuwUlDB1zpFclRdktsbN0=;
	b=/Kg2c+AiI+xKuBkqNJuZzeHSlES1zmwLgJYBRfQbeXPniMcgCR4gJ0yhzeU0HhNriBYLuk
	wkATL99g3OQLq2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D254A13978;
	Thu, 22 Jan 2026 09:57:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N/RmMn30cWnLGAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 22 Jan 2026 09:57:17 +0000
From: Daniel Wagner <dwagner@suse.de>
Subject: [PATCH blktests v3 0/3] bcache: add initial test cases
Date: Thu, 22 Jan 2026 10:57:11 +0100
Message-Id: <20260122-bcache-v3-0-2c02d15a4503@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WMQQ7CIBBFr9LMWgwztFi78h7GBdDBsmkNKNE0v
 bu0CzVx+X7+ezMkjoETdNUMkXNIYRoLqF0FbjDjlUXoCwNJ0hJJCuuMG1ioht1B6da1voZyvkX
 24bmFzpfCQ0j3Kb62bsZ1/UtkFCiao/XSUl9jLU/pkXjfM6yBTL8SfiQSJUDaeGwb1sp8pWVZ3
 kv3ODXPAAAA
X-Change-ID: 20260120-bcache-35ec7368c8f4
To: Christoph Hellwig <hch@infradead.org>, 
 Stephen Zhang <starzhangzsd@gmail.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com,linux.dev,fnnas.com,wdc.com,vger.kernel.org,suse.de];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: ECB9F5BCE6
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

I've added the test case from Stephen [1] which showed all the limitation in v2.
The cleanup code should be more robust now. The new test case reports

bcache/001 => nvme0n1 vdb vdc (test bcache setup and teardown) [passed]
    runtime  1.373s  ...  1.334s
bcache/002 => nvme0n1 vdb vdc (test bcache for bio leaks in clone) [failed]
    runtime  7.360s  ...  7.336s
    --- tests/bcache/002.out    2026-01-22 09:49:22.379130632 +0000
    +++ /tmp/blktests/nvme0n1_vdb_vdc/bcache/002.out.bad        2026-01-22 09:49:39.343331470 +0000
    @@ -1,2 +1,3 @@
     Running bcache/002
     Device state: no cache
    +ERROR: Accounting leak detected!

So it seems to do something. Though I think it could look at sysfs values
directly isntead using iostat. Though that's for another time.

I wont work on this in the next two weeks as I am on vacation. So no hurry to
review :)

Cheers,
Daniel

[1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
 

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Changes in v3:
- add bcache/002
- return created bcache devices to tests case
- made cleanup more robust (handling detached cache)
- track all resources correctly
- operatoe only in final cleanup on known devices
- Link to v2: https://patch.msgid.link/20260121-bcache-v2-0-b26af185e63a@suse.de

Changes in v2:
- fixed whitespace damage
- added documentation on how to configure for bcache tests
- do registering explicitly
- made disk wiping more robust
- Link to v1: https://patch.msgid.link/20260120-bcache-v1-1-59bf0b2d4140@suse.de

---
Daniel Wagner (3):
      bcache: add bcache/001
      bcache: add bcache/002
      doc: document how to configure bcache tests

 Documentation/running-tests.md |  16 ++
 tests/bcache/001               |  48 ++++++
 tests/bcache/001.out           |   3 +
 tests/bcache/002               |  63 +++++++
 tests/bcache/002.out           |   2 +
 tests/bcache/rc                | 368 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 500 insertions(+)
---
base-commit: e387a7e0169cc012eb6a7140a0561d2901c92a76
change-id: 20260120-bcache-35ec7368c8f4

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

