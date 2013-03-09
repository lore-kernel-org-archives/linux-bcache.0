From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Pull request] A command to print the superblock
Date: Sat, 9 Mar 2013 14:05:52 +0000 (UTC)
Message-ID: <khffjv$rpk$2@ger.gmane.org>
References: <khfe6b$rpk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Hello,
> I've written a command to print a bcache superblock; mostly I wanted a
> reliable way to find the data offset. The output is based on
> btrfs-show-super (easy to read and parse). Please pull from
> 
>     https://github.com/g2p/bcache-tools

By the way, it would be pretty nice to enable the --data-offset option at 
creation time. I've put that on another feature branch, but I'm not sure 
it is supported kernel-side.
