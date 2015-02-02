From: Yongseok Oh <yongsukoh@gmail.com>
Subject: Quick SSD detach
Date: Mon, 2 Feb 2015 07:02:51 +0000 (UTC)
Message-ID: <loom.20150202T075538-167@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60051 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbbBCBfH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 2 Feb 2015 20:35:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YISOO-0001r8-Pb
	for linux-bcache@vger.kernel.org; Tue, 03 Feb 2015 02:35:04 +0100
Received: from ems1.uos.ac.kr ([210.125.184.70])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 03 Feb 2015 02:35:04 +0100
Received: from yongsukoh by ems1.uos.ac.kr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 03 Feb 2015 02:35:04 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all, 

I have seen that detaching an SSD from bcache 
requires several minutes (e.g., 30 min..). 
So I have tried to modify bch_cached_dev_detach() code to 
remove a cache device quickly. 
Unfortunately, kernel panic has been occurred by my modification. 

Is there no option to detach an SSD rapidly? 
I always tried to reboot my system when the 
performance measurement is just finished.  

Thanks. 

 907 void bch_cached_dev_detach(struct cached_dev *dc)
 908 {
 909     lockdep_assert_held(&bch_register_lock);
 910
 911     if (atomic_read(&dc->disk.closing))
 912         return;
 913
 914     if (atomic_xchg(&dc->disk.detaching, 1))
 915         return;
 916
 923     closure_get(&dc->disk.cl);
 924
 927     bch_writeback_queue(dc);
 928
 929     atomic_set(&dc->force_detach, 1);
 930     dc->writeback_running = 0;
 931
 932     atomic_set(&dc->has_dirty, 0);
 933     atomic_set(&dc->running, 0);
 934     schedule_work(&dc->detach);
 942 }
