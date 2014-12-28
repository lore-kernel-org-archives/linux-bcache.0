From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: 3.18.1 + latest bcache-dev
Date: Sun, 28 Dec 2014 03:35:34 +0100
Message-ID: <20141228023534.GA25860@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:34658 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL1Cff (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 27 Dec 2014 21:35:35 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Now I tried this:
Combine 3.18.1 and rebase all the patches from bcache-dev onto that.
But, in trying that, I get a consistent:

register_bcache() error opening /dev/sdb3: Invalid superblock: member info area missing

Anything I overlooked?   The bcache-tools are straight from git too.
-- 
Stephen.
