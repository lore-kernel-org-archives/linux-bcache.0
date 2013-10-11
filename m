From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] Fix for bcache regression
Date: Thu, 10 Oct 2013 17:31:14 -0700
Message-ID: <1381451475-24551-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Linus, please apply - the last fix in the bugfix series I sent you had an
embarassing screwup...

For 3.13, shall I start sending you pull requests directly?
