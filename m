From: Paul Clements <paul.clements-eviPjrN/1CxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: bcache on NBD block devices
Date: Tue, 25 Feb 2014 11:33:33 -0500
Message-ID: <CAECXXi5OHR9g9L5fHy4MXaVo2P7QkB4hAWnVAqJwr_pT_SE=2Q@mail.gmail.com>
References: <1393339208.26501.42.camel@jonsy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8206783942516560703=="
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1393339208.26501.42.camel@jonsy>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Juan Antonio Martinez <jantonio-oytJ0Z/vEwre5aOfsHch1g@public.gmane.org>
Cc: "nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

--===============8206783942516560703==
Content-Type: multipart/alternative; boundary=e89a8ffbaed334b23504f33da68e

--e89a8ffbaed334b23504f33da68e
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Feb 25, 2014 at 9:40 AM, Juan Antonio Martinez
<jantonio-oytJ0Z/vEwre5aOfsHch1g@public.gmane.org>wrote:

> Hi all
>
> (This is my first post on this list. I'm still a novice on bcache and
> proper nettiquete on this list, so apologize for my mistakes)
>
> Scenario: several NBD LTSP Fat Clients on (a bit) obsolete hardware
> kernel 3.11.0-15 on Ubuntu 13.10
>
> /dev/sda1 as local cache device
> /dev/nbd1 as remote NBD backing bcache device
>
> - I've created and registered /dev/sda1 as cache device without problems
> - To create nbd file to be exported I've typed following sequence:
>
> # create an empty file
> root# dd if=/dev/zero of=bcache_test.img bs=1M count=64
> # use it as loop block device
> root# losetup /dev/loop0
> # make it a backing bcache device
> root# make-bcache -B /dev/loop0
>

have you tried doing this step from the client machine instead, i.e.:

make-bache -B /dev/nbd1

after the nbd connection is up? does that work?

--e89a8ffbaed334b23504f33da68e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Tue, Feb 25, 2014 at 9:40 AM, Juan Antonio Martinez <span dir=3D=
"ltr">&lt;<a href=3D"mailto:jantonio-oytJ0Z/vEwre5aOfsHch1g@public.gmane.org" target=3D"_blank">jantonio=
@dit.upm.es</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi all<br>
<br>
(This is my first post on this list. I&#39;m still a novice on bcache and<b=
r>
proper nettiquete on this list, so apologize for my mistakes)<br>
<br>
Scenario: several NBD LTSP Fat Clients on (a bit) obsolete hardware<br>
kernel 3.11.0-15 on Ubuntu 13.10<br>
<br>
/dev/sda1 as local cache device<br>
/dev/nbd1 as remote NBD backing bcache device<br>
<br>
- I&#39;ve created and registered /dev/sda1 as cache device without problem=
s<br>
- To create nbd file to be exported I&#39;ve typed following sequence:<br>
<br>
# create an empty file<br>
root# dd if=3D/dev/zero of=3Dbcache_test.img bs=3D1M count=3D64<br>
# use it as loop block device<br>
root# losetup /dev/loop0<br>
# make it a backing bcache device<br>
root# make-bcache -B /dev/loop0<br></blockquote><div><br></div><div>have yo=
u tried doing this step from the client machine instead, i.e.:</div><div><b=
r></div><div>make-bache -B /dev/nbd1</div><div><br></div><div>after the nbd=
 connection is up? does that work?</div>
<div><br></div><div><br></div></div></div></div>

--e89a8ffbaed334b23504f33da68e--


--===============8206783942516560703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Flow-based real-time traffic analytics software. Cisco certified tool.
Monitor traffic, SLAs, QoS, Medianet, WAAS etc. with NetFlow Analyzer
Customize your own dashboards, set traffic alerts and generate reports.
Network behavioral analysis & security monitoring. All-in-one tool.
http://pubads.g.doubleclick.net/gampad/clk?id=126839071&iu=/4140/ostg.clktrk
--===============8206783942516560703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Nbd-general mailing list
Nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/nbd-general

--===============8206783942516560703==--
