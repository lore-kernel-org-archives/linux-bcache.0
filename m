From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache CentOS
Date: Mon, 14 Jan 2013 14:34:49 -0800
Message-ID: <20130114223449.GX26407@google.com>
References: <50F3DEBF.3050307@jouve.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50F3DEBF.3050307-x7zEcnrs8IU@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Sm=C3=A9rald?= PONGE <sponge-x7zEcnrs8IU@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jan 14, 2013 at 11:32:31AM +0100, Sm=C3=A9rald PONGE wrote:
> Hello,
>=20
> I would like to implement a solution with ssd caching Bcache on
> CentOS. Have you ever implemented a solution to this distribution
> (or kernel)? if so, do you have a package?

There's no packages, it's not integrated with any distributions - you'v=
e
got to build your own kernel and tools.  Check the wiki for more info.
