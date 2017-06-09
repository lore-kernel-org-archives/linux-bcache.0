From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.11: ida_remove called for id=16 which is not allocated.
Date: Thu, 8 Jun 2017 19:41:01 -0700
Message-ID: <20170609024101.xo2kqycon2lh4cj2@merlins.org>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
 <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net>
 <20170605015509.nxs6kvokwk4nn5wt@merlins.org>
 <20170605020751.mkemzje27hebpkcm@merlins.org>
 <alpine.LRH.2.11.1706090147150.19359@mail.ewheeler.net>
 <20170609023934.rxjug74gppc6opfz@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35542 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdFIClG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 22:41:06 -0400
Content-Disposition: inline
In-Reply-To: <20170609023934.rxjug74gppc6opfz@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, Jun 08, 2017 at 07:39:34PM -0700, Marc MERLIN wrote:
> It was the cache. I pasted:
> lrwxrwxrwx  1 root root    0 Jun  4 18:53 bcache -> ../md8/bcache
> lrwxrwxrwx  1 root root    0 Jun  4 18:53 bdi -> ../../bdi/252:16/

Sorry, tired, it was the device with data, not the cache.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
