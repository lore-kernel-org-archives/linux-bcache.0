From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v4 00/13] bcache: device failure handling improvement
Date: Thu, 1 Feb 2018 13:52:09 -0800
Message-ID: <2fde00b8-f605-d0d0-a51c-c126a2939326@lyle.org>
References: <20180128015625.128497-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:38243 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbeBAVwL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 16:52:11 -0500
Received: by mail-pf0-f175.google.com with SMTP id k19so16165122pfj.5
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2018 13:52:11 -0800 (PST)
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

On 01/27/2018 05:56 PM, Coly Li wrote:
> Hi maintainers and folks,

Hi Coly---

> This patch set tries to improve bcache device failure handling, includes
> cache device and backing device failures.

I've skimmed this whole patchset and overall it looks good.  I have
taken some pieces (2,6) for possible-4.16.  I understand you'll be
sending out a v5 soon-- I'll perform a more detailed review then.

Thanks,

Mike
