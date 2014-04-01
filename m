From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Tue, 01 Apr 2014 08:51:46 +0200
Message-ID: <533A6202.4020207@gmail.com>
References: <lh8t08$1dd$1@ger.gmane.org> <5338DF1B.9080002@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33790 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAGuc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 1 Apr 2014 02:50:32 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so4495952wiv.9
        for <linux-bcache@vger.kernel.org>; Mon, 31 Mar 2014 23:50:31 -0700 (PDT)
In-Reply-To: <5338DF1B.9080002@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>, linux-bcache@vger.kernel.org

On 03/31/2014 05:20 AM, Peter Kieser wrote:
> 
> On 2014-03-30 3:53 AM, Francis Moreau wrote:
>> That's just sad to see how unstable was/is bcache sub system and I still
>> don't understand why it was not marked as experimental.
> 
> IMO, It should still be marked as experimental. Possibly, even removed 
> from mainline as the maintainer is not particularly responsive to major 
> bugs. Certainly not production ready and it's been through many releases 
> of the kernel now.

Well, removing from mainline is quite extreme but moving it to the
staging stuff would be a possible alternative.

And it should definitely be marked experimental in stable trees such as
3.12 (LTS kernel) IMHO. Specially since those trees don't get any fixes.
