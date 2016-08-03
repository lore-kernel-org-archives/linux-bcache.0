From: Marc MERLIN <marc@merlins.org>
Subject: every boot gives: bcache/alloc.c:78 WARNING
Date: Wed, 3 Aug 2016 16:19:19 -0700
Message-ID: <20160803231919.GA13477@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37995 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbcHCX4x (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 3 Aug 2016 19:56:53 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This happens on all kernels up to 4.7.
Sorry, it happens earlier than ethernet coming up or my storage, so I can't
use netconsole or other text dumps:
https://goo.gl/photos/ubsi6maZXsjkevYY7

Looks like the warning happens on the registration of one of my bcache, but
I can't tell which one or why.

Does the trace give any hints?
(please ignore the load modules errors below, different issue)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
