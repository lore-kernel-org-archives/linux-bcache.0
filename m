From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH V2] bcache: fix potential deadlock problem in
 btree_gc_coalesce
Date: Fri, 12 Jun 2020 09:01:03 +0800
Message-ID: <ae980a3c-f41b-caf6-a384-516656b6fa50@huawei.com>
References: <80c2a2c6-01b9-8280-34b4-ff6b9cfaf76a@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80c2a2c6-01b9-8280-34b4-ff6b9cfaf76a@web.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Elfring <Markus.Elfring@web.de>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Coly Li <colyli@suse.de>, Feilong Lin <linfeilong@huawei.com>, Kent Overstreet <kmo@daterainc.com>, mingfangsen@huawei.com, renxudong1@huawei.com, Wu Bo <wubo40@huawei.com>, yanxiaodan@huawei.com
List-Id: linux-bcache@vger.kernel.org

Sorry for late reply. I will improve the commit log as your suggestion in v3 patch.
Thanks for your suggestion.

On 2020/4/27 2:16, Markus Elfring wrote:
>> --
>> V1->V2: rewrite commit log (suggested by Coly Li) and rename the patch
> 
> * The patch version description should be placed behind triple dashes.
> 
> * I would find a shorter version identification (without the arrow)
>   also sufficient.
> 
> 
>> Fixes: 2a285686c1 ("bcache: btree locking rework")>
> 
> Will a longer commit identifier be safer for the final change description?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=b2768df24ec400dd4f7fa79542f797e904812053#n183
> 
> Regards,
> Markus
> 
