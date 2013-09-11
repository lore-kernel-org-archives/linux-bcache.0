From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Wed, 11 Sep 2013 17:51:55 +0200
Message-ID: <20130911155155.GA1053@x2.net.home>
References: <521A55D4.20908@rolffokkens.nl>
 <52282A87.4000801@rolffokkens.nl>
 <52285A03.7080802@gmail.com>
 <FEBD3400-93F1-4286-8BE8-45D5413C2EA2@rolffokkens.nl>
 <52286299.7000708@gmail.com>
 <20130909132653.GA8061@x2.net.home>
 <522DE939.5090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <522DE939.5090009-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Sep 09, 2013 at 05:28:57PM +0200, Gabriel de Perthuis wrote:
> It's correct insofar as current consumers expect it, and it's better
> for error reporting.  The patches took care of my other objections,
> so you can keep the crc check and go with what's on
> https://github.com/g2p/util-linux/commits
> (the csum patches I sent + Rolf's patch + a patch that depends on both).

Merged with some changes

 - not added blkid_probe_is_badcsum() the info about bad csum is
   exported by SBBADCSUM=1 variable, you have to use for example:

       if (blkid_probe_has_value(pr, "SBBADCSUM"))....

 - the usage type is BLKID_USAGE_OTHER rather than "raid" (we have some
   special exceptions and tests for raids that are unnecessary for
   bcache)

I have also added the test images from Rolf to util-linux test suite.

 $ blkid -o udev -p  tests/output/blkid/images-fs/bcache-C.img 
 ID_FS_UUID=7a343627-ac87-4bf0-b76f-46067cbc9b8c
 ID_FS_UUID_ENC=7a343627-ac87-4bf0-b76f-46067cbc9b8c
 ID_FS_TYPE=bcache
 ID_FS_USAGE=other

Thanks!

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
