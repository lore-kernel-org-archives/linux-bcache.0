From: Nikolaus Rath <Nikolaus@rath.org>
Subject: bcache and LVM
Date: Sun, 07 Feb 2016 09:20:48 -0800
Message-ID: <87k2mgo2rz.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34811 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbcBGSfI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 7 Feb 2016 13:35:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1aSUAr-000263-I0
	for linux-bcache@vger.kernel.org; Sun, 07 Feb 2016 19:35:05 +0100
Received: from ebox.rath.org ([45.79.69.51])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 07 Feb 2016 19:35:05 +0100
Received: from Nikolaus by ebox.rath.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sun, 07 Feb 2016 19:35:05 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

The internet claims that using bcache with LVM is not a good idea
(eg. on https://wiki.archlinux.org/index.php/Bcache )- but I wasn't abl=
e
to find any substantial information other than this general
recommendation.

Is this still (or has ever been) correct? If so, what issues can arise?
And does this happen only when using bcache on top of an LVM LV, or als=
o
when using a bcache device as an LVM PV?


Best,
-Nikolaus

--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
