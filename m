From: jdd <jdd@dodin.org>
Subject: Re: reading an ex linux bcache disk
Date: Thu, 28 May 2015 09:38:57 +0200
Message-ID: <5566C611.20005@dodin.org>
References: <5566BEE5.4020108@dodin.org> <CAPBO7Ta2fHeS2eZaxvoTVBhEuukL=Mux7bZEvMCdcwpLJzSZvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44043 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbE1HjA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 May 2015 03:39:00 -0400
Received: from [192.168.0.22] (unknown [82.228.87.93])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 7FB1CD48021
	for <linux-bcache@vger.kernel.org>; Thu, 28 May 2015 09:34:33 +0200 (CEST)
In-Reply-To: <CAPBO7Ta2fHeS2eZaxvoTVBhEuukL=Mux7bZEvMCdcwpLJzSZvA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

Le 28/05/2015 09:31, Josep Lladonosa a =C3=A9crit :

>  > right now I get a "file system unknown" when I try to mount the
> bcache partition.
>
> To mount a bcache partition you need an associated caching device
> (previous ssd, or a newly created), if I am not wrong. At least I had=
 to
> do this to access to one.

could I use (for a moment only) an usb device? it's not for performance=
,=20
only to access the partition. It seems to be possible for new install?

thanks
jdd
