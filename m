From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 00/13] bcache: device failure handling improvement
Date: Fri, 2 Feb 2018 10:04:15 +0800
Message-ID: <aefd75a0-e7de-bbb6-386a-8e7f9a128e98@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
 <2fde00b8-f605-d0d0-a51c-c126a2939326@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2fde00b8-f605-d0d0-a51c-c126a2939326@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 02/02/2018 5:52 AM, Michael Lyle wrote:
> On 01/27/2018 05:56 PM, Coly Li wrote:
>> Hi maintainers and folks,
> 
> Hi Coly---
> 
>> This patch set tries to improve bcache device failure handling, includes
>> cache device and backing device failures.
> 
> I've skimmed this whole patchset and overall it looks good.  I have
> taken some pieces (2,6) for possible-4.16.  I understand you'll be
> sending out a v5 soon-- I'll perform a more detailed review then.

Hi Mike,

Since you will pick patch 2,6 from v4 patch set, I will not include them
in v5 patch set, and rebase the v5 cache set against the latest
bcache-for-next.

Thanks.

Coly Li
