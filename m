From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Can a bcachefs filesystem be exported via NFS?
Date: Thu, 16 Jun 2016 11:46:20 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1606161144310.22616@mail.ewheeler.net>
References: <5755E9CA.4060609@gemtalksystems.com> <20160608034546.GA1538@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:38457 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753919AbcFPSqV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 16 Jun 2016 14:46:21 -0400
In-Reply-To: <20160608034546.GA1538@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Martin McClure <martin.mcclure@gemtalksystems.com>, linux-bcache@vger.kernel.org

On Tue, 7 Jun 2016, Kent Overstreet wrote:
> On Mon, Jun 06, 2016 at 02:23:22PM -0700, Martin McClure wrote:
> > Can a bcachefs filesystem be exported via NFS?
> > doing something wrong.
> 
> Thanks for noticing - yeah, not supported yet. And it's going to need an on disk
> format change for i_generation, erg. 

If the on-disk format is going to change, is it possible to make bcacheN 
inodes compatible with files?  It would be great to export files 
arbitrarily as block devices.


--
Eric Wheeler



> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
