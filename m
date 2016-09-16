From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Thu, 15 Sep 2016 19:33:08 -0800
Message-ID: <20160916033308.voyodnallkvbqkgj@kmo-pixel>
References: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36384 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbcIPDdM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2016 23:33:12 -0400
Received: by mail-pa0-f65.google.com with SMTP id p2so2878876pap.3
        for <linux-bcache@vger.kernel.org>; Thu, 15 Sep 2016 20:33:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Sep 15, 2016 at 11:36:14AM +0200, Marcin Mirosław wrote:
> Hi!
> I was playing with fs without tiering. I was using it for tmp dir for
> compilation. Next I changed in sys:
> echo crc64 > options/data_checksum
> echo crc64 > options/metadata_checksum
> echo crc64 > options/str_hash
> 
> After a couple of minutes I got:
> [ 8372.574346] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8372.680196] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8464.361860] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8466.146966] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8466.995095] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8469.199749] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8469.441408] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8469.722676] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8469.827055] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8470.038869] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8470.236663] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8470.427094] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8472.030519] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8473.098820] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8916.491297] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8916.715057] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8916.715111] bcache (dm-10): too many IO errors on dm-10, setting
> filesystem RO
> [ 8916.733056] bcache (dm-10): IO error on dm-10 for checksum error
> [ 8916.733125] bcache (dm-10): dm-10 read only
> [ 8916.733161] bcache (dm-10): too many IO errors on dm-10, setting
> device RO
> [ 8916.988286] bcache (dm-10): IO error: read only
> [ 8916.988545] bcache (dm-10): IO error: read only

Ok, it turns out the crc64 for data checksums code was just fubar. Fix is up
(the fix does change how crc64 is computed for bios though, so it'll be
incompatible with your existing filesystem).

Also pushed a patch that adds some more error messages to fs-gc, we should
figure out why it wouldn't mount. I can't think of any reason why data checksum
errors would've caused that.
