From: Andrew Martin <amartin@xes-inc.com>
Subject: Re: Performance testing with bcache
Date: Fri, 14 Mar 2014 16:16:27 -0500 (CDT)
Message-ID: <1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com> <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com> <20140313205259.GA28293@sucs.org> <216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:53642 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbaCNVQ3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 14 Mar 2014 17:16:29 -0400
In-Reply-To: <216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

----- Original Message -----
> From: "Andrew Martin" <amartin@xes-inc.com>
> ----- Original Message -----
> > From: "Sitsofe Wheeler" <sitsofe@yahoo.com>
> ...
> > > However, if I cat /sys/block/bcache0/bcache/cache/cache_available_percent
> > > before and after performing the read, the value is always 100. Would
> > > using
> > > iflag=direct be better than iflag=nocache in this case? Is there a better
> > > way to force data into the cache for this type of performance
> > > benchmarking?
> > 
> > The amount free isn't as important as the cache hits/misses ratio.
> > Additionally I would recommend reading the TROUBLESHOOTING PERFORMANCE
> > section mentioned above and posting your findings here because the
> > bcache defaults often defeat first attempt synthetic benchmarking...
> 
> Thanks, I will try fio with these recommended steps!
> 
Sitsofe,

Do you have an example fio job file that has worked well for testing bcache?

Thanks,

Andrew
