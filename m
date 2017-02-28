From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache: based on for-4.10/block, multiple updates
Date: Mon, 27 Feb 2017 18:00:32 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702271800260.10923@mail.ewheeler.net>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net> <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk> <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net> <20161030140050.q6ywphi3by6yoczc@kmo-pixel> <6bda49c5-5ed8-939f-aab3-faa9c8127ff0@kernel.dk>
 <alpine.LRH.2.11.1612061145430.13402@mail.ewheeler.net> <alpine.LRH.2.11.1612141747470.31582@mail.ewheeler.net> <d162cba4-c1e9-d028-fe60-1e1d1fe22e29@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:44544 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751612AbdB1CD3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2017 21:03:29 -0500
In-Reply-To: <d162cba4-c1e9-d028-fe60-1e1d1fe22e29@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>, Emmanuel Florac <eflorac@intellique.com>, Hans van den Bogert <hansbogert@gmail.com>, "Jens-U. Mozdzen" <jmozdzen@nde.ag>

On Wed, 14 Dec 2016, Jens Axboe wrote:
> On 12/14/2016 06:50 PM, Eric Wheeler wrote:
> > Hi Jens,
> > 
> > I know you're busy, so when you get a moment:
> > 
> > I've not yet seen your ack/nack on this yet and I want to make sure it 
> > gets in before the merge window closes for v4.10.  I rebased it on 
> > for-4.10/block as you asked so its tested and ready to go as of 12/6 
> > unless you see something that I've missed.
> 
> Pulled for 4.10, sorry about the delay.

Hi Jens,

Checking in:

Can you get this in for 4.11 since it was missed for 4.10 and we're not in 
4.11-rc1 yet?

Here it is again:

  https://bitbucket.org/ewheelerinc/linux.git for-4.10-block-bcache-updates


--
Eric Wheeler


> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
