From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache + luks
Date: Fri, 10 Apr 2015 10:58:42 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1504101056010.5865@ware.dreamhost.com>
References: <CAK1hC9tUm_Zd6U8rWbcFrxB1efbCuzNFd+KXqtOnW9ZEPjAnXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:50209 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556AbbDJR6o (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 13:58:44 -0400
In-Reply-To: <CAK1hC9tUm_Zd6U8rWbcFrxB1efbCuzNFd+KXqtOnW9ZEPjAnXQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Fri, 10 Apr 2015, arnaud gaboury wrote:

> Here is my device steup, an encrypted backing device:
> 
> ---------------------------------------------------------
> $ lsblk
> ??sdd4                   sdd4      8:52  bcache
>   ??bcache0              bcache0 254:0   crypto_LUKS
>     ??sdd4_crypt         dm-7    253:7   btrfs       poppy-encrypt
> ------------------------------------------------------------
> 
> I first did bcache, then cryptsetup against /dev/bcache0.
> 
> I have a doubt about the order. Is this correct? Or shall I do first
> the encryption part for sdd4 thereafter make bcache?
> 
> Thank you for help

That is the way I would do it. If you were to put LUKS underneath bcache, 
then you would also need to LUKS your cache volume if you care about the 
privacy of your data.

Also, this prevents bcache from using an unusual backing volume (LUKS), 
the configuration of which has probably not been tested very much.

-Eric

--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298



> 
> -- 
> 
> google.com/+arnaudgabourygabx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
