From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 7 Sep 2015 18:01:38 +0200
Message-ID: <20150907160138.GA5508@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
 <20150905112955.GA4078@suse.com>
 <20150907171318.Horde.LCssHlKH7jqwmHt1ENeCSCd@www3.nde.ag>
 <20150907155217.GA27227@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:40443 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbIGQBk (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Sep 2015 12:01:40 -0400
Content-Disposition: inline
In-Reply-To: <20150907155217.GA27227@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Mon, Sep 07, 2015 at 05:52:17PM +0200, Vojtech Pavlik wrote:

> I'm running the openSUSE most recent stable kernel, available here:
> 
> 	http://download.opensuse.org/repositories/Kernel:/stable/standard/
> 
> It's currently at 4.2.0 and contains all of the above patches. I've
> seen crashes in __find_stripe a couple times a few months apart on older
> kernels, but these aren't likely related to bcache. Similar to this:
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=100321

And actually that should also be fixed by latest code from Neil:

	https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=49895bcc7e566ba455eb2996607d6fbd3447ce16

so bcache is exonerated for any crashes on my system in the past.

-- 
Vojtech Pavlik
Director SUSE Labs
