From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Pull request] A command to print the superblock
Date: Fri, 5 Apr 2013 15:16:16 -0700
Message-ID: <CAH+dOxJFnodvL7u0h__8kShYZytXuwvzumSq89XhW79198ETYA@mail.gmail.com>
References: <khfe6b$rpk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <khfe6b$rpk$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hey, sorry for the delay - I'm finally catching up on bcache stuff. I
just merged your patches, thanks!

On Sat, Mar 9, 2013 at 5:41 AM, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
> I've written a command to print a bcache superblock; mostly I wanted
> a reliable way to find the data offset. The output is based on
> btrfs-show-super (easy to read and parse). Please pull from
>
>     https://github.com/g2p/bcache-tools
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
