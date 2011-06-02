From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot clone git repository
Date: Thu, 02 Jun 2011 10:59:58 -0700
Message-ID: <4DE7CF9E.3010707@gmail.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B04B1CF@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B04B1CF-AQg6BlXVjylhNUoibfp7lHKnxlUjViKd@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rohan Puri <prohan-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anand Mitra <amitra-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

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
