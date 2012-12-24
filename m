From: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Subject: Journal question
Date: Mon, 24 Dec 2012 20:46:30 +0200
Message-ID: <50D8A306.8050109@cslab.ece.ntua.gr>
References: <50D8961A.1010703@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D8961A.1010703-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

I was reading the code documentation on your site, and I saw that you 
have written this:

"... In the future, the journal will contain a strong checksum of the 
data so that the write will complete when the journal entry finishes..."

My question is, is this feature implemented? As far as I can see by 
looking at journal.c, you are journaling only the keys and not the data 
they point to (it has been issued asynchronously a few steps back to the 
SSD, right?).
Also, if this is a feature to be implemented, wouldn't it create more 
stress on the CPUs, as well as more latency to issue the IO request to 
the SSDs (unless you issue it asynchronously while processing the keylist)?

I'm just curious on how you'd handle it.

Thanks,
Alex
