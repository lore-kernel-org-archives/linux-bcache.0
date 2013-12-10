From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Read cache contents cleared on boot?
Date: Tue, 10 Dec 2013 17:25:35 -0600
Message-ID: <52A7A2EF.8020507@nuclearwinter.com>
References: <527ABDED.60902@nuclearwinter.com> <52A4BB32.9010104@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:46051 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750806Ab3LJXZe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 Dec 2013 18:25:34 -0500
In-Reply-To: <52A4BB32.9010104@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org

On 12/8/2013 12:32 PM, Rolf Fokkens wrote:
> On 11/06/2013 11:08 PM, Larkin Lowrey wrote:
>> When I boot my cache usage returns to 1.3GB even when it was nearly full
>> at shutdown (as reported by bcache-status). Are the read cache contents
>> not retained across a reboot?
> Same here: After running for a while bcache-status reports a Total
> Cache Used of 2.1GB. After reboot it's back to 910MB all the time. Did
> you get an explanation for this?

I never got an explanation but I have a theory. My cache has started
booting with much more total cache used reported. My theory is that
garbage collection is occurring on boot and that my pre-shutdown numbers
contain a lot of dirty pages. I plan to verify this, when I get a
chance, by forcing a garbage collection before shutdown and comparing
the post GC numbers to the post boot numbers.

--Larkin
