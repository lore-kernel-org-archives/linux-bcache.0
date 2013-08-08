From: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Subject: Converting existing partition to bcache backing device without loss
 of data
Date: Thu, 8 Aug 2013 09:27:33 -0700
Message-ID: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Howdy,

I am in the process of testing bcache on our HPC cluster to act as
cache for our gluster storage (~750TB).

I notice that during the setup process on our test cluster, our
backing device (where all our data is stored) will need to be
formatted in order to support bcache.

Does a way exist so we do not have to format our backing device? Or is
working being done to support this?

Thanks,
-Adam

--
Adam Brenner
Computer Science, Undergraduate Student
Donald Bren School of Information and Computer Sciences

Research Computing Support
Office of Information Technology
http://www.oit.uci.edu/rcs/

University of California, Irvine
www.ics.uci.edu/~aebrenne/
aebrenne-sXc7qaQca9o@public.gmane.org
