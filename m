From: john.sheu@gmail.com
Subject: bcache: remove nested function usage
Date: Mon, 17 Mar 2014 22:50:58 -0700
Message-ID: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:65529 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaCRFvB (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Mar 2014 01:51:01 -0400
Received: by mail-ie0-f202.google.com with SMTP id lx4so1321840iec.1
        for <linux-bcache@vger.kernel.org>; Mon, 17 Mar 2014 22:51:01 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, kmo@daterainc.com

This patch fixes up some crashes seen while running bcache with the ftrace
function graph tracer.
