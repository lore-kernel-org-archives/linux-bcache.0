Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AB22D061C;
	Tue, 17 Feb 2026 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771314615; cv=fail; b=G1uM2kwiuWICqjmogLzGjQzqcfus1meezeia9x59x96xZyj2UMkAva0oRgkyKve8NQ4K8oJEK0/bt2pWm+w48D1KQo3UlSduHYkeCgGlQVXHZKjhe+g24e+k8I5hCwtiyDUKr1ngYpiQ33d2Jm1NcdYsMK+N8jP0jBCbrA6RSps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771314615; c=relaxed/simple;
	bh=/VvpuIfIqUNMHP4iTNiivxD2g8ANvZY3EbWC8ipVWmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j0ngrhlPGyyfv32YbMClwHaznf1fJc3wPYEXAV+eIkCmGlTm5Y0B5sVQiK3GlRqBHXXIAUrn/fygUzdTvF+NeSXif5txoxsw7Khi5qx8VfspUrgpacHrzcwGBhceJuPlmpZvozO8r4J1xNjd84jBP+LAfMn28DndSk1BKZkMdcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HY+Iog0W; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f09DqBwF; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HY+Iog0W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f09DqBwF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771314614; x=1802850614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/VvpuIfIqUNMHP4iTNiivxD2g8ANvZY3EbWC8ipVWmw=;
  b=HY+Iog0WLcdjbocOa66P8TSbrSpCv1vmot6i2RM6gwwr9omslmfQvIS4
   92Air7OyCkYEnZDDnFpr4u1rj318h6ejKbmlox0nzZ9YOeornMeKAF9MZ
   IOEMQIsXAu5qCKAQ8nbBl3o+iGwM9oOevKu/5eV1IhfBmoEZVY+HRPGh2
   Uuf5BsdZFeHDYQWq/JtTNHP7wfwjQ+yD/A5OEls3nawJWaPFUfWK8RrMW
   saLuHH6Ls8MhsobSuuU55hVxx0e/ktlOM+rieuvQoPAX2uT2/TPgdkZEg
   qROekPVR667hF4xfAgDlA2lDulZ5b43l0nJqwB++Z2Wf0xckM4j1YlqM7
   w==;
X-CSE-ConnectionGUID: txV1E9YPR/qft/Vuxt8Y7w==
X-CSE-MsgGUID: urYmBoYuST+bcyDLRLOHVw==
X-IronPort-AV: E=Sophos;i="6.21,295,1763395200"; 
   d="scan'208";a="137335664"
Received: from mail-westus2azon11012026.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Feb 2026 15:50:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U9v2CsmpaZJaE0436uoB00W4ckWKnP9VAd1/m5sqe8wQs4cm9G7nQOo0rbRkXLq+bKLNtoI/UvwCxM/bLyKULR+b/cD0TBIoMq6Q6w3NYWLQ4c9SMbmD55tD7Qym/IdZSvqgxckBos2UUOx4ykmAnK8Vx4tfeoSmRTQFbVZzjVQYJo/+bPY6Lnx9wO1QKSEvkvJ074Pf1uSl/X2qfS9evSyI+6mo3H1OLHaMGsmz4CseLNLO2aE6r1AiLzY8Jo4J6m3xkFkArQ3HMNXVz8zorFev/xofU+5+RJxlHzYiPDhEGhnrcufAWXQHkFmpnV9LH3k9dHjtRwxKzeCbNMn6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COc03I30bFD6ltxiYYxpZzfKg77Gjr8vxjnUNYPffN0=;
 b=oio4B2I+T5QLFXb19cNQQBwL971P9gRGoasNxkUFFcmIXPJuVJXNx0bvRy2LhKBOOzsF/OMmWwg7gM/jKN/CDa8rx31S2QizRnuoRBRXcCIERsjG+S99/6ZFgdvFNLxLdIAAsfJYalkffyGRf454e0QCrfk+Vw1ybGuA/Zyclj9pvl4qJugAXzACaRwKkwORXdRSrymjTejLCdYhuDYHM2QE7HWfD3EKVMrP4Agn4fctRE0U9FUnt5L6JEdfEUjXBv+uE2MdW1aE7qoHYVGnkDcBIG0G8EnFLzevSeH1Fxo85MG0FxzT3Ie20ZpOmH9DWKzDXqhBXVQv253XjUlMew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COc03I30bFD6ltxiYYxpZzfKg77Gjr8vxjnUNYPffN0=;
 b=f09DqBwF1EL8dNCayOc/jq8pS1efRwNTNxApxQAl7OAmuueK8Tkhhgri6TjUaCUW3uOe6nDOX4jp/4YJb8lSsbi30LVQVtlvbVGbQhaXCAvhb6GvB2N7FDIvCdftmgB/35rb7CcT8sI1hSKLG+1byJFZYVkZcoSJHjtF5lTvluo=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by MN2PR04MB6879.namprd04.prod.outlook.com (2603:10b6:208:1f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 07:50:04 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.008; Tue, 17 Feb 2026
 07:50:04 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v4 2/3] bcache: add bcache/002
Thread-Topic: [PATCH blktests v4 2/3] bcache: add bcache/002
Thread-Index: AQHcnDOg2aqeq6PcPEaBLkQKrwkDArWGi6WA
Date: Tue, 17 Feb 2026 07:50:04 +0000
Message-ID: <aZQcH-d-ZcgtMoJb@shinmob>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
 <20260212-bcache-v4-2-215f3fde1c84@suse.de>
In-Reply-To: <20260212-bcache-v4-2-215f3fde1c84@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|MN2PR04MB6879:EE_
x-ms-office365-filtering-correlation-id: 432bb605-6354-4c75-33d9-08de6df929a1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9SZb+hhvh6pKxMsEbqRMUZ/qqbBxRt4k1VGv2mx3eYUd/C7bGu7N1lR+oNO2?=
 =?us-ascii?Q?cvtfLpPCxWX909BiyRPC5AU/oNFXEy9gKqKMIlTxaBRX+ktWU9R+mSlsxvsb?=
 =?us-ascii?Q?f0ZB/Bpx07Bxzr702X40mA2ZurL9yjaqV6U9L7uJd3j2wsvheTvd1XXi27c6?=
 =?us-ascii?Q?bUdglANG9mAvDWc62FvCdBW78koyhxFsq5cqAtxAelFucvUxdLWNHVjuyJHc?=
 =?us-ascii?Q?W9h48bpUln/oo4c1JbpVb6ET5tg4JnmZmNHSfKdQRKc5CeJ1zvy+eeDV5zAt?=
 =?us-ascii?Q?wRoHayCXm92qf3dpw2v2WtmChoX/tWhKiJy9loULUYhhvw+rh/v9+rX2FVL3?=
 =?us-ascii?Q?yYPx4XJ6QXPCtqAHXDCVUg9B05qN3DD4UEFq+SZTkmF06w6E4KjR2qBXMrxp?=
 =?us-ascii?Q?nvoFaydtKWCcXgzksHPbJiQ7b4gVJpojdy5Dz8DRzq2Ktj4XNYxGjJFO3+5N?=
 =?us-ascii?Q?t7Hu347Q0460nPkFE52URTdCwe1u0F+0wfp04HTTT7HwRsKxazyRYJFeASJP?=
 =?us-ascii?Q?FALmqNBj+tU0w+QVKX9ry7PnREBi1y44ZqmuPFwBpyET6lCdiCeencE+O/lW?=
 =?us-ascii?Q?S0jssbT0gX4zZK5mEY26pNCOPfK4sqp5xKvRzwCI2BVmLgKiDEkD+uZsF7+w?=
 =?us-ascii?Q?S8dFrT3IuRnKehcuWer0ZgMxDSmzpgUHojr3SOW/+68vvvtYt05XKsM5L111?=
 =?us-ascii?Q?y95YmUBByoXsl+n+6/R1z3eY/T0RamWi0BzI+Ps/cIhxKeUymhaSwXj3Q0k+?=
 =?us-ascii?Q?UDrrTftltqkyhNsKa1XzH+K8w3OFKFRvDlLUMZs2cGdbP+/0D7aJKxVAen+A?=
 =?us-ascii?Q?va3Vrr9BvPw+Adq6EyjOl93xYmO2aoYJXW6iO5p6JZ/c1eEyGAkBwmzZX72B?=
 =?us-ascii?Q?xDhoI0mMho+6ZclpuMI2ZkJOgV7/bsljttdxmWOjpmMOWYDmCqMGvCoidrz7?=
 =?us-ascii?Q?PJ2tkddX2301qou5dFhuImuRmxT2Kpq7cEFsTkrbshd8ikVwkBph3MnM/Oto?=
 =?us-ascii?Q?I1eRJ1pfoBirQLAlmQNgyujLfm8iF1XRDrvtM58jkVfRuny7/fBhPINWu2p3?=
 =?us-ascii?Q?3v0KXc1XDd0Ma4tUbZHfX0o3cbmk1N/Jn2OTUs/+WwZXCqMjoHk49bwGI/j3?=
 =?us-ascii?Q?LVwJ9DfbzKnNU+fUPC7BVYFUEyZuHMFbA74DbCJRgX/ttiSCqavGfSNnYkJR?=
 =?us-ascii?Q?7lCe7StkQ2qoNcUm089S8ZGlGLA2vOXCB+DhGlOUQDP/pww+2BPasu6VufAK?=
 =?us-ascii?Q?VLEdUf2zKN5qvApIXEGz0WlHV24HH22s3ge3x/la4ppfTzK4wdHWkBDKG9mQ?=
 =?us-ascii?Q?5f4Dkx2ze7b6AVG/gbFhuFlxtRUakf6NxoRsuNq/0oEj6IC4RAJ+ZzKbcP4t?=
 =?us-ascii?Q?mQQp6mid0uDXQmexUTcWinxL9tYvUTGPUmbuUNHN3wPkNwwEiTDFr+hHgYqB?=
 =?us-ascii?Q?pZEtYIp0M3Nru9uxu1Yo08MjcYIAKrogkNEtzfHyG3+mq2Zci5xqLY3QExcu?=
 =?us-ascii?Q?YcSzs+f+uSOa6Vc5+xO7Si6RJFGoW2GOUAsGSN/YsSQw1imWytpI4ZESvmge?=
 =?us-ascii?Q?pCpxJUlUQExPaZly4Lfjs3VD15Vrgfs+IGkLhRU5lsCJcZ9nS7oefh1RITxD?=
 =?us-ascii?Q?odGCbNrWU+mZD7Z/91DHbn4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?dxd/+Uz5CeE72IVXCrRNl6+OH96DtRAQcELET1zLz7uCMycjK0OUOVoNvpyf?=
 =?us-ascii?Q?7FAoKfBC0O86sB7x+bcJAynkxNjRbqHlCsFbdKBP7ZuZLGLw6lb49FWfBjEf?=
 =?us-ascii?Q?Q6MpY7EuT9vqBmG8brol52qVJGLN704beFScZqwINpUYanyY4JD6MDtEox1w?=
 =?us-ascii?Q?zn0BF3aTh6g/sNnhkPNwTnQEuAhdcNQji+q4mwenUXTk10bkxz7Vh8//Btyh?=
 =?us-ascii?Q?lM4geiQZiwW2Dnm+2kMSicn7EhvWfoe9iICWyC5+uLnLSgyJk6nghAox/XE9?=
 =?us-ascii?Q?XZtpXkzFXb5pqys+iCaW3MpvfayQoOSQp5Rimqa+w6tlYSssqaR6Hny7Caj/?=
 =?us-ascii?Q?s4397YOaHxqkl0u5uBfUJm4igfHT+RN5Q/4URtozUaEuZ7sPRwesBVFRGik6?=
 =?us-ascii?Q?igDhwcTfWIVdiX1rf8x0p/A25sk8r8MprbyXfBilQfVJAk7ttGXfcy7KwaQx?=
 =?us-ascii?Q?dVmWaMHvMqAGG+XmPPBlC9GUqELCbphpTqjJ3TP9SKjqxeIcMoBcspOurDn+?=
 =?us-ascii?Q?m2z6j/ukkzPSmCPN2aeLLuTvEZ1gQpc8CVA6ltAeSLPl28evQdgdhwUYUz7D?=
 =?us-ascii?Q?62t4t4DUYlWnlmMJVpxxMovtRE1Jv3cjF/UL0c/AJjluVAvldpq8j8wKT8Ak?=
 =?us-ascii?Q?+bfDigxkPlSf9ne8wteOnLots54rEidudWfOLqKsszdwEWauRudt9TFFxdWR?=
 =?us-ascii?Q?ZVdL5VU0WULYmW1CVe/mtQGDNy0GT1vcjaVOtfPH/ReFFc7ME+bzcTW+hcXU?=
 =?us-ascii?Q?0y9rx9AWr+y6SoswJY/hK211hzKdey+u6DK+akfv5tYYbxsD2pjiMkTP2LkG?=
 =?us-ascii?Q?yX80vbwdAc0YG0F+K6Pzwb8tIgg+N1KgWBw1Hdm1rs2GXcGqvYQqmZJnFZ3x?=
 =?us-ascii?Q?SBWVSB4RyGtCSK4cZUfKRN6+1KGuW7Wro2Ydr4ICVfIeErZeNNahVCP8jQcD?=
 =?us-ascii?Q?xYY3uIP22sq2Islb8A0vDqGCUFhrakWR95wLHKUza/eoXSELYVxET4IJTQCC?=
 =?us-ascii?Q?kSHKc6QoWDjbqEKSF+35XAgFoHL2l1EhYfmsDNbvlzmcEIpGPg9/Q1lNMAFy?=
 =?us-ascii?Q?3nuEF9CQnPHevsgmxvUsLM49bOGZ5pO1NHz5O8LXUMhy++yUhMkxu/6uSMpU?=
 =?us-ascii?Q?ts+nxJgrfIp/DzN7ITeSpCncTEmDSNDkpSHFHsNB3LRiOD1GFEhHqj8ORgPG?=
 =?us-ascii?Q?fgbA+mEdj6xIQ29D4Dj6CyEn0yqB15/V9LZ+MYmYZfH7P1kyn7ZNvthnLrLH?=
 =?us-ascii?Q?NQK2L7ithlrt0Vh9gKzvkNqoIZY83K4SmuD2nc5I6FaSBeakNhVxRtJEu/B4?=
 =?us-ascii?Q?9/u4hzXqsaGeJ6NtAoFmgwMH79OZJ+bJRLfPnLmlZFh8pxOiDvzXP+YW7LsM?=
 =?us-ascii?Q?rTiHWDFeq1z0oy6cYfSAe4OfHZNtkmm+4KlmXgJ031HgN5GNjfk5iaYtnKo2?=
 =?us-ascii?Q?8vA6SXxC3pyKw4p2cvO95Ch2R6YiUL2A/4ibmUwYBDUrrrd7AP/2TFORjcfE?=
 =?us-ascii?Q?Vto3jeY9sP800p+cblUGeBmi1TWQoIO0CnMepWDavHoJnzNwbbs/Ft9TGEYe?=
 =?us-ascii?Q?AGOvdj17ZOTj56TDOJRYv91tm3Ed3xH1mt+p2gb4T98niqjUCYp0/WxZdz6O?=
 =?us-ascii?Q?CHbjewJWe19iid5kVU6JsQOw4xK/XI5N83QoWE1EyERqT+G89fJqYdX9I8Wj?=
 =?us-ascii?Q?hijnb9QrSBOsTiNhPJGErv1RIiBv4E4aOYy14y030m5KVrxcEoC7mv669rjI?=
 =?us-ascii?Q?W1tTB0PR10oZ1MGjH+QHQ4v5eZr9C/M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97591519EF3FBA44ABB0D941C050F27D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tHJSkw+Bqptvx2iYcTAJCW2DQH6v7Y1tnkbw3pTtI8fbWgsoEYf44zGNQXwyNFJHI/lB0Qcg1WoJFIt1HHLYin1eziuzAP6U+drVEOGbr2LRTyxRK2JdtF5TMIRhFxp6yA7Jl+SnHg6RJkYjhT+OhC0PuiMws921m+g2DiR0OnpqoRPhhWMVtb7nBY8DY0u+U3KM5LFPBTFrQNa6rgn852IWWU85GmKODaGI/wnjhHQd6O5ikqcfpOM6svBaHX7sgUi+xcMIFRVY1Uy3G+ukA6zsjkkXKBCOQBlMVGTGvQF4CrxqAG9s94oZZ17Q4KPzF56jadzBOBTLprrxAn/z7G1xypXYrESw+yZ+WHYq4J9gkLHHvg2m4hkbDaUpoGvsbutU6SAxAJJEFxluib5s3hFIT6+jzv3DA7eU5e/yrRQ3mVdv/+koJqszXpwlXNL7uczJH3wxHAyNItArj2SIU7K39xE2glTZ+C6q215tWkbz7J/tBBJoeSHxswiUXPzkZQMgh6bmX/XDPyNXoA/iFZKjXXEIUAAAWPglqiPJNbNATERcQTpcwS2G26soXdc4CZ1BnNrroU1fbZazf51w6sW1xanmTrmAMgT0defymIT+UZeeBKpdoinVP8j175P/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432bb605-6354-4c75-33d9-08de6df929a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2026 07:50:04.5437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RWSz5uExovm5bpYunk3FWxgDGZsSOVrhRnFN0d+RRduFQlRDbYahGd47slgcMWkmq1OsUZwnYwqc1+yX2e61UY8Bkl+B3ntmO1LyfoCOVRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6879

On Feb 12, 2026 / 16:23, Daniel Wagner wrote:
> Add test case from Stephen Zhang [1].
>=20
> [1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04V=
xy1MPyhm+CZyXB01FuQ@mail.gmail.com/
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

Thank you for adding this patch. When I ran this test case in my test
environment using the kernel v6.19, it failed:

    runtime  7.536s  ...  7.214s
    --- tests/bcache/002.out    2026-02-14 21:16:20.918000000 +0900
    +++ /home/shin/Blktests/blktests/results/nvme0n1_nvme2n1_nvme3n1_nvme4n=
1/bcache/002.out.bad 2026-02-16 14:29:25.596000000 +0900
    @@ -1,2 +1,3 @@
     Running bcache/002
     Device state: no cache
    +ERROR: Accounting leak detected!

Is this failure expected?

And let me leave a few nit comments in line.

> ---
>  tests/bcache/002     | 62 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/bcache/002.out |  2 ++
>  2 files changed, 64 insertions(+)
>=20
> diff --git a/tests/bcache/002 b/tests/bcache/002
> new file mode 100755
> index 000000000000..c27178a90c2d
> --- /dev/null
> +++ b/tests/bcache/002
[...]
> +test_device_array() {
> +	echo "Running ${TEST_NAME}"
> +
> +	if [[ ${#TEST_DEV_ARRAY[@]} -lt 2 ]]; then
> +		SKIP_REASONS+=3D("requires at least 2 devices")
> +		return 1
> +	fi
> +
> +	_setup_bcache "${TEST_DEV_ARRAY[@]}"
> +
> +	local bcache_nodes bcache_dev bdev_name fio_pid

Nit: I think bcache_nodes should be declared as an array, with -a option.
     Also, 'state' can be added to this local var list.

> +
> +	mapfile -t bcache_nodes < <(_create_bcache \
> +				--cache "${TEST_DEV_ARRAY[0]##*/}" \
> +				--bdev "${TEST_DEV_ARRAY[1]##*/}" \
> +				--writeback)
> +
> +	bcache_dev=3D"${bcache_nodes[0]}"
> +	bdev_name=3D"$(basename "${bcache_dev}")"
> +	echo 1 > /sys/block/"${bdev_name}"/bcache/detach
> +
> +	state=3D"$(cat /sys/block/"${bdev_name}"/bcache/state)"
> +	echo "Device state: ${state}"
> +
> +	_run_fio_rand_io --filename=3D"${bcache_dev}" --time_base \
> +			--runtime=3D30 >> "$FULL" 2>&1 &
> +	fio_pid=3D$!
> +
> +	sleep 5
> +
> +	local stats_line util
> +	stats_line=3D$(iostat -x 1 2 "${bdev_name}" | grep -w "${bdev_name}" | =
tail -n 1)
> +	util=3D"$(echo "${stats_line}" | awk '{print $NF}')"
> +
> +	if (( $(echo "${util} > 1.0" | bc -l) )); then

Nit: bc -l option can be --mathlib for readability.

> +		echo "ERROR: Accounting leak detected!"
> +	fi
> +
> +	{ pkill -f "fio.*${bcache_dev}"; wait "${fio_pid}"; } &> /dev/null

Nit: pkill -f option can be --full for readability.

> +
> +	_remove_bcache --bcache "${bcache_nodes[@]}" \
> +			--cache "${TEST_DEV_ARRAY[0]##*/}" \
> +			--bdev "${TEST_DEV_ARRAY[1]##*/}"
> +}=
