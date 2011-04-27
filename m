From: Andrew Burgess <aab-UIo0uGTcgxdBDgjK7y7TUQ@public.gmane.org>
Subject: Re: getting a patch for 2.6.38.4
Date: Wed, 27 Apr 2011 13:00:25 -0700
Message-ID: <1303934425.8988.0@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

well, less of a git virgin now...

git clone git://evilpiepirate.org/~kent/linux-bcache.git
git clone  
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git  
linux-2.6
cd linux-2.6
git checkout -b 2.6.35 v2.6.35
cd ..
git diff linux-2.6 linux-bcache > patch


clone takes a very long time (both clone commands result in full kernel  
source trees)
i had to hand edit the patch to remove all the diffs for .git related  
stuff

i am certain there is a better way but this did result in a patch :-)

according to bcache's Makefile it's only been ported to 2.6.35

hth
Andrew
