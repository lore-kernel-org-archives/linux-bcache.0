From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] [PATCH v2] bcache: fix calling ida_simple_remove() with
 incorrect minor
Date: Fri, 27 Oct 2017 21:23:52 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710272123180.24585@mail.ewheeler.net>
References: <OFF5D425D9.E63AA2AA-ON48258155.00224AFB-48258155.002299BE@zte.com.cn> <alpine.LRH.2.11.1707130355040.9683@mail.ewheeler.net> <alpine.LRH.2.11.1710271914140.24585@mail.ewheeler.net>
 <CAJ+L6qc2ask5y-VeYJAtN_H+9WR2ChxWcQ9z++KEUM4WesGU6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qc2ask5y-VeYJAtN_H+9WR2ChxWcQ9z++KEUM4WesGU6w@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Tang Junhui <tang.junhui@zte.com.cn>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, 27 Oct 2017, Michael Lyle wrote:

> Eric--
> 
> On Fri, Oct 27, 2017 at 12:17 PM, Eric Wheeler
> <bcache@lists.ewheeler.net> wrote:
> > Hi Tang,
> >
> > This is an important bugfix since v4.10, can you get a clean patch sent to
> > the list?
> >
> > Michael, if Tang can get this in on time, can this squeeze this into v4.14
> > before the rc's run out?
> 
> Isn't this handled by Coly's 1dbe32ad0a82f39c6dfb7 ?

It does!  Thank you for pointing that out.

--
Eric Wheeler



> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
