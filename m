From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Changes in /sys/bcache in kernel 3.13
Date: Thu, 27 Feb 2014 22:33:49 +0100
Message-ID: <530FAF3D.9090605@rolffokkens.nl>
References: <5303DE88.3090801@rolffokkens.nl> <20140219023213.GF24805@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:32896 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB0Vdv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 27 Feb 2014 16:33:51 -0500
Received: by mail-ee0-f41.google.com with SMTP id b15so1784323eek.0
        for <linux-bcache@vger.kernel.org>; Thu, 27 Feb 2014 13:33:50 -0800 (PST)
In-Reply-To: <20140219023213.GF24805@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-bcache@vger.kernel.org

On 02/19/2014 03:32 AM, Darrick J. Wong wrote:
> Oh, there are RH bugzillas about bcache-status problems? I guess that 
> makes me 'upstream'. :D Well, I guess I'll fix the no-newline-at-end 
> problem too.
Thanks for accepting the upstream responsibility :-)
> <shrug> I simply removed the dirty_data line and prettied up some of 
> the formatting too. I don't have a problem with pulling the dirty data 
> stats off the backing device. Gist updated. --D 
Thanks. I updated the Fedora package.

Rolf
