From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: bcache read-only mode?
Date: Sat, 24 Jan 2015 23:55:41 +0100
Message-ID: <CAA-O0Xj7G=G_56YoReN1ShiTWwMZeapz_WjZQPySqnBobBTF3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:61116 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbAXWzm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 24 Jan 2015 17:55:42 -0500
Received: by mail-yh0-f43.google.com with SMTP id 29so1175944yhl.2
        for <linux-bcache@vger.kernel.org>; Sat, 24 Jan 2015 14:55:41 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Good evening!

I've been using bcache happily for some months now, but unfortunately,
something bad happened to the backing device in my bcache setup. To
confirm that I've corrected the problem, I would like to run bcache in
read-only mode. Is this possible?

My bcache was in writeback mode, so part of the filesystem information
is in the cache drive. Thus, I can't filesystem check the backing disk
without involving the cache. I want to prevent bcache from making any
changes to the cache and backing drives. I just want to be able to
include the writeback information so that I can see if the data is
consistent.

Thanks!
