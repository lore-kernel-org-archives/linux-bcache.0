From: Juan Antonio Martinez <jantonio-oytJ0Z/vEwre5aOfsHch1g@public.gmane.org>
Subject: wishlist: read-only bcache for nbd / LTSP devices
Date: Thu, 28 Aug 2014 15:09:53 +0200
Message-ID: <1409231393.17946.41.camel@jonsy.dit.upm.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

Short question: how to use bcache with read-only devices such as
CD's or read-only NBD devices?

Long text :-)
I'm trying to setup 200+ LTSP Fat clients based on NBD remote block
devices.
LTSP mounts NBD devices in read-only mode and then their internal
squashfs is remounted via copy-on-write and exposed to the client

I'd like to create a local disk cache for /dev/nbdX by mean of BCache,
but have a little problem: due to BCache superblock issues, I need to
export NBD files in read/write (or copy-on-write mode) in order to get
caching/cached devices superblock info synced.

I cannot make assumption on client's local disk status, so its easy to
lost sync with bcache info on server.
So need:

- An easy way to erase cache info and start in a "clean,uncached" state
in server and client on client boot

- A Read-Only BCache (or similar) that don't need to store any
information on server side, just a list of blocks already in disk/memory
in client

- (For NBD guys) an extension to nbd-server to allow specify where to
store copy/on/write diff files, and let postrun/prerun scripts use not
only %s (file to be served) but %h (client ip being served), to erase
diff files on connection

Additionally Seems that there is no "blocks" package available for
Ubuntu-14.04, as the one provided in ppa:g2p/storage has failed
dependencies for python-3.4. I need command "blocks to-bcache" to
provide proper squasfs-to-bcache files conversion (Any link on how to
create BCache superblock and add it to an already created fs)

Thanks in advance
Juan Antonio


------------------------------------------------------------------------------
Slashdot TV.  
Video for Nerds.  Stuff that matters.
http://tv.slashdot.org/
