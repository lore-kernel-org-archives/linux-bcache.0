From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: In-place conversion and alignment needs
Date: Mon, 18 Mar 2013 21:20:21 +0000 (UTC)
Message-ID: <ki80el$q52$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I've started using bcache after writing a tool to convert existing
partitions and logical volumes into bcache volumes, available here:

    <https://github.com/g2p/blocks>

I'm very happy with the performance, but there is a fundamental problem
with the conversion, which has to do with the current fixed offset from
the backing device's bcache superblock to the start of the filesystem
data.

With a plain partition this means the conversion creates an unaligned
partition, which will break the lesser-common-denominator approach tools
like parted use to determine partition alignment; it could complicate
things down the line but it's workable.

With LVM the conversion has to shift the data by exactly 4MB, which is
not possible with the current bcache. I'm working around it by putting a
small partition table between the LV and the bcache device, but that
brings some extra complexity; resizing the LV involves resizing the
partition table, which is the sort of annoyance LVM is supposed to get
rid of in the first place.

In the interest of making bcache easier to install and use, I'd like to
plead for a customisable data offset. The superblock format appears to
be extensible thanks to the version field, most of the pieces are there
for a safe transition. There is even a commented out implementation in
the userland tools, presumably Kent already has thought of it?
