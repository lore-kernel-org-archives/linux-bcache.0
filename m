From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Issue when mkfs.btrfs on a bcached partition
Date: Sun, 5 Apr 2015 11:47:41 +0200
Message-ID: <CAK1hC9v+ghET3=XAStWzofF-4But=sGhFgA-jhHZOobe2jSEzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36618 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbDEJrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 5 Apr 2015 05:47:42 -0400
Received: by lbbug6 with SMTP id ug6so4624789lbb.3
        for <linux-bcache@vger.kernel.org>; Sun, 05 Apr 2015 02:47:41 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Here is what I did:
 # make-bcache -C /dev/sdb1
 # echo "UUID" > /sys/block/bcache0/bcache/attach
--------------------------------------
$ lsblk -o
=2E......................
sdb                      sdb
=E2=94=94=E2=94=80sdb1                   sdb1    bcache
  =E2=94=94=E2=94=80bcache0              bcache0
--------------------------------
# mkfs.btrfs -L poppy-root /dev/sdb1
/dev/sdb1 appears to contain an existing filesystem (bcache).
Error: Use the -f option to force overwrite.


Please may you tell what is wrong and how can I make btrfs on bcached p=
artition?

Thank you
