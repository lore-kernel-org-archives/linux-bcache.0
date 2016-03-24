From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: Bug - bcache: "unable to handle kernel NULL pointer dereference" when
 trying to add a md caching device
Date: Thu, 24 Mar 2016 16:19:39 +0100
Message-ID: <56F4058B.1030309@roesner-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from euler.f0o.de ([85.88.6.196]:54006 "EHLO mail.f0o.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbcCXPWm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 24 Mar 2016 11:22:42 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hell,

I experienced a bug after upgrading to a recent kernel (4.5.0).

# echo /dev/md2 > /sys/fs/bcache/register

gives me a stack trace.

I created a bug in the kernel bugtracker but I'm not sure if it has been
noticed by the bcache developers:

<https://bugzilla.kernel.org/show_bug.cgi?id=114871>

Could somebody have a look?

Cheers
Sebastian
