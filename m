From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] bcache: Take data offset from the bdev superblock.
Date: Mon, 08 Apr 2013 23:44:43 +0200
Message-ID: <51633A4B.1040908@gmail.com>
References: <51629766.6030805@gmail.com> <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com> <20130408204956.GH15749@google.com> <5163356F.50406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5163356F.50406-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

>> As for BCACHE_SB_VERSION_CDEV_WITH_UUID, can you explain why you added
>> that? I suspect it's needed but I can't remember why I didn't add it
>> when I added the new UUID format (or perhaps I just forgot)
>
> I took the name from a comment in the kernel-side bcache.h.
> BCACHE_SB_VERSION_CDEV is the version make-bcache writes, and
> BCACHE_SB_VERSION_CDEV_WITH_UUID is what the kernel updates it too; I
> just changed the version names so that user-side and kernel-side were
> more consistent, internally and with each other.
> The kernel doesn't discriminate these two versions when opening, so it
> should be possible to define only the latter and deprecate the other.

To be more clear, I've replaced the kernel's BCACHE_SB_VERSION by 
BCACHE_SB_VERSION_CDEV_WITH_UUID or BCACHE_SB_MAX_VERSION depending on 
the intent.
