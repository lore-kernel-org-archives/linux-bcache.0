From: Larkin Lowrey <llowrey-UpbEI2NfuFOXcJoGtpVZpwC/G2K4zDHf@public.gmane.org>
Subject: Read cache contents cleared on boot?
Date: Wed, 06 Nov 2013 16:08:45 -0600
Message-ID: <527ABDED.60902@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

When I boot my cache usage returns to 1.3GB even when it was nearly full
at shutdown (as reported by bcache-status). Are the read cache contents
not retained across a reboot?

I'm running fedora 19 w/ kernel-3.11.6-201.fc19.x86_64 and bcache-tools
built from git yesterday afternoon.

The machine in question is a backup server that boots nightly (via WOL)
runs all backup jobs then shuts down. The backup process spends most of
its time seeking (probably inodes) and I was hoping that the cache would
be warm on boot so those random reads would come from cache.

The cache device is a 48GB LVM LV on top of a 2 disk raid1 (60GB SSDs).
The backing devices are two 16 drive md raid6 arrays which act as LVM PVs.

Backup run time has not improved which supports the idea that the read
cache is empty on boot.

--Larkin
