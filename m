From: Stefan Priebe <s.priebe@profihost.ag>
Subject: bcache journal_read_bucket / bad csum reading priorities / bad magic
 reading priorities
Date: Mon, 29 Dec 2014 21:48:38 +0100
Message-ID: <54A1BE26.6070000@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43108 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaL2Uxk (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 29 Dec 2014 15:53:40 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

while running bcache on vanilla 3.10 i've lost some of my bcache devices 
with the following error messages after reboot:

bcache: journal_read_bucket() 228: bad csum, 5320 bytes, offset 22
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: error on c40add13-6e96-4c47-a6de-1fc207088e07: unsupported bset 
version at bucket 261528, block 0, 2014209420 keys, disabling caching
bcache: register_cache() registered cache device sdb3
bcache: cache_set_free() Cache set c40add13-6e96-4c47-a6de-1fc207088e07 
unregistered

Any patch or fix available?

Stefan
