From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache hang
Date: Mon, 14 Jan 2013 14:34:05 -0800
Message-ID: <20130114223405.GW26407@google.com>
References: <50EDC253.1020609@dsotm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50EDC253.1020609-Ffui8Hzh9qpeoWH0uzbU5w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Anderson <rosander-Ffui8Hzh9qpeoWH0uzbU5w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 09, 2013 at 01:17:39PM -0600, Ross Anderson wrote:
> Current bcache and bcache-testing cause kernel panic on bcache add.
> These are on existing devices, Echo 1 to unregistered, remove
> existing cache device replace with new, make-bcache -C, then echo to
> register. Register hangs and following kernel output and hang
> occurs.

We already talked about this on irc, but for anyone following on the
list - fixed this a couple days ago.
