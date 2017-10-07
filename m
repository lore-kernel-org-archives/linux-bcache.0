From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: rewrite multiple partitions support
Date: Sat, 7 Oct 2017 14:42:05 -0700
Message-ID: <CAJ+L6qc6xReHHwHnZx6oRL_H3u2JCEY+zaBhJ88-tzUrHhZUMg@mail.gmail.com>
References: <20170909184147.10458-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170909184147.10458-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Indeed fixes a bug where minors and indices are interchanged on
cleanup-- good catch.  Factoring out the index conversion is nice.

Hopefully no one is adversely affected by the stride change (16->128)
and different naming, but they should be using udev + labels/uuids
anyways.

Reviewed-by: Michael Lyle <mlyle@lyle.org>
