From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: [bcachefs][branch:bcachfs-testing] IO error on dm-9 for data checksum
 error
Date: Tue, 14 Feb 2017 16:23:27 +0100
Message-ID: <1cd85260-607b-41a3-587e-4ddb5690786d@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:33162 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753078AbdBNPYH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2017 10:24:07 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,
commit c06246fcf0fda98. FIlesystem was formated with parameters:
--metadata_checksum_type=crc64 --data_checksum_type=crc64
--compression_type=gzip

I copied /home to bachefs then I run md5deep -r /path, it gave me I/O
errors:

> [54987.478685] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28849 offset 36864: expected 191317 got afbdeb63 (type 2)
> [54987.479276] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28849 offset 36864: expected 191317 got afbdeb63 (type 2)
> [54987.479433] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28849 offset 36864: expected 191317 got afbdeb63 (type 2)
> [54987.503414] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28860 offset 131072: expected 24e92710 got 3ae7b19f (type 2)
> [54987.503475] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28860 offset 163840: expected 24e92710 got 3ae7b19f (type 2)
> [54987.503500] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28860 offset 196608: expected 903ff69a got 10892285 (type 2)
> [54987.503785] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28859 offset 56832: expected 29b5807b got f001ad79 (type 2)
> [54987.513292] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28860 offset 131072: expected 24e92710 got 3ae7b19f (type 2)
> [54987.550309] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28859 offset 56832: expected 29b5807b got f001ad79 (type 2)
> [54987.551014] bcache (dm-9): IO error on dm-9 for data checksum error, inode 28859 offset 56832: expected 29b5807b got f001ad79 (type 2)
> [54987.652095] bcache (dm-9): too many IO errors on dm-9, setting filesystem RO
> [54987.657641] bcache (dm-9): dm-9 read only
> [54987.737915] bcache (dm-9): too many IO errors on dm-9, setting device RO
> [54992.489286] bio_checksum_uncompress: 829 callbacks suppressed
> [54992.489290] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 65536: expected 3f6f6b9 got 518a2a73 (type 2)
> [54992.489337] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 131072: expected c31cc4d9 got 33c9807b (type 2)
> [54992.489904] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 163840: expected c31cc4d9 got 33c9807b (type 2)
> [54992.489958] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 196608: expected ab5f8685 got fbc1461c (type 2)
> [54992.489998] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 262144: expected 1142d02b got 466d00a0 (type 2)
> [54992.517092] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30618 offset 65536: expected 3f6f6b9 got 518a2a73 (type 2)
> [54992.529088] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30619 offset 171008: expected f9e5b72 got 422dec0b (type 2)
> [54992.529805] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30619 offset 384000: expected 6dfcc586 got 151de02b (type 2)
> [54992.529821] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30619 offset 425984: expected 6dfcc586 got 151de02b (type 2)
> [54992.530081] bcache (dm-9): IO error on dm-9 for data checksum error, inode 30619 offset 580608: expected 54ca71ca got c8af547a (type 2)
