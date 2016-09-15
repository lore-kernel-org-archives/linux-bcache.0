From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error (due
 to change of str_hash?)
Date: Thu, 15 Sep 2016 11:36:14 +0200
Message-ID: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:58660 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754739AbcIOJgi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2016 05:36:38 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I was playing with fs without tiering. I was using it for tmp dir for
compilation. Next I changed in sys:
echo crc64 > options/data_checksum
echo crc64 > options/metadata_checksum
echo crc64 > options/str_hash

After a couple of minutes I got:
[ 8372.574346] bcache (dm-10): IO error on dm-10 for checksum error
[ 8372.680196] bcache (dm-10): IO error on dm-10 for checksum error
[ 8464.361860] bcache (dm-10): IO error on dm-10 for checksum error
[ 8466.146966] bcache (dm-10): IO error on dm-10 for checksum error
[ 8466.995095] bcache (dm-10): IO error on dm-10 for checksum error
[ 8469.199749] bcache (dm-10): IO error on dm-10 for checksum error
[ 8469.441408] bcache (dm-10): IO error on dm-10 for checksum error
[ 8469.722676] bcache (dm-10): IO error on dm-10 for checksum error
[ 8469.827055] bcache (dm-10): IO error on dm-10 for checksum error
[ 8470.038869] bcache (dm-10): IO error on dm-10 for checksum error
[ 8470.236663] bcache (dm-10): IO error on dm-10 for checksum error
[ 8470.427094] bcache (dm-10): IO error on dm-10 for checksum error
[ 8472.030519] bcache (dm-10): IO error on dm-10 for checksum error
[ 8473.098820] bcache (dm-10): IO error on dm-10 for checksum error
[ 8916.491297] bcache (dm-10): IO error on dm-10 for checksum error
[ 8916.715057] bcache (dm-10): IO error on dm-10 for checksum error
[ 8916.715111] bcache (dm-10): too many IO errors on dm-10, setting
filesystem RO
[ 8916.733056] bcache (dm-10): IO error on dm-10 for checksum error
[ 8916.733125] bcache (dm-10): dm-10 read only
[ 8916.733161] bcache (dm-10): too many IO errors on dm-10, setting
device RO
[ 8916.988286] bcache (dm-10): IO error: read only
[ 8916.988545] bcache (dm-10): IO error: read only


Is this due to changing str_hash?
Marcin
