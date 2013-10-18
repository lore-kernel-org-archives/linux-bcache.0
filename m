From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: configuration for kvm vps on disk
Date: Fri, 18 Oct 2013 13:00:56 +0400
Message-ID: <CACaajQtBmi_m4WuNUr9H4qXJg+dCrPtknat6EfX0A_kFAgBC+Q@mail.gmail.com>
References: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
 <1382042170.70599.YahooMailNeo@web181502.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382042170.70599.YahooMailNeo-XYahOdtEMNm2Y7dhQGSVAJOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

2013/10/18 matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>:
> 1. Cut the filesystem out of the equation. Use LVM to create the disks. If you are hoping to do sparse files, use LVM's new thin-provisioning feature. But if you do sparse or thin-provision, performance won't be near as good as "fat" allocation.


Thanks for answers. How can i create lvm on top of bcache? When i'm
try to create volume group i get error:
pvcreate /dev/bcache0
Device /dev/bcache0 not found (or ignored by filtering)

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
