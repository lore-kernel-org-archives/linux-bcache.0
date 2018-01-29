From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 13/13] bcache: add stop_when_cache_set_failed to struct
 cached_dev
Date: Mon, 29 Jan 2018 21:02:18 +0800
Message-ID: <9f2e507d-bc5b-333b-eefe-d76a6440fdcf@suse.de>
References: <20180127142406.89741-1-colyli@suse.de>
 <20180127142406.89741-14-colyli@suse.de> <87inbkesbg.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbeA2NC1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jan 2018 08:02:27 -0500
In-Reply-To: <87inbkesbg.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>

On 29/01/2018 8:57 PM, Nix wrote:
> On 27 Jan 2018, Coly Li said:
> 
>> Current bcache failure handling code will stop all attached bcache devices
>> when the cache set is broken or disconnected. This is desired behavior for
>> most of enterprise or cloud use cases, but maybe not for low end
>> configuration. Nix <nix@esperi.org.uk> points out, users may still want to
>> access the bcache device after cache device failed, for example on laptops.
> 
> Actually I'm much interested in the server use case. On laptops, it's
> relatively easy to recover if you know what you're doing, because they
> usually have a user in front of them with console access -- but if a
> remote headless server with a hundred users a thousand miles away has
> its cache device wear out I would really rather the hundred users get
> served, if more slowly, rather than the whole machine going down for
> hours or days until I can get someone there to bash on the hardware!
> 

Hi Nix,

Thanks for the input, I didn't think of such use case before. It makes a
lot sense !

> (Sure, ideally you'd detect the wearing out in advance, but SSDs are not
> always nice and helpful like that and sometimes just go instantly
> readonly or simply vanish off the bus entirely without warning.)
> 

Yes. Then in the v5 patch set, I will add an option for "always"/"auto",
which will leave bcache device alive if the broken cache set is clean.

Thank you all again, for the insight and brilliant suggestion !

Coly Li
