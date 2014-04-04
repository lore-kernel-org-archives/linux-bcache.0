From: Andrew Martin <amartin@xes-inc.com>
Subject: Re: Performance testing with bcache
Date: Fri, 4 Apr 2014 12:06:50 -0500 (CDT)
Message-ID: <459660524.313506.1396631210130.JavaMail.zimbra@xes-inc.com>
References: <155722734.53464.1394740311695.JavaMail.zimbra@xes-inc.com> <2000529324.55683.1394741536677.JavaMail.zimbra@xes-inc.com> <20140313205259.GA28293@sucs.org> <216592761.38181.1394822496274.JavaMail.zimbra@xes-inc.com> <1899882151.50322.1394831787760.JavaMail.zimbra@xes-inc.com> <20140315175212.GA20197@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:57969 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbaDDRGy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 4 Apr 2014 13:06:54 -0400
In-Reply-To: <20140315175212.GA20197@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

Sitsofe,

----- Original Message -----
> From: "Sitsofe Wheeler" <sitsofe@yahoo.com>
> To: "Andrew Martin" <amartin@xes-inc.com>
> Cc: linux-bcache@vger.kernel.org
> Sent: Saturday, March 15, 2014 12:52:15 PM
> Subject: Re: Performance testing with bcache
> 
> On Fri, Mar 14, 2014 at 04:16:27PM -0500, Andrew Martin wrote:
> > 
> > Do you have an example fio job file that has worked well for testing
> > bcache?
> 
> Try these as a starting point:
> benchmark-seq.fio:
> ; Script to gather general sequential write performance statistics
> ; Basic usage:
> ; BS="4k" DEV="sdf" RT=90 SEED=21 TYPE="ssd" fio benchmark-seq.fio

I ran the example job files with the commands you posted, but the output
bandwidth seems extremely low:
http://pastebin.com/13RBYwwp
http://pastebin.com/bsp9KbDq

fio job file:
http://pastebin.com/zfVJdjMQ

Am I doing something wrong when running fio?

Thanks,

Andrew
