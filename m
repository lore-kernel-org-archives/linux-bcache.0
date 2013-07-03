From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 3 Jul 2013 20:23:35 +0400
Message-ID: <CACaajQvx20qaFXEM-JBk=9UP3ApJAiC6-XxFcsrseKQJ9vXuGw@mail.gmail.com>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com>
 <1372868105.17096.YahooMailNeo@web181504.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372868105.17096.YahooMailNeo-XYahOdtEMNkbWpotXP+qY5OW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hmm. Sorry i'm not fully understand.

I think :

create /dev/md0 with /dev/sda (sata) level=1 raid-devices=1
format /dev/md0 with bcache
format /dev/sdb (ssd) with brache

create bcache0 with /dev/md0 and /dev/sdb

why this is not possible?


2013/7/3 matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>:
> short answer you can't. you can unbind the SSD from bcache and otherwise remove the bcache config but you can't turn a live disk into a MD raid member without destroying all data on it. Introduce the 2nd big hard disk and create a raid1 on it with an absent mirror pair. DD or RSYNC the data from your first disk to the new MD device. reconfigure first disk to be MD member and let MD re-sync the (same) data back once more.
>
> add SSD and MD device to bcache config and it's now accelerated.



--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
