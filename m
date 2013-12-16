From: Pavol Cupka <pavol.cupka@gmail.com>
Subject: 2 drives btrfs raid1 with one ssd
Date: Mon, 16 Dec 2013 02:01:57 +0100
Message-ID: <1387155717.6876.29.camel@N900-P>
Reply-To: Pavol Cupka <pavol.cupka@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44643 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3LPBBv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Dec 2013 20:01:51 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so1634652eek.13
        for <linux-bcache@vger.kernel.org>; Sun, 15 Dec 2013 17:01:50 -0800 (PST)
Received: from [192.168.178.28] (p549A46D8.dip0.t-ipconnect.de. [84.154.70.216])
        by mx.google.com with ESMTPSA id a45sm36033400eem.6.2013.12.15.17.01.49
        for <linux-bcache@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sun, 15 Dec 2013 17:01:50 -0800 (PST)
Content-ID: <1387155717.6876.28.camel@N900-P>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

I would like to use a bcache for btrfs filesystem residing on two identical disk as raid1 using btrfs' raid (without soft/hard raid).

Is it possible? I am migrating from a different mirror setup and have to create btrfs in "degraded" mode and then add the second drive/bcache.

I would like to use the same ssd/ssd partition for caching both drives/mirror. Is this doable? 

Did someone encounter problems with bcache build as module? I can not stop the current caching device.

Thank you 
pavol
