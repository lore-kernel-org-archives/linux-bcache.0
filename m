From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT] Bcache version 11
Date: Sun, 29 May 2011 17:40:24 -0700
Message-ID: <BANLkTikj4VHofeVnYJUU2x1A+jt786JX-A@mail.gmail.com>
References: <20110520050237.GA383@google.com>
	<BANLkTikD++zm004igjFq8-h_+_B0B1cYcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikD++zm004igjFq8-h_+_B0B1cYcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sat, May 28, 2011 at 2:27 AM, Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> On Thu, May 19, 2011 at 10:02 PM, Kent Overstreet
> <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> The code's currently based off of 2.6.34 (!). Git repository is up a=
t
>> =A0git://evilpiepirate.org/~kent/linux-bcache.git
>
> fyi...
>
> $ git fetch origin
> remote: Counting objects: 1985947, done.
> remote: Compressing objects: =A065% (213301/3249)
> remote: aborting due to possible repository corruption on the remote =
side.
> fatal: protocol error: bad pack header
> $ git remote show origin -n
> * remote origin
> =A0Fetch URL: git://evilpiepirate.org/~kent/linux-bcache.git

Sorry about that, I was trying to figure out how the repository got
corrupted but it turned out it had just gotten too big for my linode,
and git was running out of memory. Repacked and it works now.
