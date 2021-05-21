Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1452C433ED
	for <linux-bcache@archiver.kernel.org>; Fri, 21 May 2021 12:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970EE61090
	for <linux-bcache@archiver.kernel.org>; Fri, 21 May 2021 12:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhEUMHz (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 21 May 2021 08:07:55 -0400
Received: from correo01.aragon.es ([188.244.81.25]:17164 "EHLO aragon.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhEUMHy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 08:07:54 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 08:07:53 EDT
Received: from aragon.es ([172.30.3.33])
        by FM3.aragon.es  with ESMTP id 14LBuHLm031712-14LBuHLn031712
        for <linux-bcache@vger.kernel.org>; Fri, 21 May 2021 13:56:17 +0200
Received: from [1.8.2.59] (account scastillo@aragon.es [1.8.2.59] verified)
  by aragon.es (CommuniGate Pro SMTP 6.2.12)
  with ESMTPSA id 91114546 for linux-bcache@vger.kernel.org; Fri, 21 May 2021 13:56:17 +0200
To:     linux-bcache@vger.kernel.org
From:   Santiago Castillo Oli <scastillo@aragon.es>
Subject: Best strategy for caching VMs storage
Message-ID: <08e95aaf-a5e5-fb32-31ea-ca35cc028fac@aragon.es>
Date:   Fri, 21 May 2021 13:56:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: es-ES
X-FE-Policy-ID: 21:5:5:aragon.es
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi there.


I have a host running 4 VMs using qcow2 storage on a ext4 fs over HDD. 
Each VM has 3 qcow files (system, data and swap). I know I have an I/O 
bottleneck.

I want to use bcache with an SSD to accelerate disk access but I´m not 
sure where should I put bcache on storage stack.


Should I use bcache on host or in guests?

Just one bcache backing device for a single (ext4) filesystem with all 
qcow files there, or different bcache and backing devices for each qcow2 
file?


Right know, I prefer qcow2 over thin-lvm for storage, but i could change 
my mind if thin-lvm is a much better combination for bcache.


What would be the best strategy for caching VMs storage ?

Any recommendation, please?


Regards and thank you


-- 
___________________________________________________________

