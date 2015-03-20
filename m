From: David Mohr <damailings@mcbf.net>
Subject: Tiny Makefile fix
Date: Fri, 20 Mar 2015 12:01:17 -0600
Message-ID: <be69c3afa89bbcd7b67c04cd0ee5aac9@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:55619 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbbCTScw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 20 Mar 2015 14:32:52 -0400
Received: from localhost ([127.0.0.1] helo=de.mcbf.net)
	by seeker.mcbf.net with esmtp (Exim 4.80)
	(envelope-from <damailings@mcbf.net>)
	id 1YZ1ET-0005EG-Fo
	for linux-bcache@vger.kernel.org; Fri, 20 Mar 2015 19:01:17 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Linux Bcache <linux-bcache@vger.kernel.org>

Hi all,

just a tiny fix that you may want to apply.

Thanks,
~David

--

 From: David Mohr <david@mcbf.net>
Date: Fri, 20 Mar 2015 11:42:54 -0600
Subject: Clean should remove bcache-register

---
  Makefile | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c824ae3..afdb2f3 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,7 @@ install: make-bcache probe-bcache bcache-super-show
  #	$(INSTALL) -m0755 bcache-test $(DESTDIR)${PREFIX}/sbin/

  clean:
-	$(RM) -f make-bcache probe-bcache bcache-super-show bcache-test -- *.o
+	$(RM) -f make-bcache probe-bcache bcache-super-show bcache-test 
bcache-register -- *.o

  bcache-test: LDLIBS += `pkg-config --libs openssl` -lm
  make-bcache: LDLIBS += `pkg-config --libs uuid blkid`
