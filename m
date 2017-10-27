From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Can't register existing backing devices anymore
Date: Fri, 27 Oct 2017 21:14:55 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710272114320.24585@mail.ewheeler.net>
References: <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02> <5eb849fa-8f0b-776a-b635-e3f5af122d75@coly.li> <alpine.LRH.2.11.1710271937260.24585@mail.ewheeler.net> <CAJ+L6qcb+ypDfHZQaFc-viT7r8SoMWQvugnVmkPYTU3=e6ogbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:55590 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751189AbdJ0VO4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 17:14:56 -0400
In-Reply-To: <CAJ+L6qcb+ypDfHZQaFc-viT7r8SoMWQvugnVmkPYTU3=e6ogbg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, Jorg Bornschein <jb@capsec.org>, linux-bcache@vger.kernel.org

On Fri, 27 Oct 2017, Michael Lyle wrote:

> On Fri, Oct 27, 2017 at 12:38 PM, Eric Wheeler
> <bcache@lists.ewheeler.net> wrote:
> > Has this been fixed elsewhere?  The suggested quick-fix doesn't appear in
> > 4.14-rc6 so maybe it was solved some other way?
> 
> It's in next for probable inclusion in 4.15, but I am not sure it
> fixes anything and there are other related races.  It should not get
> rushed into 4.14.

Understood, just wanted to make sure it doesn't get lost.


--
Eric Wheeler


> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
