From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Can a bcachefs filesystem be exported via NFS?
Date: Mon, 6 Jun 2016 14:23:22 -0700
Message-ID: <5755E9CA.4060609@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42391
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753458AbcFFVXZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Jun 2016 17:23:25 -0400
Received: from [10.94.141.27] (daytank.gemtalksystems.com [10.94.141.27])
	by office-ns.gemtalksystems.com (Postfix) with ESMTP id 997C120373
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jun 2016 14:23:22 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Can a bcachefs filesystem be exported via NFS?

I have a bcachefs filesystem mounted on /meteor4. When I try to export
it, I get:

---
root@meteor:~# service nfs-kernel-server restart
 * Stopping NFS kernel daemon   [ OK ]
 * Unexporting directories for NFS kernel daemon...      [ OK ]
 * Exporting directories for NFS kernel daemon...
exportfs: /meteor4 does not support NFS export
---

and the system log says:

Jun  6 14:11:28 meteor rpc.mountd[31541]: /meteor3 and /meteor4 have
same filehandle for *, using first

Not sure what this is about. /meteor3 is a vanilla ext4 partition.

If I try to access /meteor4 from another machine via NFS, Meteor's log
shows this:

Jun  6 14:15:10 meteor rpc.mountd[31541]: Cannot export /meteor4,
possibly unsupported filesystem or fsid= required

So I'm guessing it's not yet supported, but wanted to check in case I'm
doing something wrong.

Thanks,

-Martin
