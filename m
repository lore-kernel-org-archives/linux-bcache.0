From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: disk gone
Date: Wed, 14 Jun 2017 00:24:50 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706140013280.14877@mail.ewheeler.net>
References: <C081436D-3227-4388-A1DF-9764FB693924@gmail.com>        <alpine.LRH.2.11.1706090144550.19359@mail.ewheeler.net> <20170610121722.124dbfc0@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:41658 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752456AbdFNAYx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Jun 2017 20:24:53 -0400
In-Reply-To: <20170610121722.124dbfc0@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: feng D <fengidri@gmail.com>

On Sat, 10 Jun 2017, Kai Krakow wrote:
> Am Fri, 9 Jun 2017 01:46:24 +0000 (UTC)
> schrieb Eric Wheeler <bcache@lists.ewheeler.net>:
> 
> > On Fri, 2 Jun 2017, feng D wrote:
> > 
> > > hi:
> > > 
> > > Some time, the online machine will appear disk gone situation,
> > > although this is not very common, but we have too many machines, so
> > > still will encounter it.
> > > 
> > > That in the case of disk gone, /sys/block/bcache0/bcache/stop is
> > > not found, this case how to delete the bcache0?  
> > 
> > An interesting question.  Is it still available from the cache device
> > in /sys/fs/bcache/* somewhere?  I'm guessing not, but check.
> > 
> > Do you have a procedure to reproduce this problem
> > where /sys/block/bcache0 has been hotplugged into oblivion?
> 
> You easily run into the same situation when you stop the device instead
> of detaching it. Bcache then doesn't release its cache device and
> cannot be stopped/unregistered, because every interface for shutting
> bcache down has vanished: It can only be reached through the backing
> devices but the bcache interface below those is gone.
> 
> I think bcache needs a way to force unregister the cache device...
> Otherwise the cache device stays busy and cannot be registered, neither
> can any devices be attached again in this state.

I'm having trouble reproducing:

]# echo /dev/centos/bcache0 > /sys/fs/bcache/register
]# echo /dev/centos/bcache0-cache > /sys/fs/bcache/register
]# 
]# echo 1 > /sys/block/bcache0/bcache/stop
]# echo 1 > /sys/fs/bcache/3e57bc2e-4f01-4164-9b6d-54ef288ae394/stop
]#
]# echo /dev/centos/bcache0 > /sys/fs/bcache/register
]# echo /dev/centos/bcache0-cache > /sys/fs/bcache/register

also tried swapping the stop order:

]# echo /dev/centos/bcache0 > /sys/fs/bcache/register
]# echo /dev/centos/bcache0-cache > /sys/fs/bcache/register
]#
]# echo 1 > /sys/fs/bcache/3e57bc2e-4f01-4164-9b6d-54ef288ae394/stop   
]# echo 1 > /sys/block/bcache0/bcache/stop 
   >>> fails, no such file, but re-registers fine below
]#
]# echo /dev/centos/bcache0 > /sys/fs/bcache/register
]# echo /dev/centos/bcache0-cache > /sys/fs/bcache/register

What am I missing here?


--
Eric Wheeler



> 
> -- 
> Regards,
> Kai
> 
> Replies to list-only preferred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
