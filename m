From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Thu, 08 Jan 2015 20:47:44 +0100
Message-ID: <54AEDEE0.9090601@rolffokkens.nl>
References: <20141228023534.GA25860@cuci.nl> <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com> <54A81B78.2070409@rolffokkens.nl> <20150104004621.GA4460@kmo-pixel> <54A94A1C.9050906@rolffokkens.nl> <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com> <54AC5F22.6040200@rolffokkens.nl> <alpine.DEB.2.02.1501071214210.19734@ware.dreamhost.com> <20150108023054.GB1263@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56411 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbAHTrs (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 8 Jan 2015 14:47:48 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so4483107wgh.3
        for <linux-bcache@vger.kernel.org>; Thu, 08 Jan 2015 11:47:46 -0800 (PST)
In-Reply-To: <20150108023054.GB1263@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On 01/08/2015 03:30 AM, Kent Overstreet wrote:
> On Wed, Jan 07, 2015 at 12:17:19PM -0800, Eric Wheeler wrote:
>> Would it make sense to call this bcache2 and merge both into the 
>> linux tree once bcache2 is stable enough for broader testing? 
> Yeah that might be what happens.
I would be very much in favour if this approach. The (temporary) 
availability of both bcache and bcache2 gives users not only time to 
test it, but to migrate as well.
