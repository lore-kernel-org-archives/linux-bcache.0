From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: [bcachefs] Matrix - which features should work, which are known as
 broken
Date: Fri, 3 Feb 2017 12:59:10 +0100
Message-ID: <b7e7d913-d75d-ae92-bdd0-f27e176e381e@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:57292 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdBCL74 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 3 Feb 2017 06:59:56 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!

I'd like to ask what features should be tested, which features are
unfinished and we shouldn't test it at this moment.
From `bcache format`:
Options:
--block=size
--btree_node=size
--metadata_checksum_type=(none|crc32c|crc64)
--data_checksum_type=(none|crc32c|crc64)
--compression_type=(none|lz4|gzip)
--error_action=(continue|readonly|panic)

--max_journal_entry_size=size
--label=label
--uuid=uuid


--fs_size=size
--bucket=size
--discard
--tier=#

From sysfs:
options/compression - switching between compression method
options/(metadata|data)_checksum - switching between checksum alg
options/(metadata|data)_replicas - it doesn't work now?
options/posix_acl - it looks that this switch doesn't change acl behaviour
options/str_hash - switching between hash alg
options/inode_32bit - ???



as far as I remember tiering should wait some time. What about other
options? All of them should work and we should expect that bcachefs
works with them?
Kent, are you planning to allow set compression algo per file?

Marcin
