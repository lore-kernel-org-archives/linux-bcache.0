From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: [ANN] Ubuntu PPA for bcache-tools and blocks
Date: Fri, 13 Sep 2013 15:59:52 +0400
Message-ID: <CACaajQtmLuA6M2Sj-=GJ6BGLicYi3Wn=qWmK84UA_PEa84MSYg@mail.gmail.com>
References: <5232F139.4080508@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7807215847107845359=="
Return-path: <ubuntu-devel-bounces@lists.ubuntu.com>
In-Reply-To: <5232F139.4080508@gmail.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/ubuntu-devel>,
 <mailto:ubuntu-devel-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/ubuntu-devel>
List-Post: <mailto:ubuntu-devel@lists.ubuntu.com>
List-Help: <mailto:ubuntu-devel-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/ubuntu-devel>,
 <mailto:ubuntu-devel-request@lists.ubuntu.com?subject=subscribe>
Errors-To: ubuntu-devel-bounces@lists.ubuntu.com
Sender: ubuntu-devel-bounces@lists.ubuntu.com
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: bcache <linux-bcache@vger.kernel.org>, linux-kernel@vger.kernel.org, ubuntu-devel@lists.ubuntu.com
List-Id: linux-bcache@vger.kernel.org

--===============7807215847107845359==
Content-Type: multipart/alternative; boundary=001a11c1b4589d61a304e64297c3

--001a11c1b4589d61a304e64297c3
Content-Type: text/plain; charset=UTF-8

Is that possible to create bcached kernel for raring?
I like autoapdating and packages created via standard way. So I can install
source package and headers and can vbuild to it dkms modules.
On Sep 13, 2013 3:04 PM, "Gabriel de Perthuis" <g2p.code@gmail.com> wrote:

> Hello,
> I've published various bcache-related packages to
>
> https://launchpad.net/~g2p/+archive/storage/
>
> The packages are built for saucy and raring, and can be
> added with
>
>     sudo add-apt-repository ppa:g2p/storage
>     sudo apt-get update
>     sudo apt-get install bcache-tools blocks
>
> bcache is a hybrid caching layer that speeds up HDDs
> with SSDs; it was merged in Linux 3.10.  Backported
> Ubuntu kernels are available at
>
> http://kernel.ubuntu.com/~kernel-ppa/mainline/
>
> bcache-tools contains udev and initramfs integration and
> some command-line tools.
>
> blocks is a conversion tool that can convert block devices
> to bcache and lvm.  Usage is described here:
>
> https://github.com/g2p/blocks#bcache-conversion
>
> This release of blocks adds a maintboot mode that can
> convert root filesystems to bcache without a live cd.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--001a11c1b4589d61a304e64297c3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Is that possible to create bcached kernel for raring?<br>
I like autoapdating and packages created via standard way. So I can install=
 source package and headers and can vbuild to it dkms modules.</p>
<div class=3D"gmail_quote">On Sep 13, 2013 3:04 PM, &quot;Gabriel de Perthu=
is&quot; &lt;<a href=3D"mailto:g2p.code@gmail.com">g2p.code@gmail.com</a>&g=
t; wrote:<br type=3D"attribution"><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Hello,<br>
I&#39;ve published various bcache-related packages to<br>
<br>
<a href=3D"https://launchpad.net/~g2p/+archive/storage/" target=3D"_blank">=
https://launchpad.net/~g2p/+archive/storage/</a><br>
<br>
The packages are built for saucy and raring, and can be<br>
added with<br>
<br>
=C2=A0 =C2=A0 sudo add-apt-repository ppa:g2p/storage<br>
=C2=A0 =C2=A0 sudo apt-get update<br>
=C2=A0 =C2=A0 sudo apt-get install bcache-tools blocks<br>
<br>
bcache is a hybrid caching layer that speeds up HDDs<br>
with SSDs; it was merged in Linux 3.10. =C2=A0Backported<br>
Ubuntu kernels are available at<br>
<br>
<a href=3D"http://kernel.ubuntu.com/~kernel-ppa/mainline/" target=3D"_blank=
">http://kernel.ubuntu.com/~kernel-ppa/mainline/</a><br>
<br>
bcache-tools contains udev and initramfs integration and<br>
some command-line tools.<br>
<br>
blocks is a conversion tool that can convert block devices<br>
to bcache and lvm. =C2=A0Usage is described here:<br>
<br>
<a href=3D"https://github.com/g2p/blocks#bcache-conversion" target=3D"_blan=
k">https://github.com/g2p/blocks#bcache-conversion</a><br>
<br>
This release of blocks adds a maintboot mode that can<br>
convert root filesystems to bcache without a live cd.<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-bcache=
&quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</blockquote></div>

--001a11c1b4589d61a304e64297c3--


--===============7807215847107845359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7807215847107845359==--
