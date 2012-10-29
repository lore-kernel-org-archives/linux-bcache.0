From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache Journal
Date: Mon, 29 Oct 2012 13:43:30 -0700
Message-ID: <20121029204330.GA14917@google.com>
References: <508D5B43.4040504@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <508D5B43.4040504-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Oct 28, 2012 at 06:20:19PM +0200, Alex Pyrgiotis wrote:
> Hi,
> 
> In the wiki, it is mentioned that bcache can run either with or
> without a journal.
> What I'd like to ask is which is the default bcache configuration
> (journal on|off?) and is there an option in the make-bcache tool to
> change this configuration?

That's out of dat... What page did you find that on? Running without a
journal hasn't been an option in ages...

(You wouldn't want to run without the journal, it's there to improve
performance)
