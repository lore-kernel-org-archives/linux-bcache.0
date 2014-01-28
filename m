From: <jason@warr.net>
Subject: Re: How important is bcache cache device in write-thru mode? (was
 Tiered bcache)
Date: Tue, 28 Jan 2014 18:06:50 +0000 (UTC)
Message-ID: <213734143.48979.1390932410356.JavaMail.mail@webmail05>
References: <201401281420.s0SEK0sb008045@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:43529 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754599AbaA1SG6 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 13:06:58 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: greg@enjellic.com
Cc: paz@navixia.com, linux-bcache@vger.kernel.org, scst-devel@lists.sourceforge.net


on Jan 28, 2014, Dr. Greg Wettstein <greg@wind.enjellic.com> wrote:
>
>The goal for this driver is a block based interface to RAM for use as
>a cache set for bcache. Since it sits directly on the physical
>hugepage allocator and associated page magazine the block devices can
>be dynamically configured, unlike the current RAM based block device,
>which also has the disadvantage of being implemented on top of page
>cache. None of this should be construed as a gripe against the Linux
>VM but obviously one does not want memory pressure to start driving a
>high speed cache store out onto disk.

Thank you.  In my opinion a dynamic ram disk is one of the few pieces still needed in the block device layer.  I would be happy to help beat the crap out of it!
 
Any thoughts on this driver making use of the DM or MD framework?  Obviously your not going to have data persist across a reboot but do you know how you will handle boot time configuration on a device(s) that you want to come back without manual or scripted intervention?

>
>This model is obviously dependent on solid behavior of bcache in
>write-through mode. We are testing aggressively against 3.10.x and
>haven't tipped it over it but we will turn up the pressure on that and
>see if it gives. I'm pretty confident there is enough community and
>commercial interest in all this to get the bugs beaten out pretty
>thoroughly, provided people report them back.... :-)
>
>We will copy both the bcache and SCST lists when we have something up
>on the FTP site as it would seem to be of interest to both
>communities.
>
>> - Patrick -
>
>Have a good week.
>
>Greg
>
>}-- End of excerpt from Patrick Zwahlen
>
>As always,
>Greg Wettstein, Ph.D. Enjellic Systems Development, LLC.
>4206 N. 19th Ave. Specializing in information infra-structure
>Fargo, ND 58102 development.
>PH: 701-281-1686
>FAX: 701-281-3949 EMAIL: greg@enjellic.com
>------------------------------------------------------------------------------
>"Heaven goes by favor. If it went by merit, you would stay out and your
> dog would go in."
> -- Mark Twain
>--
>To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
 
