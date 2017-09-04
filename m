From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Mon, 4 Sep 2017 09:31:40 -0700
Message-ID: <CAJ+L6qef4ApkunEEkK55MFfFexLCXqtPz4Gg4EyPXc_0Uki4nw@mail.gmail.com>
References: <20170901203722.29974-1-mlyle@lyle.org> <fe238d0c-05c4-0d58-06f6-3013e20c5679@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34987 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdIDQbl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Sep 2017 12:31:41 -0400
Received: by mail-qk0-f195.google.com with SMTP id o77so537943qke.2
        for <linux-bcache@vger.kernel.org>; Mon, 04 Sep 2017 09:31:41 -0700 (PDT)
In-Reply-To: <fe238d0c-05c4-0d58-06f6-3013e20c5679@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

[I'm sorry for the resend-- seems I can't send plain text mode from
inbox so sent HTML mail on accident]

OK, I don't like the formulation of the code either-- I will
restructure a bit to be clearer in a bit bigger of a patch today or
tomorrow.

The *critical* issue is this-- if v is between -1023 and -1, the line
return sprintf(buf, "%llu", v); is run. In turn, this prints out a 20
digit number plus terminating null. In turn, bch_hprint is called
places where it is provided with a 20 character buffer, which overruns
and causes a kernel panic. This doesn't require any privilege to
trigger, so it's a user-space denial of service vulnerability.

I discovered this when running watch cat writeback_rate_debug to
troubleshoot the control system (which I am tempted to rewrite,
because it has various issues) and I encountered multiple panics.

Mike

On Sun, Sep 3, 2017 at 11:07 PM Coly Li <colyli@suse.de> wrote:

On 2017/9/2 =E4=B8=8A=E5=8D=884:37, Michael Lyle wrote:
> Solve a crash where the stack is overrun when reading sysfs and
> small negative values are present. Also correct output, as before
> it would output "1.10" for numbers bigger than "1.9", and negative
> fractional output was incorrect.
>

I suggest to provide more detailed comments here, to explain,
- the purpose and expected output of bch_hprint()
- when a small negative value comes, how bhc_hprint() goes wrong
- how your patch fixes the root cause.

The reason for my suggestion is, the original code is ambiguous on
positive and negative integer values. When you see the following
for-loop in bch_hprint(),
83 for (u =3D 0; v >=3D 1024 || v <=3D -1024; u++) {
84 t =3D v & ~(~0 << 10);
85 v >>=3D 10;
86 }
You may notice no matter v is positive or negative, variables 't' and
'v' are handled with the bit operations which taking for granted that
'v' is always positive integer values.

I don't have very deep insight of coding theory, my intuition of a first
glance on the code gives me a warning: the code might be buggy.
Example an integer N, most of time, -N and +N has different ordering in
non most-significant bits. The original code neglects when v is negative
value, v is in form of complement code, so value t here is not correct,
then the following calculation in wrong,
91 if (v < 100 && v > -100)
92 snprintf(dec, sizeof(dec), ".%i", t / 100);

I see your patch fixes the above two lines, but your patch is not simply
understandable for me, e.g. why you use 't > 103' (I guess it is because
103*10 > 1024).

A fix much simpler in logic maybe look like this, which is enlighten by
your patch,

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 8c3a938f4bf0..bf1dbb9c3ea8 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -78,20 +78,26 @@ ssize_t bch_hprint(char *buf, int64_t v)
{
static const char units[] =3D "?kMGTPEZY";
char dec[4] =3D "";
+ char sign[2] =3D "";
int u, t =3D 0;

- for (u =3D 0; v >=3D 1024 || v <=3D -1024; u++) {
+ if (v < 0) {
+ sign[0] =3D '-';
+ v =3D -v;
+ }
+
+ for (u =3D 0; v >=3D 1024; u++) {
t =3D v & ~(~0 << 10);
v >>=3D 10;
}

if (!u)
- return sprintf(buf, "%llu", v);
+ return sprintf(buf, "%s%lli", sign, v);

- if (v < 100 && v > -100)
- snprintf(dec, sizeof(dec), ".%i", t / 100);
+ if (t > 0)
+ snprintf(dec, sizeof(dec), ".%i", (t*10)/1024);

- return sprintf(buf, "%lli%s%c", v, dec, units[u]);
+ return sprintf(buf, "%s%lli%s%c", sign, v, dec, units[u]);
}

This is just an idea in my brain which is enlighten by your patch, not
correct maybe, just for your reference. I do like the idea "t * 10 /
1024", I have to say I feel happiness when I understand it, very smart :-)

Finally please offer a more detailed comments as I suggested, thank you
in advance.

Coly Li


> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
> ---
> drivers/md/bcache/util.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 8c3a938f4bf0..11957038c630 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -86,10 +86,14 @@ ssize_t bch_hprint(char *buf, int64_t v)
> }
>
> if (!u)
> - return sprintf(buf, "%llu", v);
> + return sprintf(buf, "%lli", v);
>
> - if (v < 100 && v > -100)
> - snprintf(dec, sizeof(dec), ".%i", t / 100);
> + if (t > 103) {
> + if (v > 0)
> + snprintf(dec, sizeof(dec), ".%i", t * 10 / 1024);
> + else
> + snprintf(dec, sizeof(dec), ".%i", 10 - (t * 10 / 1024));
> + }
>
> return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> }
>
