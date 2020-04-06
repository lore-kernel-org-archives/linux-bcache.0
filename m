From: "wanghai (M)" <wanghai38@huawei.com>
Subject: Re: [PATCH] bcache: remove set but not used variable 'i'
Date: Mon, 6 Apr 2020 14:39:27 +0800
Message-ID: <d26a90e8-075e-52b4-e633-d68f231c14b4@huawei.com>
References: <1586259407-23673-1-git-send-email-wanghai38@huawei.com>
 <dee5c875-4b4e-c425-ec8d-35e7599c4f5f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:12679 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgDFGjf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Apr 2020 02:39:35 -0400
In-Reply-To: <dee5c875-4b4e-c425-ec8d-35e7599c4f5f@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org


在 2020/4/6 12:43, Coly Li 写道:
> On 2020/4/7 7:36 下午, Wang Hai wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/md/bcache/btree.c: In function bch_btree_check_thread:
>> drivers/md/bcache/btree.c:1910:6: warning:
>>   variable ‘i’ set but not used [-Wunused-but-set-variable]
>>
>> It's not used since commit 8e7102273f59 ("bcache: make bch_btree_check()
>> to be multithreaded"), so remove it.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> Hi Hai,
>
> Colin King already submitted a similar patch on Apr 2 to fix it.
>
> Thanks.
>
> Coly Li

Thanks for reminding, please ignore this patch.
