From: Hannes Tismer <panni@fragstore.net>
Subject: Allow separation of sequential_cutoff
Date: Wed, 16 Jul 2014 12:19:29 +0000
Message-ID: <20140716121929.Horde.UTDswBOXdBbMJiTFap5WRQ1@horde.fragstore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fragstore.net ([5.199.133.96]:42931 "EHLO fragstore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbaGPM3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Jul 2014 08:29:15 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: mail <mail@arni.name>

Dear bcache-developers,

This is a feature request for a very specific use case:

Having a caching device in front of an md-raid on a machine which =20
serves as a low power media server.

The last writes could be cached on the caching device to reduce the =20
non-sleep time of the raid (drives in spindown state) while playing =20
media, together with a huge writeback delay of, let's say, 3 hours,
newest media would always be read from the caching device.

It's not likely that a recently read (watched) media file will be read =
=20
again after having been read before (very recently), but it's very =20
likely that it'll be read once after it was written.

I could disable sequential_cutoff or set it rediculously high. That =20
would result in every sequential read being cached into the caching =20
device, too, which in this use case is not wanted.

Could you split up the sequential_cutoff setting to =20
sequential_read_cutoff and sequential_write_cutoff?

That way writes including sequential ones can be cached for later, but =
=20
sequential reads could be ignored by the cache.


Thank you in advance

Hannes
--=20
Hannes Tismer
Herzogstr. 4
41238 M=C3=B6nchengladbach
