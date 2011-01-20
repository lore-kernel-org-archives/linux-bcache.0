From: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 22:34:05 -0500
Message-ID: <4D37AD2D.6070108@gmail.com>
References: <4D377D66.5020609@gmail.com>	<AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>	<4D37890B.3060808@gmail.com>	<AANLkTinUD1_z3iZ3VgJFh=JkF+6EWDq62==Z9EhBpwBP@mail.gmail.com>	<4D378C5E.7050309@gmail.com> <AANLkTin+xKeYbxSU6u=h8bfujSpm3fxqurC0nR4+89wX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin+xKeYbxSU6u=h8bfujSpm3fxqurC0nR4+89wX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sounds great, when will it be ready? ;-)

On 01/19/2011 08:27 PM, Kent Overstreet wrote:
> Well, ram is more expensive per gigabyte than SSDs, particularly if
> you've got something with a battery attached - the idea would be to
> use your SSD for buffering 80 gb or so of writes, but then buffer all
> of bcache's metadata writes in battery backed-up ram, significantly
> decreasing the number of write IOPS to the SSD, and making it so
> pretty much all the writes to the SSD are big contiguous writes.
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
