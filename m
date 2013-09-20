From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: bcache & btrfs: "Btrfs detected SSD devices, enabling SSD mode"
Date: Fri, 20 Sep 2013 18:03:16 +0200
Message-ID: <523C71C4.9030606@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

This may be known already, but I noticed the following message in syslog 
during boot:

Btrfs detected SSD devices, enabling SSD mode

Btrfs is right in a sense: there is a SSD involved, but there's a HDD as 
well. I don't think it is an issue, but I have no idea how "btrfs' SSD 
optimizations"  will interact with bcache. Might be interesting.

Rolf
