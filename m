From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: configuration for kvm vps on disk
Date: Sat, 19 Oct 2013 14:29:07 +0400
Message-ID: <CACaajQuy7+UKkFksaR8EJGEMRqu7d3XOu79xXJSj5RyxSBQS0w@mail.gmail.com>
References: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
 <1382042170.70599.YahooMailNeo@web181502.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382042170.70599.YahooMailNeo-XYahOdtEMNm2Y7dhQGSVAJOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

2013/10/18 matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>:
> 5. What is the underlying spinning RUST and SSD configuration? A 7K RPM drive can barely muster 100 random IOPS. The SSD can obviously do vastly better on reads but writes can vary all over the map depending on how the firmware's smarts and filesystem/block layer coalesce capabilities. Please describe the model of SSD and HDD being used.
>
> 6. OS level scheduling (should be noop or deadline) can influence behavior and block level read-ahead should be turned off on the SSD in particular. If you can get the FS to journal in nice, big chunks (eg. erasure block size of commonly 512KB, intel used to use 128KB) that helps too.


Thanks again. I'm switch to lvm logical volumes for vps. Scheduler
deadline.What i can tune now to not crack ssd =)?
As i known i can switch sequential_cutoff to default?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
