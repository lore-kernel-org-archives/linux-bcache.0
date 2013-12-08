From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Easy CentOS 5 install
Date: Sun, 08 Dec 2013 19:48:51 +0100
Message-ID: <52A4BF13.30703@rolffokkens.nl>
References: <a4112a312285944fa9fac6446f79ce3b@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58785 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab3LHSsy (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 8 Dec 2013 13:48:54 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so1173833eak.30
        for <linux-bcache@vger.kernel.org>; Sun, 08 Dec 2013 10:48:53 -0800 (PST)
In-Reply-To: <a4112a312285944fa9fac6446f79ce3b@abpni.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-bcache@vger.kernel.org

On 11/30/2013 02:45 AM, Jonathan Tripathy wrote:
> What is the easiest way to install bcache on a currently running 
> production CentOS 5.x machine? Is there an official and/or EPEL 
> package available? We would also need Xen Dom0 support...
I built the bcache-tools package for Fedora 20, which has some specific 
requirements (that are met by Fedora 20):

- util-linux >= 2.24, because libblkid (>= 2.24) is able to identify 
bcache devices which greatly improves dracut functionality
- dracut < 34, because bcache-tools includes the dracut module for 
bcache which was part of dracut from dracut-31 to dracut-33

Having your root FS on bcache requires the proper util-linux and dracut 
versions, but when not having your root FS on a bcache(d) device it 
should be possible to use bcache on e.g. CentOS. This requires a 
modification of the current src.rpm though, which I won't mind doing if 
you intend to use it

Please let me know.

Rolf
