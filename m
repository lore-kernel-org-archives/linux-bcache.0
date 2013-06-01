From: Giovanni Lenzi <giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: bcache on top of drbd or the contrary?
Date: Sat, 1 Jun 2013 17:45:09 +0200
Message-ID: <CAAxY4JkxnNqe_AUjERze30t8GQSD_3ZXXgM84Q+O_bnP6TCs4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,
I'm planning to user bcache for speed, and drbd for HA between two nodes.

I'm facing with this question:
Is it better to have drbd on top of a bcached volume(caching + backing device)
or to use bcache to put a caching device on top of a drbd backing device?

I think that with the second option and writeback enabled, write
requests should be faster than with the first option... Do you agree?

But.. what about the data integrity and consistency of the data on the
drbd slave volume? What if the power goes down on the master node?
Could the drbd volume on the slave node, get corrupted If the caching
device is not detached correctly on the master node?

On the contrary with the first option(drbd on top of bcache), I think
drbd should always preserve data integrity on the two nodes, isn't it?
Can bcache with writeback mode, cause corrupted data on both nodes in
case of a ssd, or power unit failure?

And where is it better to put drbd metadata? External or internal?
External to ssd is the obvious answer, but if I want to store them
internally, what will be the advantages and disadvantages of the two
solutions?

With the first option, storing metadata internally on the bcached
device should not be so slow, given that bcache should always cache
most used data. Isn't it?

What do you think about this subject?

--
Giovanni Lenzi
