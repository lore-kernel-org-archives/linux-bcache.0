Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D288460;
	Sat,  7 Mar 2026 10:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772879238; cv=fail; b=ML8TBQQ2XILtIK2FkPlJhFVtlPXN4Tg9pUcwQyqUqYT5AWFQs5aAMblY+hcGnKqwfou/L9n2Aq6yu68dDrr4wkr2UUDyQl6ops8ML0pcosotu4sHrC/FdX4fLKiO8vf31DkihY7n9nCr3qQV9CRWXPk4oZoh+YGYY6ToahFPBGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772879238; c=relaxed/simple;
	bh=uTPvXE72tgJsMK/o0377JYrAfLLs7DpQB+yshDBVHg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OlkK9QAr3bbni+qQFGZeKZdXbw+U2+Ap2N5tZti7f8K0gBFCUCS9JPoHp1dT6RBirh27v4KOFs74II/xC2kCdqGFEfDjMtIwxteqeDHJBi+ODQr89ldmK8ZdvB0K6zytAfhCRM+TIE7XL8dDpYLw7a5hHJlkzDwIM4oazRFAUWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OcW2Z0LA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aTRoDG54; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OcW2Z0LA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aTRoDG54"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772879237; x=1804415237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uTPvXE72tgJsMK/o0377JYrAfLLs7DpQB+yshDBVHg0=;
  b=OcW2Z0LAkmpHZSMrRU5nJ9oARoeS/TV+xKIn+q0vkuWhj88aWoQzH+ea
   3u1aREXVLYFIVixHkbz6Kn0GMf7fA6YzZQ2RaVuAINBzcnEmC+4pVBb5G
   pegWWyqYaBARTxU1mm/FUK+ofN+rjD/Dwq+ArR4C6+y+ikPzXjm2DehoJ
   xeqiF/JnRXrtFPQ2ftkczNLLLkwcPHzfiGK7E7laY2HrzdRB9mEp4uLVv
   HQYCPR6AlVEOau9v96l2QdB8VVU5lKflwH6waDwXOU4PVP/ljxkTZVbzk
   o8KZKwApA2iiyzPQXoug/o38Ju4MkhIkpt3Pf8xYQydLV26pjPcUPZttv
   Q==;
X-CSE-ConnectionGUID: 559GZ9iBSxWhl4cmNKjqAQ==
X-CSE-MsgGUID: IBOU4XiNQmC0qrh8SyqeWg==
X-IronPort-AV: E=Sophos;i="6.23,106,1770566400"; 
   d="scan'208";a="142081669"
Received: from mail-westus2azon11010054.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Mar 2026 18:27:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wYhwSvjHMUIO4oSlVNdcdE+TCkcvYbUh8YIYt3S/urV+xjrKtXoO1Y+nPerD1pWgJ4T50VftR1QUv6S27Oafn0ePlTV/602zrYZbFwkxFBMLhYUgUyRRl36Sp1In4Dl9uQDVKvw961AtKwAJ7F1FWXIGatkz0PrjlT/b51lfIHBSjbFWBg3OwB0GgXjcwH/G1SAjKXS/b+4PcWvIpY/v2pdBYkKqAPx+yzDnppyhxKUHFwDzyntxRRegtowBv1o6B5atp3oQh7QjNqsXAM/Kz3jDqgprPak2Eb3/yZlDytkiF5G3R5lJtIss+5AJt3j7/Y5uwiUMIKPacr7NTFYdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGtIF9rZXul195s8Fu+SC/djoMbVh1634ETl2M87hSk=;
 b=sMiw4VhW6oDDd6kyohQU9RqgcZjFOSrDBNupGhcf5XblkWlQ4w6qu4/X9DoASzEWjm95OZ1QuqaW/cSt3QUg9JP3HXqTnjplx0mwH86UN11AAHvtS9dZHlGEeDwtsS9IlTx5ISBdeLD7kA/eN8Wm5OCbPD7M7WaOuMKRqBi+PtThPcUF6Eswgc87VnNPhAnhh7EVGdGNtRXhcYQPoj2LsKhn5hAj2esGH4PvUDDifV2oNqJkMMgfVXmSHTse1aknM2DzXPb2JylM7cdik7tiNjU4PD0iISAeKOERjP4su4GnVxVnaj537GWJO60LOv+n4nBexOZM5muNkVk1Dd0KmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGtIF9rZXul195s8Fu+SC/djoMbVh1634ETl2M87hSk=;
 b=aTRoDG545jHxYyEt9W5B1ICo1/ntt6wfJUyZlt/zoWw8ONHoWTrKw9E0C6Zl8Rtcrf7fFWE/LmE/mUT/QL4N/Jp8fy9i+1NI3ZTvg5mCqbD8sYzN+qh37UVVFdQvaejWbfar8Ao9tFbrrD3vTwqUz1erJGjThVeG7Ex2bulGT7E=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SJ0PR04MB7600.namprd04.prod.outlook.com (2603:10b6:a03:32a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 10:27:08 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.016; Sat, 7 Mar 2026
 10:27:08 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 0/3] bcache: add initial test cases
Thread-Topic: [PATCH blktests v5 0/3] bcache: add initial test cases
Thread-Index: AQHcrLEM/A8AMNyjxUSi7B7tit7ezLWi4IOA
Date: Sat, 7 Mar 2026 10:27:08 +0000
Message-ID: <aav89rnofa3mpOM-@shinmob>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
In-Reply-To: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SJ0PR04MB7600:EE_
x-ms-office365-filtering-correlation-id: 98485972-dc1d-4288-b625-08de7c3415f1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 NO8IZOup/w+QkmOfG7RAWKhf+o1wiLZiWLoQ9yR4lPsT1V+HhX7p/0hCVbroh4pcx283w/xT3dFzaF78nXYPbNmsNXx3Ihj9Nj/jX4qKLzCR5fmPCxdsbsy/U+JLX54S37YADGhquON2uJAnvhaukmE2d/i9bMMohMqvcOkWOjXWsHXKoUvNlBzAEeph7AlGbOVD6AfTO+gUUWU2oBkxTFC2bwmkTGTHafYTFRIJIEVap4A6KoZD8eiCkVTDtbr7iAm6WcLniCEYbfQQGBAYQcAN0fcVmU15IpZL++eib7bmakugEM16gOwjcoDaYu4G24ljv/xbUmKSKKhBS8PAXigChqsJl2ZCXL3VbP0wNF4tnB6J5hZqq0JkY6xZfMZO+0PTQFqn2pOxc1xpT555o0i0qNqxjdk3aupeOOxrNHQWjnEeCRbKboeVmY0zcHqoshQpoxcFnHOEeF/hAiOYNVFs51L5Lhz771d+klnCItQ1ivCbXYG+AbyASIp8k95ujCjGinc+y8D+Ledtft3Nt2if/NvDVJl3SFnTy/dhxhEjLgUe1KX+2egPOoiDblf5eprt44BpLV2x9OjU0Zv2BoDKlwKiOVEoWTKSCLimMFFLcYCEcPtAi5AkLS4tg5D3KGEH7KvPk0CEqu5H29LN8QSphrUmhWzSEehAz9bzRKqGm+reus7XfFjhbs6Z3Vn+rXs4+wibNXeVwm+EU8Qf/urbtV5ta8jev12G3e2joYLHJ+TMyoyPZKGqsTitERI2p/7EzNurg7aprVjXSzfg+2zOj7+I2cF+gTHaJh3NZKk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?aF8AWrwWqebHMDIzkOWFVdzAFHmIY522+PjxjtaY89/xhC9+GebID7XusIzz?=
 =?us-ascii?Q?cVlZaiQjryDL/0Ic/GeAguHoPNEga26cmVjL0CDrD84PZW7IEaem2ZG9CbQ/?=
 =?us-ascii?Q?93MEYx1XJWfQ/S0lwCJ+eqXH/fmlH1Cb3Bw1rBcfaInQEX0Ntx4yqAh2e7dd?=
 =?us-ascii?Q?fPo5DZY+gOIDRub5q0bRXuZO6ERcuGXFqssahX5ZHn+ucBODQiV9GXGcCbmB?=
 =?us-ascii?Q?IdqI4R2BcBDiuwAOYimueU9qkLx+ZcqSiIMU+JGWWO2j4mLB0zG0NpP5EH+1?=
 =?us-ascii?Q?5wogaaMvNbluS9UNaQn2TgSjgqdWACtmq3i0WSKjAPTZvcWbodQpkk82yXpj?=
 =?us-ascii?Q?40iANGBTCCEAgGGfECQ5namTb5tNnAKXqhKckPmvpbHt3nFMFxi5625MR9re?=
 =?us-ascii?Q?Q7eKsKbdXfjSPGyY3jGd/qRC1cusiySSaDWsyPflJcWmbIiymzd1kmmSei19?=
 =?us-ascii?Q?FJ6X3iQaFQYfoumyniAfllignUSz51qQcMmXDWx4DNJY7DOeDFElmvppwcC+?=
 =?us-ascii?Q?lt3kT0uxjaiX+8uNYHtVrBS8tP4iw5XSBPCjimtILWTAgf1yIlxbRzJ8cZ9L?=
 =?us-ascii?Q?j7WlGANW6QM7K7IlCNx8eUnTwjzRLexwCLoPi9zoXOQkYhNMyhdW7ibmUpsG?=
 =?us-ascii?Q?ExZpuYDkkZvDKLj6BUuw4sP11XVC3Pmudz7DPPSGqIr0ouaJ5uVG1PdLdW2D?=
 =?us-ascii?Q?nCAjkfhxqyQO3CNDpPOm9qzf9wXEEdH/0n4niRKLP0+305ShtCx1I12tKJa2?=
 =?us-ascii?Q?LOpLfIDK2JdjB5jeB2LXBcMwpE6DIh1drkiNF0taRjo3Ki0UfjoiLQ9bietd?=
 =?us-ascii?Q?HF+zDxZIgr54D3wH3/8y7ydL9IrdHI2dD6S0wqb19Dc2RCq5LuLCL2GbCd7/?=
 =?us-ascii?Q?Cy3KRlVG0SCSTaTMXpvDEOX8QGYjOoS4GIVlhYOXxiuK4fD4EpSUJKOfpGO+?=
 =?us-ascii?Q?S8QiO2jEqS0MNiSE0zK6nhv6UqRr6o1vqJZ4hZdlkNEuCU0vCQfP23NnfTs8?=
 =?us-ascii?Q?0X5D+LJVuIzAm5WN0is3i9CbvmuPFYcB6zispzZZ1Sjr0ZfYMdBjHKDhNnlj?=
 =?us-ascii?Q?SPGnZ49Qwng8e0UMHjND+ZRkZd8qKVqXJ9HeOMeNRjtwmsCblyJGVXQT99xV?=
 =?us-ascii?Q?ksGcQRxvDaGFnfItvM/ADSaa51TF/8tnSB4dc9bbItgtFG4ja9t8S/cDFBDS?=
 =?us-ascii?Q?FYMIV/NOtxRQ49ZfwW0+r5LsiQqLM2xuZBfYRNqjuriZAm6Y41wVlFDadiq7?=
 =?us-ascii?Q?qWgUpa/UdCU3De+nfsJ/2Pe5iCvh5GJ4p8SEHGvOq0ZO6GPSb4IKjVHVl3L1?=
 =?us-ascii?Q?dX8/AahEejlM0volrHBO6SoQ/lRdVA+HQ62riBHvKrL8iUKRODj0QXNlOBva?=
 =?us-ascii?Q?5BSxxLPUXWkzb8L8VfYbmbrQ7xAtVbFIDa97YwwT2AwaXrDZAoDv/8I9k0tm?=
 =?us-ascii?Q?OYNAG4dpqhPF6f7gHhH76J9yuArHdDB4JPXI0n4z2ltO9xAe1eM+F2e8E1t5?=
 =?us-ascii?Q?qMHmIErQ2yrjHBXvRM0cQz7jpq9MQu/ozx80hTNZpmqlNjJge+yFo9iCMNXx?=
 =?us-ascii?Q?9/THRSK550K3alKlgcGBuhuvjEyvrhrfdC7frVdh9y4GrIO217Y4AjWzv26x?=
 =?us-ascii?Q?lAzZdK2B+yBRBBTR6pxQPoUZQVShG1sy4BuJdFsE9A4Y6SXh0M76yfMbe1NZ?=
 =?us-ascii?Q?oRk0xrmu/Ro+qyCsgvHDHd1HLk51V3s1fmlqLiofEIJIezSBacNS5ux9jNso?=
 =?us-ascii?Q?EXGRqxWKXv3mXYUUJTS66yeU5fNvvxo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5F4003D81954144B9152CEAB3B0F2E7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	hO2WQ/7V7pE/acF6q+VHhcKq+QyV5VQ+hvGkFF6nZ8fNuwXxHywUNQzxPxlqjeKhA+in1ut8JrWI4i40t+zUW/zxmSBWwLdVxK3NFJiHaUFH4x9w+9EzmSOAUVhwEN/O7OlrbRogXzbD93hXa/EQ9TerKGM/o8TOCBoyZj+DR9ge7dQFq1Pvnny/2uABVObFr6aPqhrHFBJdnXjKjuJIJgkZeGCztdtEIkvren7dlEXvrzpgoJ1lGqzVPsnWLO5KyZlroa+2i/q4kagwochNXL0GhIJtikdo4HtgtBKxdoWLajwAUOFOpU8r7IHMyHXl+gR6EVYCbeS2Hc2lRR8BrA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MYcqVcGOgPKrlNZPmovzpoGXTWUApfjpoFLz1rJ1J/JzUvwrNMSswys7bN/sFZ79WMX4HX4qycbnLTERK1UuQ8kNMidL09T6nmPKp/ZmzbxgUnKhmNDPsbD6MGYOBJWrtAQU9LvUH+keRWKXgMQmjQqmhfxpPZWNN4kb+sRlTEirRcUKB8fFecnFoqq/VTSCvjQ5Utj8SFdk5qbLkQ4Uyf16f1XfmGFUshDfoxbZ+yYmQD9VRKiQjmwtiXyFK5+pJHVssENLpEeivr3KnrLhG1+9C5/Oqpyi3qs3si3E2CO8xJn9+YgXS97pqiNREwIWnu1oM9kN1nOyr95EB0qeppqCK1WdPRrZLZWuzQzozD/HFS2ZYWcuOVqeKRoMxUauZWt5PEPMxgpALh+2j2wt+WBZTzxlhR90IZJK6VM5nRi889293TtlxOhOaQSGyYgp0LFdknP1sVLwO+5U1Ev8RRp1FHy9XKtNyXZHKIrqHrIeWD4z/FxoYNaufANbnPwmhXKh/P1JO9c6QZSkl9oi2DGoBazt2iDuIQ8Ak/ejLadu1gJQoYGb9//Y36WVo+JVhoXA8W4aFL3OPKP6Z3wQEpe6eLFbrtwjBMvMNUiaJ3coxrSjiCuqeb1LsRaWJiy6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98485972-dc1d-4288-b625-08de7c3415f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2026 10:27:08.0886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXnEklxEnH5GPgwqY8845qLl3cSaMEYj9XlU/kvOd6tEQPEDSBZ3nJfhXKax+jyfEe7tYLnvPgiINcJme39FeXCjivIHjnHrVpt5JSojiuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7600

On Mar 05, 2026 / 16:01, Daniel Wagner wrote:
> I've addressed all comments from Shinichiro.=20
>=20
> bcache/002 is not using iostat anymore, instead it reads directly from sy=
sfs.
> Also updated this tests according Stephen's feedback. I didn't test yet w=
ith an
> older version.
>=20
> Unfortunatly, I was not able to reproduce the "nvme?n1" file in my setup =
with:
>=20
>   TEST_CASE_DEV_ARRAY[bcache/*]=3D"/dev/nvme0n1 /dev/vdb /dev/vdc"
>   TEST_CASE_DEV_ARRAY[bcache/*]=3D"/dev/nvme0n1 /dev/vdb /dev/vdc /dev/nv=
me1n1"
>=20
> Not sure where this is coming from.
>=20
> Cheers,
> Daniel
> =20
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Stephen Zhang <starzhangzsd@gmail.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Coly Li <colyli@fnnas.com>
> Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
> Cc: linux-block@vger.kernel.org
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

Daniel, thank you for this effot. FYI, I applied the 1st (with my fix) and =
the
3rd patch. Let's do some more effort to confirm the value of the 2nd patch.=
