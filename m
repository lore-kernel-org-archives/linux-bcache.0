From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: configuration for kvm vps on disk
Date: Fri, 18 Oct 2013 13:02:13 +0400
Message-ID: <CACaajQsU_2Dx6oM1h+-SNRvwd3vLsvr3iv0-P8tPnXj4Ut6kpA@mail.gmail.com>
References: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
 <1382042170.70599.YahooMailNeo@web181502.mail.ne1.yahoo.com> <CACaajQtBmi_m4WuNUr9H4qXJg+dCrPtknat6EfX0A_kFAgBC+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtBmi_m4WuNUr9H4qXJg+dCrPtknat6EfX0A_kFAgBC+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

2013/10/18 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
> Thanks for answers. How can i create lvm on top of bcache? When i'm
> try to create volume group i get error:
> pvcreate /dev/bcache0
> Device /dev/bcache0 not found (or ignored by filtering)


Oh i'm already found the answer. types = [ "bcache", 16 ] in lvm.conf
does needed things.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
