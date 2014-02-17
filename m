From: Marc Smith <marc.smith@mcc.edu>
Subject: HA Question
Date: Sun, 16 Feb 2014 22:37:23 -0500
Message-ID: <CAHkw+Lf9GRdTWVHbFYhA_C4J=QdSWyiRRP+bcnu3vLXHcA3RRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:34458 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751105AbaBQDhZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 16 Feb 2014 22:37:25 -0500
Received: by mail-qc0-f179.google.com with SMTP id e16so23429739qcx.10
        for <linux-bcache@vger.kernel.org>; Sun, 16 Feb 2014 19:37:23 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I am new to bcache and I have a question regarding its use in a high
availability (HA) setup. I'll be using the new LSI Syncro CS
controllers with Enterprise Storage OS (ESOS) for an upcoming project.
The LSI controller includes the CacheCade option for caching with
SSDs, however, its only read cache in this model, so I'm primarily
interested in the write-back cache feature of bcache.

The Syncro CS setup puts a RAID controller in each of two hosts, and
allows both hosts to share JBOD enclosures. Configured logical volumes
are available for read/write on both hosts simultaneously.

The idea (example) is to create a shared RAID10 volume of SSDs to use
as the cache device for bcache, and then some other RAID group of 15K
disks for the backing volume. Then add the bcache device on each host
-- is this possible with bcache? Data corruption? We would control IO
to the servers, so its not round-robin or anything like that... data
would flow to only one server, and then only in the event of a
fail-over, IO would be redirected to the other server. Or it might
work, but we'd be asking for trouble? =)


Thanks,

Marc
