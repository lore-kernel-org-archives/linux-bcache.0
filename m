From: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Subject: Userspace tools and git repo
Date: Fri, 11 May 2012 14:01:51 +0300
Message-ID: <1336734111.3576.34.camel@dimension7>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

I 've been following this project for quite a while (congrats for the
v13 of bcache) and I'm glad that the wiki has been revamped with more
details and current status. 
Today, I've been skimming through some of the stuff written there and I
saw this:

-------------------------------------
make-bcache -B -S <set-uuid> backing_device
The -B option to bcache indicates that a backing device is being created
The -S option allows the UUID of the cache set to be indicated so that
the attach process can be bypasses
<b>backing_device</b> is the path to the block device or partition that
will be used as a backing device
---------------------------------------

As far as I can tell, the -S option is not implemented in the userspace
tools.

Am I missing something? I've downloaded the sources for bcache-tools and
linux-bache from this git repo: 

git://evilpiepirate.org/~kent/
 
Is this repo up-to-date with your project?
 
I'm mainly asking since I can see that the latest changes were done
about a month ago and the site was updated 2-3 days ago.

Thanks,
Alex
-- 

Alex Pyrgiotis, a.k.a 03107422
Undergrad Student

School of Electrical & Computer Engineering
National Technical University of Athens, Greece

Paper Street Soap Co.
work: (288) 555-0153
