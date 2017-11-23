From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Thu, 23 Nov 2017 15:09:05 +0000
Message-ID: <5ab429e6-a376-6995-172b-9370de89fe4c@ehuk.net>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <1c715cc2-b656-36a8-4017-55052937df82@lyle.org>
 <CAPGwLLNyjjxKOXA3RCFGSi4p-ZWZ5T9ADWP6EAqrfL3oUvMbFQ@mail.gmail.com>
 <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
 <8cb4231f-9b0d-3cb3-d733-b868f37daa6d@lyle.org>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:40465 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752833AbdKWPJH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Nov 2017 10:09:07 -0500
In-Reply-To: <8cb4231f-9b0d-3cb3-d733-b868f37daa6d@lyle.org>
Content-Language: en-GB
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Rui Hua <huarui.dev@gmail.com>, Coly Li <i@coly.li>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

On 22/11/17 05:13, Michael Lyle wrote:
> Reviewed-by: Michael Lyle <mlyle@lyle.org>

<snip>

I have a little dilemma now related to this patch and I wonder if I 
could ask you guys for your opinion?

I have been hit and am being hit by the bug this patch fixes every few 
days at the moment, on writeback bcache resources. When it hits it 
causes a failure in the layer above, and this leads to other problems 
that can and has led to loss of data (not in bcache, just that the read 
failure causes a chain of events in upper layer, separate issue, won't 
clutter this mail with that). So, I am very keen to resolve this 
urgently in my environment.

I am running stable 4.9, and I have cherry picked several recent bcache 
patches, including "bcache: only permit to recovery read error
when cache device is clean", which I understand causes this issue.

I have a dilemma now whether I should apply the new patch in this 
thread, which should fix the issue, or revert "only permit to recovery 
read error" patch.

The dilemma is because I don't like the idea of reverting the "only 
permit to recovery read error" patch since it appears to fix an 
important problem.  Or am I overestimating the problem (maybe that's why 
the original patch has not been backported to stable kernels, maybe the 
original issue quite rare)?

But I am also wary of applying the new patch as Michael only just added 
to his tree so hasn't had much baking time.

I wondered what is the opinion of you guys which of these two I should 
choose?

(BTW, please don't say "just don't cherry pick onto 4.9". I am aware of 
the risks of cherry picking, as discussed recently on this list. I am 
happy with the level of risk and I am being very careful in what I pick. 
In this case I have not been "burnt" by cherry picking since I would 
have hit the same issue if I would have just upgraded to 4.14 which 
contains the original "only permit to recovery read error" patch.)

( N.B. I understand that any opinion/advice I receive is just that. I 
take complete responsibility for what I decide :-) )

Thanks!
Eddie
