From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Not a bcache superblock
Date: Mon, 25 Jul 2011 09:16:35 -0700
Message-ID: <4E2D96E3.8050709@gmail.com>
References: <loom.20110725T180931-69@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110725T180931-69-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: i- <itooo-xVucS5mfmt0AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 07/25/11 09:14, i- wrote:
> Hi all,
>
> When trying to register a device with bcache, I have the following error message
> : "bcache: error opening /dev/sdb1: Not a bcache superblock"
>
> Digging around showed me the magic number could not be matched, digging a bit
> more I found out that the cache_sb structures are different in the tools code
> and in the kernel code.
>
> There are 3 fields before the magic in the tools' bcache.h but the magic is the
> first field in bcache.c in the linux module code...
>
> Am I out of sync between repos ? (I cloned them both today)

Yeah, I just uploaded a new version of the tools and the matching 
version of bcache isn't up yet.

Do a "git checkout HEAD^" in the bcache-tools repo to get a version 
that'll work.

>
> Regards
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
