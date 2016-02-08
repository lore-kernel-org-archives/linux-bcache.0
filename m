From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: lvmcache performance
Date: Mon, 08 Feb 2016 14:05:24 -0800
Message-ID: <87mvrarh7f.fsf@thinkpad.rath.org>
References: <87a8nctl7x.fsf@vostro.rath.org> <20160208091705.GA1612@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55117 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756756AbcBHWF1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 8 Feb 2016 17:05:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id A27C0207E2
	for <linux-bcache@vger.kernel.org>; Mon,  8 Feb 2016 17:05:26 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 55AA9680154
	for <linux-bcache@vger.kernel.org>; Mon,  8 Feb 2016 17:05:26 -0500 (EST)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id 4FA361CC874
	for <linux-bcache@vger.kernel.org>; Mon,  8 Feb 2016 22:05:25 +0000 (UTC)
In-Reply-To: <20160208091705.GA1612@rh-vpn> (Joe Thornber's message of "Mon, 8
	Feb 2016 09:17:06 +0000")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Feb 08 2016, Joe Thornber <thornber@redhat.com> wrote:
> On Sun, Feb 07, 2016 at 10:43:30AM -0800, Nikolaus Rath wrote:
>> Is that the wrong expectation? But even then, shouldn't I at least s=
ee
>> some improvement?
>
> Firstly, if you have the latest software, I suggest you switch to the
> smq cache policy which is generally out performing the old mq policy
> substantially.

Will try, thanks.


> Secondly, I think you may need to reset your expectations a bit.
> dm-cache is a slow moving cache.  It monitors IO, detectings hotspots
> on the disk and then 'promotes' those regions to the SSD.  You may
> find that the reads that occur during a boot, occur only infrequently
> once the system is booted.

Well, yes, but since in my case the cache is bigger than the origin,
shouldn't eventually *everything* end-up in the cache?

Is there a way to tell how often I need to access a block for it to be
promoted? I was hoping that the {read,write}_promote_adjustement
settings would actually cause promotion on the first access.


Best,
-Nikolaus

(No Cc on replies please, I'm reading the list)
--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
