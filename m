From: Coly Li <i@coly.li>
Subject: Re: [4.9.1] Compiler warnings in bcache
Date: Sun, 15 Jan 2017 17:36:46 +0800
Message-ID: <aa6e978e-5838-084b-5fe7-126a442b95ec@coly.li>
References: <20170109193422.734b3088@jupiter.sol.kaishome.de>
 <8ca97b22-9888-fa22-5086-46f36eaaa931@coly.li>
 <20170110215134.4d2ea291@jupiter.sol.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:33578 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdAOJgu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 15 Jan 2017 04:36:50 -0500
In-Reply-To: <20170110215134.4d2ea291@jupiter.sol.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <kai@kaishome.de>
Cc: linux-bcache@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>

On 2017/1/11 上午4:51, Kai Krakow wrote:
> Am Tue, 10 Jan 2017 13:41:25 +0800
> schrieb Coly Li <i@coly.li>:
> 
>> On 2017/1/10 上午2:34, Kai Krakow wrote:
>>> When compiling kernel 4.9.1, I'm seeing the following warnings:
>>>
>>> In file included from ./include/linux/bio.h:23:0,
>>>                  from drivers/md/bcache/bcache.h:181,
>>>                  from drivers/md/bcache/writeback.c:9:
>>> drivers/md/bcache/writeback.c: In Funktion
>>> »bch_cached_dev_writeback_init«: ./include/linux/ioprio.h:15:73:
>>> Warnung: Klammern um Arithmetik in Operand von »|« empfohlen
>>> [-Wparentheses] #define IOPRIO_PRIO_VALUE(class, data) (((class) <<
>>> IOPRIO_CLASS_SHIFT) | data) ^ drivers/md/bcache/writeback.c:515:25:
>>> Anmerkung: bei Substitution des Makros »IOPRIO_PRIO_VALUE«
>>> dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
>>> IOPRIO_BE_NR-1); ^
>>>
>>> It suggests to put parentheses around the expression with the "|"
>>> operand. No other kernel source files show warnings for me, so
>>> maybe it should be fixed.
>>>
>>> I would create a patch myself but I'm not sure if it would be
>>> correct and sufficient to put parenthesis around "data" like this:
>>>
>>> #define IOPRIO_PRIO_VALUE(class, data) (((class) <<
>>> IOPRIO_CLASS_SHIFT) | (data)) 
>>
>> Hi Kai Krakow,
>>
>> This fix is necessary, please send a patch to IOPRIO_PRIO_VALUE().
>>
>> BTW, I don't see dc->ioprio_bypass from upstream kernel source, is it
>> from a development tree ?
> 
> Ahhh... This is from Erics ioprio bypass patches. I'm still using the
> 4.8 patchset with 4.9. Maybe it has been updated meanwhile?
> 

Understand. Please compose a patch for this fix, thank you in advance :-)

-- 
Coly Li
