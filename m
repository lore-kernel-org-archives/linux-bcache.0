From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Wed, 11 Sep 2013 13:59:10 +0200
Message-ID: <CE5623FD.1AC8F%rolf@rolffokkens.nl>
References: <522DE939.5090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <522DE939.5090009-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Op 09-09-13 17:28 schreef Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

>> Maybe we can backport the patch to F20 if you need it -- it's not too
>>  invasive change.
>
>(Letting Rolf field this one)

Most important for me is to have bcache identification by blkid in before
F20, so the udev rules file doesn't have to call bcache-probe. Whether or
not it uses checksums is not the most important thing, and that aspect
might even change later.
