From: Wido den Hollander <wido@42on.com>
Subject: Re: Partitions on bcache devices
Date: Fri, 14 Oct 2016 14:15:35 +0200 (CEST)
Message-ID: <1673593557.6129.1476447335568@ox.pcextreme.nl>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
 <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
 <20160929183122.3641f307@harpe.intellique.com>
 <293451899.5382.1475167934533@ox.pcextreme.nl>
 <20160929191127.779f94d0@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp02.mail.pcextreme.nl ([109.72.87.139]:33835 "EHLO
        smtp02.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbcJNMQ3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Oct 2016 08:16:29 -0400
In-Reply-To: <20160929191127.779f94d0@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org


> Op 29 september 2016 om 19:11 schreef Emmanuel Florac <eflorac@intellique.com>:
> 
> 
> Le Thu, 29 Sep 2016 18:52:14 +0200 (CEST)
> Wido den Hollander <wido@42on.com> écrivait:
> 
> > > I agree, but usually you wouldn't partition an MD-RAID either, would
> > > you? OSDs are still holding (so far) ordinary filesystems locally
> > > mounted on the nodes (except for BlueStore AFAIK).
> > >   
> > 
> > I have partitioned MD-RAID before, works just fine.
> > 
> 
> Yes, sure. It just doesn't feel right, my  grey-bearded Unix instinct
> tingles :)
> 
> > The question still remains, can bcache be patched that it allocates
> > the right minor in the kernel so that it allows for partitions.
> 
> Even looks easy... As Sam Yaple made a patch.
> 
> > I'm not a kernel nor bcache developer, just looking for somebody who
> > would be willing to do this. Happy to assist, support and test!
> 
> Well if I have some time I may give it a try next week :)
> 

I was wondering if you were able to take a look at this?

Wido

> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
