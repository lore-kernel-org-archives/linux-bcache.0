Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D87022F16E;
	Thu, 22 Jan 2026 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769069326; cv=fail; b=twjcJfqxW/WjqqTCPdfJ7TFDRkzQ9/Ywy8cW4TDumufWYcP5JYdqJ9hFu9qL0KgHgem7FKSuvvfnGStinZCxwmpRgp9ZX3sdvSfAfTvhtTnzkKWBlCvOKgQEcuBfXj19ToTeTu0H8AGFL27HDAeXv74XFInu0JdMQ3VNEBC2R5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769069326; c=relaxed/simple;
	bh=2yY/VtxEDQ/BSz6lQcwPhwOkbCi+iMxLhjTZ1AvJP0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rmqrqK9xU+iFgslDo87V1UpULf78jU/ijz5/35whxoBlg0iA6j1kON2ZbpQav3zFe52IXpGJPvgZymBY/nmXtANbpuqPI871FRcga3gmzdFT9LqHxT5UAgaYKU8r4a0+Tu6hOA1lMYW44l+3cs7OcLXj5QgVM2IiM38f1Gi9MF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S3reBPMs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=v4Q0l0U6; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S3reBPMs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="v4Q0l0U6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769069323; x=1800605323;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2yY/VtxEDQ/BSz6lQcwPhwOkbCi+iMxLhjTZ1AvJP0A=;
  b=S3reBPMsz1/ffJoobynxmrCAt3N2Ui3gqVrRctqiz4oi6XuUHRHwm8dg
   T8h0hLPOX12mCCS2UfaU+LSbpXZmTZyTVDvZQf5vgchRQ3m9bTan72Mbs
   NzViJ3eHprz57Gs5lHv2pPqe+ih4XpTSdxRZO1wCPx6nl5T5JhmuTOKkW
   8RieKZRq+d+jgaSAAdsMyBqOYUnNbJewbkVUXBsGOc2CyJa4ROzzw8YHS
   Gd+t261yBEHoKM8Lu7QftePKbZ0Vd32GVj+MEz1UJy/z2ZIy0e4S9iv+0
   s8bc/zNf9d3jd6wghMFVSWiAwvoDkUUOi/U2mcMuHSm7I+JRvx6oONoWI
   Q==;
X-CSE-ConnectionGUID: go7UoXX2TCO4Hrpk8Ah5rg==
X-CSE-MsgGUID: num8knOWQ2OcmsUaa2Q3nA==
X-IronPort-AV: E=Sophos;i="6.21,245,1763395200"; 
   d="scan'208";a="139938187"
Received: from mail-westusazon11010001.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jan 2026 16:08:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRH+GPZAN52GTHCi58/9Mpd+P70nm1K+fnmZPhdqFEEqPJWw/EwJiqPndjJQ2AvbY2K0fG2hP0MlOBYlueTu6403xH0m+2jMHu4U3zDMum8M79ijYkpjWq9FS8T3nj6JExUXA1Gk6T5RNmhGj4qbYH3sHCnwKg4PdxqAJvvnAz9ew70UBUdslWrRzmBeZWfAwozAJohzFRiTcLBpVf2tCa4wpkRPHuW+y65XYt9Vn00n34WYGJ+KIGLWWX8FnZ53bQd4Qt+98eh/i/+SN8VQQHjuU0kCwc/EtAwqGkH6sYnzXJRfeg68zhK9JlatoMH6FvyUljjIKCB0N/OjycIEcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kOI8RJ3aBJAcxzqXbhC7ncVAiVbHOAW3PCtYvJgUIY=;
 b=SNhDUBXeT/eRTnNDDBYiTZ2vsGvdqSJ+vwrT0Z9qkJr8hvzQ9ICH8EyQQTykpzKERy3J04eTuUEigY21/Ehd+DMWt3yg6YEeh66q0OALwRoxqh1RJsJ/S9D/iBdRABeKSFFH7acioBhtFQ123DxMmspYZl1IeT3bwdwCCrjtzP6A72d3LOVH3BSy+Ac4z3lF6XIMUe+mk4P7QSWlda6JTSMRWmVN6i33yzvAfifxAbbDeIlwoNFZEjqphPbmTppMUZKaM/VEDuoqMl7VWeLBlAd9Fm5Y3x74XhBKtsMvAdQXNM/Al/zJZpm2XcJB/rBq+sRLZIGm5RGYZ4PzoXdU2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kOI8RJ3aBJAcxzqXbhC7ncVAiVbHOAW3PCtYvJgUIY=;
 b=v4Q0l0U64Z0jIEJqC18lQF6ytTj7MiQNtropIZugIo2wa159MTVSvsBEoZnd3Y36vwp2C+9lNSb49QZ6NLFVFrYU/9/3jGfasJbuuEMTmQTzpfmQ4lwXkxcCCIOFaJoXtqdlfa4O/LlQWjX5xCI+0u6hXT94rH8nFDe0vv6DZEc=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH2PR04MB6982.namprd04.prod.outlook.com (2603:10b6:610:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.3; Thu, 22 Jan
 2026 08:08:36 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9564.001; Thu, 22 Jan 2026
 08:08:36 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v2 2/2] doc: document how to configure bcache
 tests
Thread-Topic: [PATCH blktests v2 2/2] doc: document how to configure bcache
 tests
Thread-Index: AQHciuNjAT5BzEfquECppbxv0RwT/LVd1tWA
Date: Thu, 22 Jan 2026 08:08:36 +0000
Message-ID: <aXHaP23d0ih-yLCH@shinmob>
References: <20260121-bcache-v2-0-b26af185e63a@suse.de>
 <20260121-bcache-v2-2-b26af185e63a@suse.de>
In-Reply-To: <20260121-bcache-v2-2-b26af185e63a@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH2PR04MB6982:EE_
x-ms-office365-filtering-correlation-id: a977013d-3156-4de3-64a6-08de598d7163
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hTWuMuFcAyhfS6xiSc5hGT81M/AgaYKvu5cekpJs9jMcEzOvM6omVQdi3y1A?=
 =?us-ascii?Q?Ukfxr+BYkT8JrpJH4MrrFlgiWuVO+2ofM64pIHDxj1po4wqcVsXaCTtElT+6?=
 =?us-ascii?Q?QTNro87HU1FBzMvKQpJyQQ8KChUmQjwgX34NTJk7yn3secwWCiT9ldI68749?=
 =?us-ascii?Q?MXlkUqtvqlmqSJOS5dfGc5PrEPMvAHh9I8qJn3rfujChqcUl+2yB1SA05feI?=
 =?us-ascii?Q?awax3XSxF0qaYkUoDf+xfWe+ZnRYUX9/WRZ7WS6t90TBvqo3R4wuCfTIlCQn?=
 =?us-ascii?Q?dfmHYcgv+wnqNYfoi7kygZikzW0QA2K6/1xYFnCyaUYwEFEY32cAMH+vgVYX?=
 =?us-ascii?Q?Odhnzru1n2yjhfBnh7rGEC/X0bEAFNulKvWJMEBX3fHC+nU8i6yhFaZCCTcx?=
 =?us-ascii?Q?yN54nzozwVNKdQBdF4Xsv0N1/qfsmHAjTClfvcHMnTsNv+m/T9Ml50dRd/cZ?=
 =?us-ascii?Q?dgsbp+LfCrYEQ9SLmPVOfzdwVViObxtKDc0+vubo2HnQCJ9zI9tYwpW3Y9LP?=
 =?us-ascii?Q?/Q0YUgiSK4Az8UEB3mkYoUjqR1pTV5nIKdrl6C1lpKrde6eLTlCiO7HP4BTj?=
 =?us-ascii?Q?Z3vClTW1Mf+7Ak5/doYOKi8SDJzERzFe7v+hQRlZXeUqK54gtfAp3Bos0ZfK?=
 =?us-ascii?Q?TZiN6ZPvst+8xo09LAqm/Mes0Z1lcTCCTGIzyK4CJEm+nMyPqQ1QV2n7c1SG?=
 =?us-ascii?Q?fJBF2XQyEj1OdVAsftZlsJpHnpvMcVORRZolb+tmSiRwu8Z/NBDp191Gco9G?=
 =?us-ascii?Q?K+L0k/X8v3Ot7aqeob3b8JH2eacpP1NbZD/o2f06De0IvTGT2ceUvPJ6uYhi?=
 =?us-ascii?Q?et7ogpoKBkWd1WyAcifB3MkniBaaabjSqJz6kSlVn7T7rm0/3Lwwpl7oHP50?=
 =?us-ascii?Q?uS7r+wWIaIys7j/lseA5JO2k02YZPjeHITcxuteAFnUAev+e5Ixm+Cp6lGyL?=
 =?us-ascii?Q?zanYfFGYJAFAOVDPNIoFwDSe2DnKg8l7vIFRMHGM9JiWQ7S02Uljk96VpOW3?=
 =?us-ascii?Q?kG79vNiLoecYId125sRSH6Pd69arABUgcrwSlCEz2Zjw4ZkwrbyItNt/F+8a?=
 =?us-ascii?Q?f7Ym2XFEmkm/0IDrd7E/48L63+dj84dGTFZ0SkOYUzrJkLBj4GQLq1NRTo67?=
 =?us-ascii?Q?NYX5sFzooznY8PpH4CTYCE9HK29delwD6P31DauSJpCHupbK6JGek3xDbOT7?=
 =?us-ascii?Q?Rd/Z+PSU8Ux2OFn/mgaxFN8UVj8ow2JQJiDMKbXR+nCaXGOxjqCO7+5MP39M?=
 =?us-ascii?Q?VUOVyFWoGOylaXQmEU8EBZAFAKWj7TNc4Ibt/YrQI52psqX02Gbbhidng9Om?=
 =?us-ascii?Q?yyIhd6KxxWjJ6ejoN9vrO7owFczf0hrSfxidxehh3qwESEbu4eqRGjh6ERhC?=
 =?us-ascii?Q?3Pr/KL1qdq0bv3PBxh8AogKIW+KNJQ7g30zlgAJM51OQD5ZBiroaHsGqzYGC?=
 =?us-ascii?Q?x8vIoiTpn1nSrZsR++qAczVxfi1lYeoC1pJy7BLAQugLuQT+LzNZIRMJd1ka?=
 =?us-ascii?Q?qai5khnrZHR/cER7NF5y6c5bCAv37zsgvyZBR1kL1jvjDsRjYlsRKf6Eh5pP?=
 =?us-ascii?Q?QmiNnXOPy92DBYmRRZMB415hrP9N1OaJ+boaduOlwC1/ZhPXrZtRLcF9Ia+u?=
 =?us-ascii?Q?hg7ubA1HQn9be7Gex0zr71o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cbpMyUB/A4VOMX1VU+JI6Lt7N6vYwkOyWWtCCXQ6SPzjXrTVdH2Q/4gNcx4Y?=
 =?us-ascii?Q?sWv9nCAUe65PM3I16hec3mshy+pYDOSFdKPE15YhQgS3XY511u+hNq/p2AYa?=
 =?us-ascii?Q?W1kV/g38jkR7P/YVSCG6g7sRNqBl0HSRc198Hq5zG/l8lQlIPV87B0eruI5a?=
 =?us-ascii?Q?uwxaITaKrvF8N9KCaV2eyOSJze0kA79idXN+TBQJwlnosV3o3FhcRxN+tXii?=
 =?us-ascii?Q?DZr0dZqlp9OFsH7/qKtWy0KxYa1FEo3IBgFgHp3LMuPf1GqaY4HGlQg9w+1s?=
 =?us-ascii?Q?frmyullnsGpCMksu5CooRfkAwiLcYRbHaB/uZke2WNpcToz8M6YFb7PLUXUN?=
 =?us-ascii?Q?nYVBwsGbfIUm0Kdi3XAiiVu5ZoOg4V9IRgw/qAL1Do2XZIwXafpTb9qvx72I?=
 =?us-ascii?Q?c3lbYbMQ8bsRViNUTeq3KxPOCXP3ksv+toGBmSae6wysUg1GW9tTe3lbmxmE?=
 =?us-ascii?Q?4J1jEsbbcd8YR2pBInmfay0DrWKLLUfAM07jHAh2BQ4vZ/BTZ08smRc/ndaQ?=
 =?us-ascii?Q?bGK2JHVgq23tJCZorAU/DofRg3TthY44oMXNlDXBBzG5HkAQvZpNgZUKy4oB?=
 =?us-ascii?Q?Zy3wSDkq/iitennfrCiL/k9+HpuITIwEDcUMO2Ilm6KYeMs24xCv+OxCx+oU?=
 =?us-ascii?Q?cSQ3fTXHxIktoiga5B61ZUsv9LEBBvgoD9go9T41RzHHqcdRK5rhKd68gx26?=
 =?us-ascii?Q?0rds7U/ZM+BB3Vc2RjNcX+FGtS+5nTAHu+5fMQifElLOA6QEK9/S+vJKPfCw?=
 =?us-ascii?Q?ndVrcbL79k0As9bm9YKoOqD+0tOLDM78wDdjBNU5raZ3xgboRRW5PLxZ3zKm?=
 =?us-ascii?Q?0PF6bcfjSYnXrVwmE8FgBjWqzshmwxv6BJDum5v5xiHz/IVf0jZmgDq6M6Qk?=
 =?us-ascii?Q?dq6orbfhjOpj30NXbDU1EZWh5+/2TSwqeUYQjWS4jWV2ZZlRlJcfaiJSzVqy?=
 =?us-ascii?Q?YjLf0llass//RwFJGb78+8+vjCMtK2fpwU4zvKxszI6e9vHqRW7nclkyC/Gc?=
 =?us-ascii?Q?GQXWGpAU00R/DURcV4FCcSos6BDBTlIJWWEEOXVTVAYSKsJ/JcktDSgT6reI?=
 =?us-ascii?Q?l/mBW4XPl1+XY4IZwCj+JbkCedSU03NxP2Bx5ymX6KF8UXwfpPPKMEVBDeks?=
 =?us-ascii?Q?XA70WMBnacDLKqdXRbyKgK7zP9/97O7iGT0VXu0IZsPg8O9Cci1FBgVMm0YY?=
 =?us-ascii?Q?iqmKsWS1G+nfGAeihmVx9NS3pvzMeB287nQAIo7vob9htUFfiqbwpUWaRoPp?=
 =?us-ascii?Q?VOU1UIg4WjWFe+qw0iOMj2Ir8wp7Zg3b7MvLMwVeHHs38zmtnxU1qCdCZNhf?=
 =?us-ascii?Q?bvxSJL+OfyGJefcBQoKCnvvA80zCCTaiWIcVy2b4D5l3D7nbno+HGr5uFuLI?=
 =?us-ascii?Q?88pFVA1iXEtQkEKo2XpjyjP1aGKPgChG96QJj58qcWR4LkNO+4m0pXSTCi/W?=
 =?us-ascii?Q?XO6PL/DerZZFlbtnPssii3+MHTk/Frp1sPYDg5UBYCL0h9SdqCThv/C4l8ir?=
 =?us-ascii?Q?2JMqhrIAIlS5Pqj8Zs4dFEF8TPLH/5xIZD5bbOOAzTc4ub+7CBrTm/jNx6Tq?=
 =?us-ascii?Q?hzN3CxqB1FwymI5o2IyQ/RudBe8mU9BIRpFgY3XhwV0tYyGp1Ia0K6luS3LK?=
 =?us-ascii?Q?gZSIEzNMJQku1qOhUXH9U4HOzd/3x3NJg7jhxYneq9Vrd+3JDIfwa+N0CqZ8?=
 =?us-ascii?Q?guGPA7+EGQVc4NNGLxS1fzy1fiZpGFWknMHAfoZQayNmLg6l4akfnddaOWmR?=
 =?us-ascii?Q?/kucpjfbPYQaSXJC7uvteqrh+MRlUrM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B534E9E0EDECA4C84629C69685CC4AC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RzE1VJM77AjwJqHskJ4YfFegl3yWYP7uLwdjjFXNRwL6C2B3k07Q3ySbZ0Lke4+bvUMn91Lcj+NRf4zGZkvjbfeej7c+aA7rU9cutd9G5aW9hpzNwadSGXRH9jEZWPBWy07iTPqhRLGpXkwrYJPe2x29ND+EOeB7CEH/zfxqqkqALPyQZgqX/q7aCRXadPZZl3bFIPmBqxNcbSvjRpYJQl/XoqKaWrYpfZxkpfccnj4ab8AT6mAUFcdi3hmVUM6r6zpulPpUsFB8MmVUP25hk54sJJRGXVvGx3LP3BnEzX3syrXAT+whp36PnLju8zKb2epdTlBQz8lgfVceJjM2lh88Unk/nwyISZqW+8jmiMbCxGFUnh/Qzio8pIGD2U6P8DB6AGORftlZF/T2bjn7ZLsLgTgLaoRqrovCaTtO5yION5GEis6livFSZ2q2eH3OCDMJdV6umc85rAU3X59pszcODgv2bJMQnoHdrcsOcHCUkex28MRMeL51NGJXpQFpZP6LLyQxlAdzClivlevzAd9Fj7vM3t3jvQVyWExTbKaX2Q0nEC4NzViGje3S4d3V4L35ejpCdK7DdWHkVn6DLnyEmXqLD/w22lDZCbKBKmTSNUkakEuYRZPCsJnE38yr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a977013d-3156-4de3-64a6-08de598d7163
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 08:08:36.0753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQ8z4axrQqMvklYaqiO0/7lzG5SrmRiqeCp668NSqEBw13NUFbxzlAQLIVQWqUaVydtMKagb4l/j7ppBi3FqgfVCQ35T5EWmBnOZBVyfaY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6982

On Jan 21, 2026 / 15:36, Daniel Wagner wrote:
> Add a bcache entry in running-tests which explains how to configure
> blktests for the bcache tests.
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  Documentation/running-tests.md | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/Documentation/running-tests.md b/Documentation/running-tests=
.md
> index f9da042bb3a0..c4abc6767cd0 100644
> --- a/Documentation/running-tests.md
> +++ b/Documentation/running-tests.md
> @@ -189,6 +189,22 @@ THROTL_BLKDEV_TYPES=3D"sdebug" ./check throtl/
>  THROTL_BLKDEV_TYPES=3D"nullb sdebug" ./check throtl/
>  ```
> =20
> +### bcache test configuration
> +
> +The bcache tests require multiple devices to run simultaneously. By defa=
ult,
> +blktests executes each test case iteratively for every individual device=
 listed
> +in TEST_DEVS. This standard behavior makes it impossible to pass a group=
 of
> +devices into a single test via TEST_DEVS.
> +
> +To solve this, the TEST_CASE_DEV_ARRAY was introduced. This allows for c=
ustom
> +device configurations on a per-test basis. For bcache tests, a minimum o=
f three
> +devices is required. Configuration Example
> +
> +Add the following to your configuration to define the devices used for a=
ll
> +bcache tests:

As you noted in the cover letter, TEST_CASE_DEV_ARRAY is already described =
in
running-tests.md. So I think this section can be some more concise. My quic=
k
rewrite is as follows. If it makes sense for you, please consider to pick i=
t up.


### Bcache test configuration

The bcache tests require multiple devices to run simultaneously. By default=
,
blktests run each test case for each device in TEST_DEVS. This behavior
prevents testing with multiple devices. The TEST_CASE_DEV_ARRAY resolves th=
is by
enabling multiple device configurations per test. Bcache tests need at
least three devices, which can be specified in your configuration as follow=
s:

> +
> +TEST_CASE_DEV_ARRAY[bcache/*]=3D"/dev/nvme0n1 /dev/vdb /dev/vdc"
> +
>  ### Normal user
> =20
>  To run test cases which require normal user privilege, prepare a user an=
d
>=20
> --=20
> 2.52.0
> =
