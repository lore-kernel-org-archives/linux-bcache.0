From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs with cache device and backing device
Date: Thu, 12 May 2016 20:36:03 -0800
Message-ID: <20160513043603.GA1407@kmo-pixel>
References: <573532E2.1040201@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34175 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcEMEgH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 May 2016 00:36:07 -0400
Received: by mail-pf0-f169.google.com with SMTP id y69so37801526pfb.1
        for <linux-bcache@vger.kernel.org>; Thu, 12 May 2016 21:36:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <573532E2.1040201@gemtalksystems.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Martin McClure <martin.mcclure@gemtalksystems.com>
Cc: linux-bcache@vger.kernel.org

On Thu, May 12, 2016 at 06:50:26PM -0700, Martin McClure wrote:
> I'm trying out bcachefs for the first time. I can follow the
> instructions (format a cache device, mount it type bcache) and it works.
> 
> What I'd like to do, however, is to have an SSD cache device, and a
> rotating-disk backing device, as a bcachefs filesystem. Is this
> something that bcachefs can do at present? If so, what's the basic
> procedure?

Yeah - tiering replaces cache/backing devices

IIRC,

bcache format --tier 0 -C <SSD> --tier 1 -C <spinning rust>

(the -C is going to go away at some point)
