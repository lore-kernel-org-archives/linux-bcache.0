From: Jens Rosenboom <j.rosenboom@x-ion.de>
Subject: Bug in bch_hprint
Date: Fri, 20 Nov 2015 16:43:37 +0100
Message-ID: <CADr68WaASnBHqJ=xL05Stbnzg4=YV4Leoa=_4pRbyrnvH_ix1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36148 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760536AbbKTPnj (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 20 Nov 2015 10:43:39 -0500
Received: by lfs39 with SMTP id 39so71571635lfs.3
        for <linux-bcache@vger.kernel.org>; Fri, 20 Nov 2015 07:43:38 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

It will e.g. print 1.10k for a value between 2024 and 2047, which when
parsed back would appear to be a much lower value.

Also, why does the output for values like dirty_data have to be
human-readable at all? It is hiding accuracy and makes feeding the
data into some monitoring system unneccesarily complicated.
