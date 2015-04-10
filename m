From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: bcache + luks
Date: Fri, 10 Apr 2015 21:23:56 +0200
Message-ID: <CAK1hC9sm1J932Nnon5szBmvP=w3D10mVNOX0QLmzF-S5D4-WTw@mail.gmail.com>
References: <CAK1hC9tUm_Zd6U8rWbcFrxB1efbCuzNFd+KXqtOnW9ZEPjAnXQ@mail.gmail.com>
	<alpine.DEB.2.02.1504101056010.5865@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33209 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbbDJTX5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 15:23:57 -0400
Received: by layy10 with SMTP id y10so20167175lay.0
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 12:23:56 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1504101056010.5865@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Fri, Apr 10, 2015 at 7:58 PM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> On Fri, 10 Apr 2015, arnaud gaboury wrote:
>
>> Here is my device steup, an encrypted backing device:
>>
>> ---------------------------------------------------------
>> $ lsblk
>> ??sdd4                   sdd4      8:52  bcache
>>   ??bcache0              bcache0 254:0   crypto_LUKS
>>     ??sdd4_crypt         dm-7    253:7   btrfs       poppy-encrypt
>> ------------------------------------------------------------
>>
>> I first did bcache, then cryptsetup against /dev/bcache0.
>>
>> I have a doubt about the order. Is this correct? Or shall I do first
>> the encryption part for sdd4 thereafter make bcache?
>>
>> Thank you for help
>
> That is the way I would do it.

Very good. Thank you



 If you were to put LUKS underneath bcache,
> then you would also need to LUKS your cache volume if you care about the
> privacy of your data.
>
> Also, this prevents bcache from using an unusual backing volume (LUKS),
> the configuration of which has probably not been tested very much.
>
> -Eric
>
> --
> Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
> 888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
> www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
>
>
>
>>
>> --
>>
>> google.com/+arnaudgabourygabx
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



-- 

google.com/+arnaudgabourygabx
