From: Michael Lyle <mlyle@lyle.org>
Subject: (unknown)
Date: Mon,  9 Oct 2017 00:37:28 -0700
Message-ID: <20171009073730.8939-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
Subject: 
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: colyli@suse.de
List-Id: linux-bcache@vger.kernel.org

[PATCH v2 1/2] bcache: writeback rate shouldn't artifically clamp
[PATCH v2 2/2] bcache: rearrange writeback main thread ratelimit

This is a reroll of the previous "don't clamp" patch.  It corrects
type issues where negative numbers were handled badly (mostly for
display in writeback_rate_debug).

Additionally, a new, related patch-- during scanning for dirty
blocks, don't reset the ratelimiting counter.  This can prevent
undershoots/overshoots of the target rate relating to scanning.

Mike
