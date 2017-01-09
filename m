From: Kai Krakow <hurikhan77@gmail.com>
Subject: [4.9.1] Compiler warnings in bcache
Date: Mon, 9 Jan 2017 19:34:22 +0100
Message-ID: <20170109193422.734b3088@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54448 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1164159AbdAISeo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Jan 2017 13:34:44 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1cQem3-0000g9-Pv
        for linux-bcache@vger.kernel.org; Mon, 09 Jan 2017 19:34:27 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

When compiling kernel 4.9.1, I'm seeing the following warnings:

In file included from ./include/linux/bio.h:23:0,
                 from drivers/md/bcache/bcache.h:181,
                 from drivers/md/bcache/writeback.c:9:
drivers/md/bcache/writeback.c: In Funktion »bch_cached_dev_writeback_init«:
./include/linux/ioprio.h:15:73: Warnung: Klammern um Arithmetik in Operand von »|« empfohlen [-Wparentheses]
 #define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | data)
                                                                         ^
drivers/md/bcache/writeback.c:515:25: Anmerkung: bei Substitution des Makros »IOPRIO_PRIO_VALUE«
  dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NR-1);
                         ^

It suggests to put parentheses around the expression with the "|"
operand. No other kernel source files show warnings for me, so maybe it
should be fixed.

I would create a patch myself but I'm not sure if it would be correct
and sufficient to put parenthesis around "data" like this:

#define IOPRIO_PRIO_VALUE(class, data) (((class) << IOPRIO_CLASS_SHIFT) | (data))

-- 
Regards,
Kai

Replies to list-only preferred.
