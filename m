From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RFC 2/2] tracing/block: add request operation and flags
 into trace events
Date: Mon, 4 May 2020 13:35:24 -0400
Message-ID: <20200504133524.686c7be5@gandalf.local.home>
References: <158860537783.30407.1084087380643625249.stgit@buzz>
        <158860538157.30407.6389633238674780245.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <158860538157.30407.6389633238674780245.stgit@buzz>
Sender: linux-block-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, 04 May 2020 18:16:21 +0300
Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:

> +/* Request operations, see enum req_opf */
> +
> +TRACE_DEFINE_ENUM(REQ_OP_READ);
> +TRACE_DEFINE_ENUM(REQ_OP_WRITE);
> +TRACE_DEFINE_ENUM(REQ_OP_FLUSH);
> +TRACE_DEFINE_ENUM(REQ_OP_DISCARD);
> +TRACE_DEFINE_ENUM(REQ_OP_SECURE_ERASE);
> +TRACE_DEFINE_ENUM(REQ_OP_ZONE_RESET);
> +TRACE_DEFINE_ENUM(REQ_OP_WRITE_SAME);
> +TRACE_DEFINE_ENUM(REQ_OP_ZONE_RESET_ALL);
> +TRACE_DEFINE_ENUM(REQ_OP_WRITE_ZEROES);
> +TRACE_DEFINE_ENUM(REQ_OP_ZONE_OPEN);
> +TRACE_DEFINE_ENUM(REQ_OP_ZONE_CLOSE);
> +TRACE_DEFINE_ENUM(REQ_OP_ZONE_FINISH);
> +TRACE_DEFINE_ENUM(REQ_OP_SCSI_IN);
> +TRACE_DEFINE_ENUM(REQ_OP_SCSI_OUT);
> +TRACE_DEFINE_ENUM(REQ_OP_DRV_IN);
> +TRACE_DEFINE_ENUM(REQ_OP_DRV_OUT);
> +
> +#define BLOCK_REQ_OP_STRINGS					\
> +	{ REQ_OP_READ,		"READ" },			\
> +	{ REQ_OP_WRITE,		"WRITE" },			\
> +	{ REQ_OP_FLUSH,		"FLUSH" },			\
> +	{ REQ_OP_DISCARD,	"DISCARD" },			\
> +	{ REQ_OP_SECURE_ERASE,	"SECURE_ERASE" },		\
> +	{ REQ_OP_ZONE_RESET,	"ZONE_RESET" },			\
> +	{ REQ_OP_WRITE_SAME,	"WRITE_SAME" },			\
> +	{ REQ_OP_ZONE_RESET_ALL,"ZONE_RESET_ALL" },		\
> +	{ REQ_OP_WRITE_ZEROES,	"WRITE_ZEROES" },		\
> +	{ REQ_OP_ZONE_OPEN,	"ZONE_OPEN" },			\
> +	{ REQ_OP_ZONE_CLOSE,	"ZONE_CLOSE" },			\
> +	{ REQ_OP_ZONE_FINISH,	"ZONE_FINISH" },		\
> +	{ REQ_OP_SCSI_IN,	"SCSI_IN" },			\
> +	{ REQ_OP_SCSI_OUT,	"SCSI_OUT" },			\
> +	{ REQ_OP_DRV_IN,	"DRV_IN" },			\
> +	{ REQ_OP_DRV_OUT,	"DRV_OUT" }
> +
> +#define show_block_req_op(req)					\
> +	__print_symbolic((req) & REQ_OP_MASK, BLOCK_REQ_OP_STRINGS)
> +

A common trick to avoid the duplication from above is to do this:

#define BLOCK_REQ_OP_STRINGS					\
	EM( REQ_OP_READ,	"READ" )			\
	EM( REQ_OP_WRITE,	"WRITE" )			\
	EM( REQ_OP_FLUSH,	"FLUSH" )			\
	EM( REQ_OP_DISCARD,	"DISCARD" )			\
	EM( REQ_OP_SECURE_ERASE, "SECURE_ERASE" )		\
	EM( REQ_OP_ZONE_RESET,	"ZONE_RESET" )			\
	EM( REQ_OP_WRITE_SAME,	"WRITE_SAME" )			\
	EM( REQ_OP_ZONE_RESET_ALL,"ZONE_RESET_ALL" )		\
	EM( REQ_OP_WRITE_ZEROES, "WRITE_ZEROES" )		\
	EM( REQ_OP_ZONE_OPEN,	"ZONE_OPEN" )			\
	EM( REQ_OP_ZONE_CLOSE,	"ZONE_CLOSE" )			\
	EM( REQ_OP_ZONE_FINISH,	"ZONE_FINISH" )			\
	EM( REQ_OP_SCSI_IN,	"SCSI_IN" )			\
	EM( REQ_OP_SCSI_OUT,	"SCSI_OUT" )			\
	EM( REQ_OP_DRV_IN,	"DRV_IN" )			\
	EMe( REQ_OP_DRV_OUT,	"DRV_OUT" )

#undef EM
#undef EMe

#define EM(a, b) TRACE_DEFINE_ENUM(a);
#define EMe(a, b) TRACE_DEFINE_ENUM(a);

BLOCK_REQ_OP_STRINGS

#undef EM
#undef EMe

#define EM(a, b) { a, b },
#define EMe(a, b)  { a , b }

#define show_block_req_op(req)
	__print_symbolic((req) & REQ_OP_MASK, BLOCK_REQ_OP_STRINGS)


Several other event files in include/trace/events do this.

-- Steve
