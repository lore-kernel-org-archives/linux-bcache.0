From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: Very poor performances with the bcache-for-upstream branch
Date: Wed, 1 May 2013 08:36:34 -0700 (PDT)
Message-ID: <1367422594.24900.YahooMailClassic@web181502.mail.ne1.yahoo.com>
References: <CA+XuAnK4nNOG_tSuuteDThbj5L+5xmDsxQLfrHj314z1fr+bUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+XuAnK4nNOG_tSuuteDThbj5L+5xmDsxQLfrHj314z1fr+bUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> I am obtaining the following figures, on a cached fs:
> seq-read: iops=12188
> rand-read: iops=7392
> seq-write: iops=430
> rand-write: iops=454

Just what numbers were you expecting to see? A decent 7200RPM drive can only muster 70 IOPs on a good day. The lies the SSD vendors print in their literature and on the side of the box are almost always done with a blocksize of 512 bytes. So if you're doing 4K operations, divide by 8 at least.
