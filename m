From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Resizing bcache backing store
Date: Wed, 11 Apr 2012 18:47:03 -0400
Message-ID: <CAB7K1hH_o7koST7RYTbw9ya0GMEvmpb=TYAt1MqEVDhtBdRd1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

In the case where the bcache backing store is resizeable (eg. a
logical volume), is it possible to resize the backing store without
breaking bcache? Let's say, for example, that I would
unmount/unregister /dev/bcacheX, resize the backing store,
reregister/remount the cache.

I imagine a better approach would be to layer LVM on the cache device
itself. However, in this particular case, I set up the bcache before I
had learned how to get LVM to use a bcache device as a PV.

-davidc
