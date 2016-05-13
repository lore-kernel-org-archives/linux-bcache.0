From: Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: bcachefs with cache device and backing device
Date: Thu, 12 May 2016 21:37:01 -0700
Message-ID: <573559ED.9010905@gemtalksystems.com>
References: <573532E2.1040201@gemtalksystems.com>
 <20160513043603.GA1407@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 50-240-19-49-static.hfc.comcastbusiness.net ([50.240.19.49]:42048
	"EHLO office-ns.gemtalksystems.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbcEMEhD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 May 2016 00:37:03 -0400
In-Reply-To: <20160513043603.GA1407@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 05/12/2016 09:36 PM, Kent Overstreet wrote:
>> What I'd like to do, however, is to have an SSD cache device, and a
>> rotating-disk backing device, as a bcachefs filesystem. Is this
>> something that bcachefs can do at present? If so, what's the basic
>> procedure?
>
> Yeah - tiering replaces cache/backing devices
>
> IIRC,
>
> bcache format --tier 0 -C <SSD> --tier 1 -C <spinning rust>
>
> (the -C is going to go away at some point)

Thanks! I'll try that out tomorrow.

-Martin
