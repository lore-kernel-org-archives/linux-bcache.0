From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: configuration for kvm vps on disk
Date: Thu, 17 Oct 2013 13:36:10 -0700 (PDT)
Message-ID: <1382042170.70599.YahooMailNeo@web181502.mail.ne1.yahoo.com>
References: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

1. Cut the filesystem out of the equation. Use LVM to create the disks. If you are hoping to do sparse files, use LVM's new thin-provisioning feature. But if you do sparse or thin-provision, performance won't be near as good as "fat" allocation.

2. It's a general rule of thumb that each virtual machine will use ~5 IOPS. Of course if you're running a compile farm, that figure is WAY off.

3. With more than say 3 virtual machines the IO pattern will be completely random and 4KB in size (linux and windows NTFS both use 4K as default). There's absolutely no point in testing anything but 4 and maybe 8K transfer sizes

4. IOPS are inverse linearly related (4k will be 2x as fast as 8k and 4x as fast as 16k). Efficiencies at certain sizes can produce sweet spots that deviate slightly from that rule.

5. What is the underlying spinning RUST and SSD configuration? A 7K RPM drive can barely muster 100 random IOPS. The SSD can obviously do vastly better on reads but writes can vary all over the map depending on how the firmware's smarts and filesystem/block layer coalesce capabilities. Please describe the model of SSD and HDD being used.

6. OS level scheduling (should be noop or deadline) can influence behavior and block level read-ahead should be turned off on the SSD in particular. If you can get the FS to journal in nice, big chunks (eg. erasure block size of commonly 512KB, intel used to use 128KB) that helps too.
