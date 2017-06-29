From: Coly Li <i@coly.li>
Subject: Re: [PULL] bcache fixes and updates for-4.13
Date: Fri, 30 Jun 2017 00:19:05 +0800
Message-ID: <da3debfe-11a8-5552-05e3-023424e61d5b@coly.li>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <alpine.LRH.2.11.1706282258100.17052@mail.ewheeler.net>
 <20170629134510.GA32385@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:43098 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbdF2QT3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Jun 2017 12:19:29 -0400
In-Reply-To: <20170629134510.GA32385@infradead.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Jens Axboe <axboe@kernel.dk>, dan.carpenter@oracle.com, tasleson@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>, Kent Overstreet <kent.overstreet@gmail.com>, Coly Li <colyli@suse.de>, Stefan Bader <stefan.bader@canonical.com>, Liang Chen <liangchen.linux@gmail.com>, nix@esperi.org.uk

On 2017/6/29 下午9:45, Christoph Hellwig wrote:
> On Wed, Jun 28, 2017 at 11:06:46PM +0000, Eric Wheeler wrote:
>> Hi Jens,
>>
>> It looks like you're getting ready for 4.13, so here are the bcache 
>> updates rebased and ready from git.kernel.dk/linux-block for-4.13/block 
>> This tree builds, boots, and works as expected.  Please pull the new fixes 
>> and features below.
>>
>> Thank you for your help!
> 
> Can you please send all the patches to linux-block for review as
> a series?  Some of these subjects sound a little suspect.
> 

We need more eyes to look at bcache code, maybe we can always CC bcache
patches to linux-block for more review.

-- 
Coly Li
