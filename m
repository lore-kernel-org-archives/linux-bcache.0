From: "Dr. Greg Wettstein" <greg-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
Subject: Re: Bcache v. whatever
Date: Tue, 15 Jan 2013 00:59:33 -0600
Message-ID: <201301150659.r0F6xXgt028574@wind.enjellic.com>
References: <koverstreet@google.com>
Reply-To: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
       "Bcache v. whatever" (Jan 14,  2:32pm)
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Jan 14,  2:32pm, Kent Overstreet wrote:
} Subject: Bcache v. whatever

Hi Kent, hope your week is going well.

> Bcache: a block layer SSD cache
>
..
>
> This latest branch is on top of v3.8-rc3:

Glad to see the push to get bcache mainlined.  I've been meaning to
send you an e-mail on this but the holiday managed to push work back
on almost everything.... :-)

We have been working to get ready to take bcache into testing as a
component in our storage virtualization servers.  We are currently
basing our systems on the longterm 3.4 kernel.

Off the top of your head are there any mainline kernel dependency
issues which would preclude working a patch up against 3.4?  If not I
will putz around with GIT a bit and see if I can get a patch worked up
against 3.4 and post it on an FTP server as it seems to be easier for
people to grab that for testing.

If we can get that done I will put it into an environment where we can
drive a few hundred terrabytes of multi-initiator I/O against it and
see if anything shakes out.

Thanks again for all your effort on this.

Have a good week.

}-- End of excerpt from Kent Overstreet

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
------------------------------------------------------------------------------
"I created a hack to make the division come out right ... I was
 relieved because I thought I was coding wrong.

 Did you?  It took a guy (Thomas Nicely) with a Ph.D. doing heavy
 research in computational number theory to find it, yet you found it
 while working on a game in QuickBasic?"
                                -- Slashdot
