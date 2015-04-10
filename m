From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: bcache + luks
Date: Fri, 10 Apr 2015 17:14:45 +0200
Message-ID: <CAK1hC9tUm_Zd6U8rWbcFrxB1efbCuzNFd+KXqtOnW9ZEPjAnXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33120 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbbDJPOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 11:14:47 -0400
Received: by lbbzk7 with SMTP id zk7so16089354lbb.0
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 08:14:45 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Here is my device steup, an encrypted backing device:

---------------------------------------------------------
$ lsblk
=E2=94=94=E2=94=80sdd4                   sdd4      8:52  bcache
  =E2=94=94=E2=94=80bcache0              bcache0 254:0   crypto_LUKS
    =E2=94=94=E2=94=80sdd4_crypt         dm-7    253:7   btrfs       po=
ppy-encrypt
------------------------------------------------------------

I first did bcache, then cryptsetup against /dev/bcache0.

I have a doubt about the order. Is this correct? Or shall I do first
the encryption part for sdd4 thereafter make bcache?

Thank you for help

--=20

google.com/+arnaudgabourygabx
