From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: shutdown and bcache
Date: Tue, 30 Jul 2013 23:15:53 -0700
Message-ID: <20130731061553.GK6653@moria.home.lan>
References: <CAPBO7TavO4ptpXk41jyHLsezS4fhQ1+y5Zk7yq4K183jvOeD-g@mail.gmail.com>
 <CAPBO7Ta-EayiYtTjJnFRrCF1Jg-x_bR=YGGwM+yGfAFmEcGjVQ@mail.gmail.com>
 <CAPBO7TZpOJUO0cNLu6w+QF-aRBm_REWYkN=7MwdL5ja7AxTfRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPBO7TZpOJUO0cNLu6w+QF-aRBm_REWYkN=7MwdL5ja7AxTfRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jul 30, 2013 at 11:43:27AM +0200, Josep Lladonosa wrote:
> Hello,
> 
> Have just checked kernel 3.11.0-rc3 #1 SMP Tue Jul 30 11:06:14 CEST
> 2013 x86_64 GNU/Linux
> 
> and system has shut down!

Awesome! I wonder what actually fixed it - I don't think a bcache bug
could've been causing those errors (and I asked some other kernel devs,
they thought the same thing), and 3.10.4 should have all the same
fixes... but who really knows. Glad it's working now.
