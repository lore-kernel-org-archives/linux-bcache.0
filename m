From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Can a bcachefs filesystem be exported via NFS?
Date: Tue, 7 Jun 2016 19:45:46 -0800
Message-ID: <20160608034546.GA1538@kmo-pixel>
References: <5755E9CA.4060609@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32913 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbcFHDpu (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Jun 2016 23:45:50 -0400
Received: by mail-pa0-f41.google.com with SMTP id ec8so46327541pac.0
        for <linux-bcache@vger.kernel.org>; Tue, 07 Jun 2016 20:45:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5755E9CA.4060609@gemtalksystems.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Martin McClure <martin.mcclure@gemtalksystems.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Jun 06, 2016 at 02:23:22PM -0700, Martin McClure wrote:
> Can a bcachefs filesystem be exported via NFS?
> 
> I have a bcachefs filesystem mounted on /meteor4. When I try to export
> it, I get:
> 
> ---
> root@meteor:~# service nfs-kernel-server restart
>  * Stopping NFS kernel daemon   [ OK ]
>  * Unexporting directories for NFS kernel daemon...      [ OK ]
>  * Exporting directories for NFS kernel daemon...
> exportfs: /meteor4 does not support NFS export
> ---
> 
> and the system log says:
> 
> Jun  6 14:11:28 meteor rpc.mountd[31541]: /meteor3 and /meteor4 have
> same filehandle for *, using first
> 
> Not sure what this is about. /meteor3 is a vanilla ext4 partition.
> 
> If I try to access /meteor4 from another machine via NFS, Meteor's log
> shows this:
> 
> Jun  6 14:15:10 meteor rpc.mountd[31541]: Cannot export /meteor4,
> possibly unsupported filesystem or fsid= required
> 
> So I'm guessing it's not yet supported, but wanted to check in case I'm
> doing something wrong.

Thanks for noticing - yeah, not supported yet. And it's going to need an on disk
format change for i_generation, erg. Excuse me while I go punch myself...
