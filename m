From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Userspace tools and git repo
Date: Fri, 11 May 2012 13:35:40 -0700
Message-ID: <20120511203540.GC26298@google.com>
References: <1336734111.3576.34.camel@dimension7>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1336734111.3576.34.camel@dimension7>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, May 11, 2012 at 02:01:51PM +0300, Alex Pyrgiotis wrote:
> Hi Kent,
> 
> I 've been following this project for quite a while (congrats for the
> v13 of bcache) and I'm glad that the wiki has been revamped with more
> details and current status. 
> Today, I've been skimming through some of the stuff written there and I
> saw this:
> 
> -------------------------------------
> make-bcache -B -S <set-uuid> backing_device
> The -B option to bcache indicates that a backing device is being created
> The -S option allows the UUID of the cache set to be indicated so that
> the attach process can be bypasses
> <b>backing_device</b> is the path to the block device or partition that
> will be used as a backing device
> ---------------------------------------
> 
> As far as I can tell, the -S option is not implemented in the userspace
> tools.
> 
> Am I missing something? I've downloaded the sources for bcache-tools and
> linux-bache from this git repo: 
> 
> git://evilpiepirate.org/~kent/
>  
> Is this repo up-to-date with your project?
>  
> I'm mainly asking since I can see that the latest changes were done
> about a month ago and the site was updated 2-3 days ago.

No, you've got the latest code. If memory serves (it's hazy) -S was
asked for but I didn't like the idea because of some potential for
breaking things if it was misused.

What I did implement was the ability to format multiple devices at the
same time (both caches and backing devices), and if you do that they'll
all get the same set UUID.

Should probably take that out of the docs for now...

> 
> Thanks,
> Alex
> -- 
> 
> Alex Pyrgiotis, a.k.a 03107422
> Undergrad Student
> 
> School of Electrical & Computer Engineering
> National Technical University of Athens, Greece
> 
> Paper Street Soap Co.
> work: (288) 555-0153
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
