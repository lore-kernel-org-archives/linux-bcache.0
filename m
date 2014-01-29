From: matthew patton <pattonme@yahoo.com>
Subject: Re: Moving a backing device between 2 cachesets
Date: Wed, 29 Jan 2014 10:42:36 -0800 (PST)
Message-ID: <1391020956.64142.YahooMailNeo@web181506.mail.ne1.yahoo.com>
References: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local> <lcalu5$iek$1@ger.gmane.org> <56b62eb646f94bbe868ae6b2f26d94e8@navex1.navixia.local> <1391017855.88192.YahooMailNeo@web181502.mail.ne1.yahoo.com> <561910454003456ea6d49ac8b93af44c@navex1.navixia.local>
Reply-To: matthew patton <pattonme@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm1-vm4.access.bullet.mail.bf1.yahoo.com ([216.109.114.75]:43155
	"EHLO nm1-vm4.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbaA2Smh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jan 2014 13:42:37 -0500
In-Reply-To: <561910454003456ea6d49ac8b93af44c@navex1.navixia.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Patrick Zwahlen <paz@navixia.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>



> Moving a resource from one cachet to the other will be a rare event
> (maintenance, patch, test, crash)

The crash aspect of this needs more investigation IMO. So there are way=
s to forcibly turn on a backing disk even if it's cache device is gone =
(because it's now running on the other head-unit). In write-thru at lea=
st you hope the written data is there (modulo caching further up the st=
ack like in the application, or linux filesystem, or downstream at the =
HBA and on-disk caches).=A0

Once the crashed head is booted you'll need to invalidate all associati=
ons still present in the cache device. I don't see how you can "echo <C=
SET-UUID> > /sys/block/bcache0/bcache/dettach" when 'bcache0' doesn't e=
xist anymore on that head. so now we've got no way to clean up the cach=
eset except to blow it away and re-init with 'make-bcache -C <ssd>' or =
do we accomplish the same thing by=A0
'echo=A0unregister > /sys/fs/bcache/<cset-uuid>/bdev'?
