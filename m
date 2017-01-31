From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache: based on for-4.10/block, multiple updates
Date: Tue, 31 Jan 2017 11:27:59 -0800
Message-ID: <15228b09-e185-7587-c905-700ca878e80f@kernel.dk>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net>
 <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk>
 <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net>
 <20161030140050.q6ywphi3by6yoczc@kmo-pixel>
 <6bda49c5-5ed8-939f-aab3-faa9c8127ff0@kernel.dk>
 <alpine.LRH.2.11.1612061145430.13402@mail.ewheeler.net>
 <alpine.LRH.2.11.1612141747470.31582@mail.ewheeler.net>
 <d162cba4-c1e9-d028-fe60-1e1d1fe22e29@kernel.dk>
 <alpine.LRH.2.11.1701311103140.28608@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34998 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbdAaT2C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2017 14:28:02 -0500
Received: by mail-pf0-f173.google.com with SMTP id f144so110215496pfa.2
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2017 11:28:02 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1701311103140.28608@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>, Emmanuel Florac <eflorac@intellique.com>, Hans van den Bogert <hansbogert@gmail.com>, "Jens-U. Mozdzen" <jmozdzen@nde.ag>

On 01/31/2017 11:14 AM, Eric Wheeler wrote:
> On Wed, 14 Dec 2016, Jens Axboe wrote:
>> On 12/14/2016 06:50 PM, Eric Wheeler wrote:
>>> Hi Jens,
>>>
>>> I know you're busy, so when you get a moment:
>>>
>>> I've not yet seen your ack/nack on this yet and I want to make sure it 
>>> gets in before the merge window closes for v4.10.  I rebased it on 
>>> for-4.10/block as you asked so its tested and ready to go as of 12/6 
>>> unless you see something that I've missed.
>>
>> Pulled for 4.10, sorry about the delay.
> 
> Hi Jens,
> 
> Looking at 4.10-rc6, I see these two commits were merged:
> 
>>       bcache: partition support: add 16 minors per bcacheN device
>>       bcache: Make gc wakeup sane, remove set_task_state()
> 
> but these were in the same 'for-4.10-block-bcache-updates' and don't
> appear to have been applied:
> 
>>       bcache: introduce per-process ioprio-based bypass/writeback hints
>>       bcache: documentation for ioprio cache hinting
>>       bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
> 
> Did I miss an email that caused their exclusion?
> 
> Did these get bumped to 4.11 for some reason?

I thought I sent out that reply, maybe I didn't. I dropped the
last three for two reasons:

1) They happened after the merge window, and it's really a feature
   addon that should have gone in earlier

2) There seemed to be confusion and discussion around the interface
   that needed to be resolved first.

Hope that explains it.

-- 
Jens Axboe
