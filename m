From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Changes in /sys/bcache in kernel 3.13
Date: Tue, 18 Feb 2014 23:28:24 +0100
Message-ID: <5303DE88.3090801@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51515 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaBRW21 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Feb 2014 17:28:27 -0500
Received: by mail-ea0-f177.google.com with SMTP id m10so5609473eaj.36
        for <linux-bcache@vger.kernel.org>; Tue, 18 Feb 2014 14:28:26 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi All,

bcache-status stopped working in kernel 3.13, see also: 
https://bugzilla.redhat.com/show_bug.cgi?id=1066555

It's probably related to the change "Fix dirty_data accounting" in 
kernel 3.13-rc4. What specifically has changes is the fact that that 
/sys/fs/bcache/<UUID>/dirty_data has been removed, which breaks 
bcache-status (https://gist.github.com/djwong/6343451). Just removing 
the check / reference to this dirty_data item fixes bcache-status. Or 
has it been replaced by a specific item?

Oh, BTW: bcache.txt still refers to dirty_data in /sys/fs/bcache/<UUID> 
which doesn't seem correct to me.

Cheers,

Rolf
