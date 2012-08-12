From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: grub and bcache
Date: Sun, 12 Aug 2012 11:17:39 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299F5324@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Is the underlying bdev bcache format such that bios/grub won't be able to boot off it?

Or to put it another way, I am wondering whether I can get away with:

/dev/sd[ab]
 md0
  bcache
   lvm
    lv-root
    lv-boot

like I do now without bcache and have grub find the lv-boot, or if I need a separate md device to hold /boot like:

/dev/sd[ab]
  md0
    boot
  md1
    bcache
      lvm
        lv-root
        lv-boot

thanks

James
