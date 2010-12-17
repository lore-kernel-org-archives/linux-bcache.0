From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Installation of bcache
Date: Thu, 16 Dec 2010 23:48:26 -0800
Message-ID: <4D0B15CA.3060604@gmail.com>
References: <1741654248.28681292571575398.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1741654248.28681292571575398.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LuVar <luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, info <info-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 12/16/2010 11:39 PM, LuVar wrote:
> Hi,
>
> I have started an installation process of bcache. Till now I was (as an beginner foo in this type of tasks) able only to checkout (clone) an git repositories. Second one has tools. I had compiled them without problem.
>
> Iam having some troubles with second one repository. I had downloaded it (~317MB) and it appears to be an linux kernel. Iam running 2.6.34-gentoo-r12 kernel now and I want to keep this kernel and apply to its sources just patch, witch will add bcache functionality. Is it possible?

Just do a git diff v2.6.35...HEAD to get a patch. If that applies 
cleanly against your gentoo kernel you should be good to go.
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
