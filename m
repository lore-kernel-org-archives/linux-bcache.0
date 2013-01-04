From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Bcache upstreaming
Date: Fri, 4 Jan 2013 15:50:40 -0800
Message-ID: <20130104235040.GA26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've (finally!) got a bcache branch hacked up that ought to be suitable
to go upstream, possibly in staging initially.

It's currently closer to the dev branch than the stable branch, plus
some additional minor changes to make it all more self contained. The
code has seen a decent amount of testing and I think it's in good shape,
but I'd like it if it could see a bit more testing before I see about
pushing it upstream.

If anyone wants to try it out, checkout the bcache-for-staging branch.
It's against Linux 3.7.
