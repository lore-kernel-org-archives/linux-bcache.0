From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: bcachefs now has its own page
Date: Tue, 30 Aug 2016 10:49:42 +0200
Message-ID: <20160830104942.Horde.ON8RCuYr4Vv7oabg3Cebld4@www3.nde.ag>
References: <20160829221858.qnn7svhakzje5eut@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:24304 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756907AbcH3I4M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Aug 2016 04:56:12 -0400
In-Reply-To: <20160829221858.qnn7svhakzje5eut@kmo-pixel>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Kent,

Zitat von Kent Overstreet <kent.overstreet@gmail.com>:
> The code is definitely ready for wider usage, so I'm starting to work more on
> the website and documentation - have a look:
>
> https://bcache.evilpiepirate.org/Bcachefs/
>
> Comments (and help with documentation!) appreciated.

thank you for starting that separate information block. It already  
answers one of my main questions - "why should I use bcachefs instead  
of bcache?" - and one statement there let me take a look at the Bcache  
page:

"the bcachefs codebase is considerably more robust and mature than  
upstream bcache"

(the following statements relate to the bcache page, so they don't fit  
the "comments on bcachefs docs" request ;) )

As I still see "bcache" as the proper solution to fit *my* needs (see  
below), I'm of course interested to run code that's as robust and  
mature as can be. What I was looking for on the bcache page was  
information on some bcache repository containing "more robust and  
mature than upstream bcache" code and how to merge that into current  
mainline kernels. For me, that was left unanswered.

Looking at the bcache page I see:

"Bcache has been merged into the mainline Linux kernel; for the latest  
stable bcache release use the latest 3.10 or 3.11 stable kernel."

Wasn't much effort put into pulling the latest bcache patches into the  
4.x mainline kernel? And it might be interesting to mention if/which  
distro maintainers (i. e. SUSE, the only one I know of for sure) put  
patches and updates into their distributed kernels, likely making  
their kernels more robust and mature than upstream (WRT bcache).

I understand that your current focus is on bcachefs, but as I need to  
provide fast block storage back-ends to i. e. DRBD, I'm stuck with  
bcache (as a substitute for storage controllers with integrated  
SSD/flash cache). Hence my comments here - and they are meant as  
*comments*, not complaints.

Regards,
Jens
