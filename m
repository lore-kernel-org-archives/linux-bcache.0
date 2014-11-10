From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Is this a potential deadlock?
Date: Mon, 10 Nov 2014 17:29:57 +0800
Message-ID: <CAC8teKW8afEeLa7iZtyWimaFejFZQoEGsw2ADdPK0vHRNiu9Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57315 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaKJJaS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Nov 2014 04:30:18 -0500
Received: by mail-qc0-f180.google.com with SMTP id o8so5453016qcw.11
        for <linux-bcache@vger.kernel.org>; Mon, 10 Nov 2014 01:30:17 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

Kent,
Bcache will put write_dirty_finish into system_wq, and also
journal_write if the journal is full. The write lock of the root node
is hold with journal_write,  and the lock won't be released until
journal_write_done, which means at this moment all work queue kthreads
which run write_dirty_finish will block since they are trying to
require the read lock of root node.

And as we know the max number of active kthreads belong to system_wq
is min(256, 4*num_possible_cpus), so if all kthreads in the poll have
been blocked in write_dirty_finish, the journal_write queued up has no
chance to run, resulting to all the kthreads sleep forever. Is this
ever possible? Have you seen such deadlocks in your systems?

Thanks,
Zhu Yanhai
