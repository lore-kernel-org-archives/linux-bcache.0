From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: IOPRIO_PRIO_VALUE needs parens around (data)  (was: [4.9.1] Compiler
 warnings in bcache)
Date: Tue, 31 Jan 2017 11:01:22 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1701311100090.28608@mail.ewheeler.net>
References: <20170109193422.734b3088@jupiter.sol.kaishome.de> <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-930125809-1485889293=:28608"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:33056 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751599AbdAaTHj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2017 14:07:39 -0500
In-Reply-To: <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-930125809-1485889293=:28608
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 10 Jan 2017, Coly Li wrote:
> On 2017/1/10 上午2:34, Kai Krakow wrote:
> > When compiling kernel 4.9.1, I'm seeing the following warnings:
> > 
> > In file included from ./include/linux/bio.h:23:0,
> >                  from drivers/md/bcache/bcache.h:181,
> >                  from drivers/md/bcache/writeback.c:9:
> > drivers/md/bcache/writeback.c: In Funktion »bch_cached_dev_writeback_init«:
> > ./include/linux/ioprio.h:15:73: Warnung: Klammern um Arithmetik in Operand von »|« empfohlen [-Wparentheses]
> >  #define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | data)
> >                                                                          ^
> > drivers/md/bcache/writeback.c:515:25: Anmerkung: bei Substitution des Makros »IOPRIO_PRIO_VALUE«
> >   dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NR-1);
> >                          ^
> > 
> > It suggests to put parentheses around the expression with the "|"
> > operand. No other kernel source files show warnings for me, so maybe it
> > should be fixed.
> > 
> > I would create a patch myself but I'm not sure if it would be correct
> > and sufficient to put parenthesis around "data" like this:
> > 
> > #define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | (data))

I caught that before submitting to Jens, so its in 4.10.  I agree with 
Coly, however, that (data) should be added but I'm unable to do that at 
the moment.


--
Eric Wheeler



> > 
> 
> Hi Kai Krakow,
> 
> This fix is necessary, please send a patch to IOPRIO_PRIO_VALUE().
> 
> BTW, I don't see dc->ioprio_bypass from upstream kernel source, is it
> from a development tree ?
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-930125809-1485889293=:28608--
