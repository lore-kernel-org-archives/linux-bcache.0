From: Steven Flintham <mlist@lemma.co.uk>
Subject: System locks up when executing make-bcache -C on an LVM logical volume
Date: Sat, 24 Jan 2015 17:05:46 +0000
Message-ID: <54C3D0EA.9060609@lemma.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57365 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbAXRFx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 24 Jan 2015 12:05:53 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so2548130wgh.10
        for <linux-bcache@vger.kernel.org>; Sat, 24 Jan 2015 09:05:51 -0800 (PST)
Received: from [192.168.0.2] (host-78-146-233-141.as13285.net. [78.146.233.141])
        by mx.google.com with ESMTPSA id x6sm6912209wjf.24.2015.01.24.09.05.49
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Jan 2015 09:05:50 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I have a small SSD in my Ubuntu 14.04 system which is mostly allocated 
to an LVM physical volume. I had 25GB free on that physical volume so I 
thought I'd try using it as a bcache cache for my HDD. I create a new 
LVM logical volume, which left things looking like this:

# pvs
   PV         VG   Fmt  Attr PSize  PFree
   /dev/sda2  VG4  lvm2 a--  53.57g    0
   /dev/sdb2  VG6  lvm2 a--   2.69t    0
# lvs
   LV      VG   Attr      LSize  Pool Origin Data%  Move Log Copy% Convert
   VG4-usr VG4  -wi-ao--  19.31g
   VG4-var VG4  -wi-ao---  9.31g
   bcache  VG4  -wi-ao--- 24.95g
   home    VG6  -wi-ao---  2.69t

I then did:

# make-bcache -C /dev/mapper/VG4-bcache

The system immediately locked up completely. (So the above is a 
reconstruction, I don't have the actual command I executed any more, 
although I am 99% certain that's exactly the command executed.)

The system came up OK again after hitting the reset button.

I don't know if this counts as a bug or if it's just a "don't do that, 
then" situation, but a) is this a supported use case? b) if it's not, 
would there be any possibility of make-bcache giving an error instead of 
causing a lock up?

Kernel version as reported by uname -a is:
Linux riemann 3.13.0-44-generic #73-Ubuntu SMP Tue Dec 16 00:22:43 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux

I am using the bcache-tools 1.0.8-1 package from the ppa:g2p/storage 
Ubuntu PPA repository.

If you would like any further information please let me know.

Cheers.

Steve
