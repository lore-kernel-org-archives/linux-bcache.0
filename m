From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache: A block layer cache
Date: Mon, 1 Apr 2013 22:58:39 +0300
Message-ID: <20130401195620.GZ18466@mwanda>
References: <20130401193740.GA32549@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130401193740.GA32549-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Slightly unrelated, it's weird that bcache has KEY_START() and
START_KEY().  Maybe FIRST_KEY() would be a better name for
START_KEY()?

regards,
dan carpenter
