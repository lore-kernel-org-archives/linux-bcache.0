Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBABC433EF
	for <linux-bcache@archiver.kernel.org>; Thu, 10 Mar 2022 12:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbiCJMJG (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbiCJMJF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Mar 2022 07:09:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883AEE6DB5
        for <linux-bcache@vger.kernel.org>; Thu, 10 Mar 2022 04:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646914084; x=1678450084;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+6vvAqSDQcbKNmERXFjqEl0AldkatYOiVu9+f3dQU3c=;
  b=ayLVNmIeqSnrCttg85Outgh+hBogVBrX5gizKa7NMN5UOzjaD8eExHMf
   W88elD66Qy+na6eXljZcryc8aKUs2aWe5dKlxF2SJJ+rEqi+1iTf3aSNJ
   jaR08qYnf6xGFtdXkLytw7+ghqtR6xeLh5yXuZxtg31D/59zExH7TJd4U
   EOO0u+FxuEd9YruUHeBxyIuYz/3XVhrUZvx7MnQdweOY9ux5XHKf4u0gC
   2J+ACxJ9FGEnSg2PDa+fyNN9EDhqsB5/OEfu5Dh/EehPjrpIb5Qr/0GnK
   dZ+HyLgIrCKtpf34FSr1iZ1RDrncfuF1r2VfZ51VOuL/YShL8UrrRgWUH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="279971169"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="279971169"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 04:08:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="578774310"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 10 Mar 2022 04:08:01 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSHaL-0004tZ-0X; Thu, 10 Mar 2022 12:08:01 +0000
Date:   Thu, 10 Mar 2022 20:07:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>,
        linux-bcache@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Coly Li <colyli@suse.de>,
        Kent Overstreet <kmo@daterainc.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>,
        Andrea Tomassetti <andrea.tomassetti@devo.com>
Subject: [RFC PATCH] bcache: bch_service_ioctl_ctrl() can be static
Message-ID: <20220310120708.GA86940@32b0ac190af4>
References: <20220310085240.334068-1-andrea.tomassetti@devo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310085240.334068-1-andrea.tomassetti@devo.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

drivers/md/bcache/control.c:18:6: warning: symbol 'bch_service_ioctl_ctrl' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 drivers/md/bcache/control.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/control.c b/drivers/md/bcache/control.c
index dad432613474b..69b5e554d0935 100644
--- a/drivers/md/bcache/control.c
+++ b/drivers/md/bcache/control.c
@@ -15,7 +15,7 @@ static struct bch_ctrl_device _control_device;
 
 /* this handles IOCTL for /dev/bcache_ctrl */
 /*********************************************/
-long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
+static long bch_service_ioctl_ctrl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
 	int retval = 0;
