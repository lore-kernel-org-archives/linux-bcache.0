From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Advice of fielsystem type
Date: Fri, 10 Apr 2015 16:25:19 +0200
Message-ID: <CAK1hC9t_+LUUMQzLywR_mHtv_t09x9qUvjqDqwAvyZtEqhuW0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34785 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbbDJOZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 10:25:21 -0400
Received: by laat2 with SMTP id t2so14500491laa.1
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2015 07:25:19 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Here is my configuration:

$ lsblk
=2E......................
=E2=94=94=E2=94=80sdb2                   sdb2      8:18  bcache
  =E2=94=94=E2=94=80bcache0              bcache0 254:0   crypto_LUKS
    =E2=94=94=E2=94=80sdd4_crypt         dm-7    253:7   btrfs       po=
ppy-encrypt
=2E..................................
=E2=94=94=E2=94=80sdd4                   sdd4      8:52  bcache
  =E2=94=94=E2=94=80bcache0              bcache0 254:0   crypto_LUKS
    =E2=94=94=E2=94=80sdd4_crypt         dm-7    253:7   btrfs       po=
ppy-encrypt
=2E....................................................................=
=2E

sdb2/sdd4 are attached caching/backing device.
sdb2 is a empty partition on a SSD dedicated to bcache. No data on it.

sdd4 is a encrypted/btrfs on a HD and will host, among other things, my=
 DB.

I didn't make any filesystem on sdd2. First question: shall I ? If
yes, what will be the more appropriate for speed : ext2 or Btrfs?

Thank you.

--=20

google.com/+arnaudgabourygabx
