From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Patching kernel 3.2
Date: Sun, 12 May 2013 16:46:55 +0000 (UTC)
Message-ID: <kmoh1v$95n$1@ger.gmane.org>
References: <CAOr0bonryaf6PtTC_bX1e4XAuzSQxmu9C24++xkV2CxGyGFsLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

On Sun, 12 May 2013 15:03:35 +0200, Marcel Ammerlaan wrote:
> Although I see the patches being pushed to kernel 3.10, I'd like to
> patch a 3.2 kernel as well. However, it seems I cannot clone the git
> repository (many timeouts) and git cannot restart a partial clone. Is
> it possible to either download the repo as a zipfile or otherwise
> receive the repo or a patch containing the changes for a 3.2 kernel.

Start by cloning Linus's tree, then add and fetch a remote for bcache.
