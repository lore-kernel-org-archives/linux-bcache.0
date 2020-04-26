From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH V2] bcache: fix potential deadlock problem in
 btree_gc_coalesce
Date: Sun, 26 Apr 2020 20:16:36 +0200
Message-ID: <80c2a2c6-01b9-8280-34b4-ff6b9cfaf76a@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Coly Li <colyli@suse.de>, Feilong Lin <linfeilong@huawei.com>, Kent Overstreet <kmo@daterainc.com>, mingfangsen@huawei.com, renxudong1@huawei.com, Wu Bo <wubo40@huawei.com>, yanxiaodan@huawei.com
List-Id: linux-bcache@vger.kernel.org

> --
> V1->V2: rewrite commit log (suggested by Coly Li) and rename the patch

* The patch version description should be placed behind triple dashes.

* I would find a shorter version identification (without the arrow)
  also sufficient.


> Fixes: 2a285686c1 ("bcache: btree locking rework")>

Will a longer commit identifier be safer for the final change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=b2768df24ec400dd4f7fa79542f797e904812053#n183

Regards,
Markus
