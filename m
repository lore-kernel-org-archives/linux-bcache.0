From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Bcache hangs with Debian 7 (Wheezy), sync does not come back
Date: Mon, 16 Sep 2013 19:03:16 -0700
Message-ID: <20130917020316.GC10907@kmo-pixel>
References: <loom.20130916T150548-751@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20130916T150548-751-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Sep 16, 2013 at 01:07:49PM +0000, Hubert Kempkensteffen wrote:
> Sorry for my English.
> But my Bcache depends on if I have many  Copy files.
> I have tested it on two computers with me and
> i have the problem with kernel 3.10.10, 3.10.11,3.10.12,3.11 and 3.11.1.
> 
> My Bcache-Tools are from git:
> git clone http://evilpiepirate.org/git/bcache-tools.git
> cd bcache-tools
> make
> make install
> 
> My Test:
> ||make-bcache -C /dev/sda4 -B /dev/sdb1
> mkfs.ext4 -L Data /dev/bcache0
> mkdir x
> mount /dev/bcache0 x
> rsync -avr --progress --delete /usr/src ./x/
> sync
> 
> First, rsync copies the files very quickly then to be getting slower,
> that goes to halt!
> I give in another console "sync" here, not the command returns.
> I can take the computer will not reboot with "init 6".

Hey - thanks for narrowing it down to those kernels - that helps a
_lot_.

Can you tell me what else is in your setup? Are you using LVM or md?
