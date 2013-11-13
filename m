From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 12:12:40 -0800
Message-ID: <0aa901cee0ac$b6748790$235d96b0$@acm.org>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com> <op.w6hq4v0of3gqgg@desktop.patton.net> <CAHYUNGZAp8_LNqTJ6ufnVjLEnK-8cn0SKYgtH+YpVw_ki2+ONQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHYUNGZAp8_LNqTJ6ufnVjLEnK-8cn0SKYgtH+YpVw_ki2+ONQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Adam Berkan' <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Adam Berkan
> Sent: Wednesday, November 13, 2013 10:24 AM
>
> bcache has a pretty flash friendly write pattern, so you probably
> don't need a huge lot of empty space.

Depending on the performance impact on your particular SSD, you could also
try enabling TRIM in bcache which should reduce the need for over
provisioning by making sure the SSD knows which blocks it can erase in the
background. It would be nice if bcache supported a manual TRIM like fstrim
works for filesystems so if you have an SSD whose performance precludes real
time TRIM you could schedule a daily or weekly batch TRIM to tune things up.
