From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: Fwd: Bcache Status
Date: Wed, 14 Oct 2015 10:42:48 +0200
Message-ID: <mvl4i8$k8v$1@ger.gmane.org>
References: <CAEC_uJOv7gmb3ddTa0yNHDXHPbX_0Mr2uZsDGM2iNMSrPKex4A@mail.gmail.com>
 <CAEC_uJM_CZbxdMyPct0=Mc4CMzY5u4HYhzQA48dtG7kqfSi_Pg@mail.gmail.com>
 <561BE17C.5020402@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59495 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbbJNIpK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 14 Oct 2015 04:45:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1ZmHgH-00017W-MT
	for linux-bcache@vger.kernel.org; Wed, 14 Oct 2015 10:45:05 +0200
Received: from ip4da2a5ae.direct-adsl.nl ([77.162.165.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 14 Oct 2015 10:45:05 +0200
Received: from koen by ip4da2a5ae.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 14 Oct 2015 10:45:05 +0200
In-Reply-To: <561BE17C.5020402@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Op 12-10-15 om 18:36 schreef Peter Kieser:
> 
> 
> On 2015-10-11 4:04 PM, Andrew Thrift wrote:
>> I notice over the past 18 months there have been a number of patches
>> posted to this mailing list to resolve known issues with bcache.
>>
>> I cant see that these have been merged into the main bcache git at
>> http://evilpiepirate.org/git/linux-bcache.git, is this actually the
>> case or am I mistaken?
>>
>> Will these patches ever be seen in mainline ?
> Backports of critical bug fixes not being done was brought to attention of
> Greg KH in September 2014, where Jens and myself mentioned that bcache stable
> patches (data corruption, stability, etc.) were not being backported to the
> Linux stable branches. The response from the author of bcache was "This kind
> of unnecessary hostility is why I don't bother with stable much anymore. I get
> enough of this bullshit at work, thank you."
> 
> Unfortunately, the situation hasn't cahnged. bcache still will eat your data
> under certain use cases, and there is no warning and bcache still doesn't have
> a testing/experimental flag set on it. I guess the ultimate answer was
> "backport and submit a pull request yourself" but I'm not sure this is
> appropriate.

If Kent won't do it (for whatever reasons), anyone can propose the patches for
backporting to the various stable kernels.

This is a seperate problem than the "patches posted to this list don't get
into mainline at all" issue.
