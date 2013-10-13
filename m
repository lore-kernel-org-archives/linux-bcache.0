From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Sun, 13 Oct 2013 22:54:21 +0200
Message-ID: <525B087D.1010706@rolffokkens.nl>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel> <loom.20130917T122135-908@post.gmane.org> <20130917203741.GA32037@kmo-pixel> <loom.20130917T224603-574@post.gmane.org> <20130917214043.GF32037@kmo-pixel> <loom.20130918T134845-142@post.gmane.org> <20130918202809.GB19161@kmo-pixel> <loom.20130918T223347-893@post.gmane.org> <20130918204303.GC19161@kmo-pixel> <loom.20130919T202224-113@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130919T202224-113-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pavel.nedr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

During the Fedora SSD Cache test day the following was reported:

https://bugzilla.redhat.com/show_bug.cgi?id=1018615

Happened with kernel-3.11.4.

On 09/19/2013 08:26 PM, Hubert Kempkensteffen wrote:
> Kent Overstreet <kmo@...> writes:
>
>
>> I just rebased bcache-3.10-stable and added the fix you tested to it.
>>
>> Also, HEAD in the bcache repository now points to bcache-3.10-stable and
>> not bcache-for-3.10.
>>
>> Can you run echo t > /proc/sysrq-trigger when things get stuck, and give
>> me the full dmesg output?
>>
> Hi just before closing I did still following.
> root@server:/# du -sh root
> 332K	root
> cp -av /root /tmp/bcache/
> sync
>
> Until here everything is OK
> Now I enter the following
> root@server:/# du -sh etc
> 12M	etc
>
> cp -av /etc /tmp/bcache/
> sync
> And the sync command will not come back!
> The dmesg I send by mail
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
