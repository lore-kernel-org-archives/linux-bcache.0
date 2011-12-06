From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Mon, 5 Dec 2011 20:02:39 -0800
Message-ID: <CAC7rs0saVh=a587mNCTCJwbVi7-u7kRuXu6-pZuJ6CRs1AACsw@mail.gmail.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED47771.9030309@fnarfbargle.com>
	<20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED48A64.4080406@fnarfbargle.com>
	<20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED4981E.6040501@fnarfbargle.com>
	<20111206034553.GA25438@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206034553.GA25438@moria>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Argh. I spoke too soon, it just exploded after the second bonnie run.
The block layer is badly in need of some cleanup... *grumble*

On Mon, Dec 5, 2011 at 7:45 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Fixed the raid10 issue - it's working for me, and the code's up. Haven't
> fixed the duplicate registration issue yet, though - I'll take a look at
> that next...
>
