From: Rohan Puri <prohan-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: Cannot clone git repository
Date: Fri, 3 Jun 2011 14:35:57 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B04B1D4@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B04B1CF@MYMBX.MY.STEC-INC.AD>,<4DE7CF9E.3010707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE7CF9E.3010707-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anand Mitra <amitra-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I tried it yesterday. Came to know the problem. The problem is not in the repository. The problem was with the RAM. I tried to clone the repository with 8GB RAM and it got cloned. But the error is returned when the RAM is less.This  happens as the repository is very big.
________________________________________
From: Kent Overstreet [kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Thursday, June 02, 2011 11:29 PM
To: Rohan Puri
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Anand Mitra
Subject: Re: Cannot clone git repository

On 06/02/11 00:40, Rohan Puri wrote:
> Hello,
>
> I was trying to clone the git repository at git://evilpiepirate.org/~kent/linux-bcache.git. But it fails with the following error : -
>
> Initialized empty Git repository in /home/tushar/bcache/linux-bcache/.git/
> remote: Counting objects: 1886033, done.
> remote: aborting due to possible repository corruption on the remote side.
> fatal: early EOF
> fatal: index-pack failed

When was this? It was broken over the weekend, but I tried cloning just
now and it worked fine.
> Also the patch url http://evilpiepirate.org/~kent/bcache.patch is not working.
That was old, I need to delete the link.
> Please, let me know from where I can get the code.
>
> Regards,
> Rohan Puri.
>
> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
>
> This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
