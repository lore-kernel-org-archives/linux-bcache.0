Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600ECC433E6
	for <linux-bcache@archiver.kernel.org>; Fri, 12 Feb 2021 16:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C33364E70
	for <linux-bcache@archiver.kernel.org>; Fri, 12 Feb 2021 16:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBLQK0 (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 12 Feb 2021 11:10:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:35908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhBLQKZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 11:10:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4DF8EAD29;
        Fri, 12 Feb 2021 16:09:42 +0000 (UTC)
Subject: Re: [PATCH 00/20] bcache patches for Linux v5.12
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Kai Krakow <kai@kaishome.de>
References: <20210210050742.31237-1-colyli@suse.de>
 <50173dee-31dd-9951-bc7f-b5247a46ef5e@kernel.dk>
From:   Coly Li <colyli@suse.de>
Message-ID: <4f6a39e3-f80b-cdc2-aa50-5aa44a6fb8eb@suse.de>
Date:   Sat, 13 Feb 2021 00:09:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <50173dee-31dd-9951-bc7f-b5247a46ef5e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 11:11 PM, Jens Axboe wrote:
> On 2/9/21 10:07 PM, Coly Li wrote:
>> Hi Jens,
>>
>> This is the first wave bcache patches for Linux v5.12.
>>
>> It is nice to see in this round we have 3 new patch contributors:
>> Jianpeng Ma, Qiaowei Ren and Kai Krakow.
>>
>> In this series, the EXPERIMENTAL patches from Jianpeng Ma, Qiaowei Ren
>> and me are initial effort to store bcache meta-data on NVDIMM namespace.
>> The NVDIMM space is managed and mapped via DAX interface, and accessed
>> by linear address. In this submission we store bcache journal on NVDIMM,
>> in future bcache btree nodes and other meta data will be added in too,
>> before we remove the EXPERIMENTAL statues.
>>
>> Dongdong Tao contributes a performance optimization when
>> bcache cache buckets are highly fregmented, Dongdong's patch makes the
>> dirty data writeback faster and from his benchmark reprots such changes
>> have recognized improvement for randome write I/O thoughput and latency
>> for highly fregmented buckets, and no regression for regular I/O
>> observed.
>>
>> Kai Krakow contributes 4 patches to offload system_wq usage to separated
>> btree_io_wq and bch_flush_wq. In his environment the daily backup job
>> throughput increases from 60.2MB/s to 419MB/s and accomplished time
>> reduced from 14h29m to 2h13m.
>>
>> Joe Perches also contributes a fine code stype fix which I pick for this
>> submission.
>>
>> Please take them for Linux v5.12 merge window.
> 
> Applied 1-6 for now, that weird situation with the user visible header
> needs to get resolved before it can go any further.
> 
Thanks for taking care of the patches and offering your opinion. I will
ask you and other developers' suggestion for a proper form for the data
structure definition.

Coly Li
