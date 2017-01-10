From: Coly Li <i@coly.li>
Subject: Re: [4.9.1] Compiler warnings in bcache
Date: Tue, 10 Jan 2017 13:41:25 +0800
Message-ID: <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
References: <20170109193422.734b3088@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:40218 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdAJFld (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Jan 2017 00:41:33 -0500
In-Reply-To: <20170109193422.734b3088@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 2017/1/10 上午2:34, Kai Krakow wrote:
> When compiling kernel 4.9.1, I'm seeing the following warnings:
> 
> In file included from ./include/linux/bio.h:23:0,
>                  from drivers/md/bcache/bcache.h:181,
>                  from drivers/md/bcache/writeback.c:9:
> drivers/md/bcache/writeback.c: In Funktion »bch_cached_dev_writeback_init«:
> ./include/linux/ioprio.h:15:73: Warnung: Klammern um Arithmetik in Operand von »|« empfohlen [-Wparentheses]
>  #define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | data)
>                                                                          ^
> drivers/md/bcache/writeback.c:515:25: Anmerkung: bei Substitution des Makros »IOPRIO_PRIO_VALUE«
>   dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NR-1);
>                          ^
> 
> It suggests to put parentheses around the expression with the "|"
> operand. No other kernel source files show warnings for me, so maybe it
> should be fixed.
> 
> I would create a patch myself but I'm not sure if it would be correct
> and sufficient to put parenthesis around "data" like this:
> 
> #define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | (data))
> 

Hi Kai Krakow,

This fix is necessary, please send a patch to IOPRIO_PRIO_VALUE().

BTW, I don't see dc->ioprio_bypass from upstream kernel source, is it
from a development tree ?


-- 
Coly Li
