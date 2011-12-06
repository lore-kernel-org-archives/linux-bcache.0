From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Mon, 5 Dec 2011 19:45:53 -0800
Message-ID: <20111206034553.GA25438@moria>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED47771.9030309@fnarfbargle.com>
 <20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED48A64.4080406@fnarfbargle.com>
 <20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED4981E.6040501@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ED4981E.6040501-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Fixed the raid10 issue - it's working for me, and the code's up. Haven't
fixed the duplicate registration issue yet, though - I'll take a look at
that next...
