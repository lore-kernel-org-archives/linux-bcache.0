From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache hangs with Debian 7 (Wheezy), sync does not come back
Date: Tue, 17 Sep 2013 23:15:22 +0200
Message-ID: <CAPBO7TaVP0n+7vN1FMDBVqjEFefutqxAfXqB2ER6v2Ys_6U5cw@mail.gmail.com>
References: <loom.20130916T150548-751@post.gmane.org>
	<20130917020316.GC10907@kmo-pixel>
	<loom.20130917T122135-908@post.gmane.org>
	<20130917203741.GA32037@kmo-pixel>
	<loom.20130917T224603-574@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130917T224603-574-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 17 September 2013 22:54, Hubert Kempkensteffen
<hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org> wrote:
> Kent Overstreet <kmo@...> writes:
>
>>
>> Are you saying you've tested it both with and without software raid?
>> Which kind of raid (raid 1, 10, 5, etc.)?
>
> Sorry, my english.
> I have no raid and no LVM. There are both ordinary machines.
> And I just want to speed up the data disk!


Hello,

I am using bcache with a "standard" system (ext4). Perhaps what
happens is about that "bug" where a lot of writes were delayed. It
makes sense with the delay with rsync...

What I did was download last git of linux-bcache (kernel) and replace
the version of last downloaded kernel to build. Then install the deb
package.


Salutacions,
Josep





>
>>
>> I think this bug requires something else in the stack to trigger, I'm
>> trying to figure out what the common factor is.
>>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
--
Salutacions...Josep
--
