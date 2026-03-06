Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E38134FF47;
	Fri,  6 Mar 2026 12:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772799321; cv=fail; b=TNMBXt4YiAYXQLvOgu2gBBYJxCgZ3XEgmtqqmGd79nJuAhTxdXHDnyCJW6cbad+injo4W9NOCoH5ndgGEJrpC/x4kFnfsmqQMkUo6RVO+NJxtMaSYQUfSpfHcMpM3xGhqTqVRt7MtPt+x4yAi2W9ASlWv/orwOx5VaSL43baBNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772799321; c=relaxed/simple;
	bh=Zd+vdljluW8gd8hR4d6Bre3/SFB360pPnVv6fOciHvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UzgJj5XvU24r1p9STmRPt5Dg6gs2eY785/raLACcRuXKdVUUIT4RRpCv2KlV4F0nuRypD2co3Nc2qIorx4ayJ8s+5VWEt0F+nnBFvr9gBspTOZSMKqVlRyyWwD3tP20+fKbQ2X9VveC9nHU7yR2S7SWpZOZ+DwlSMv0qJchq72U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aWZEukdY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=K25MEKxw; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aWZEukdY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="K25MEKxw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772799320; x=1804335320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zd+vdljluW8gd8hR4d6Bre3/SFB360pPnVv6fOciHvM=;
  b=aWZEukdYhgHQn9AEw10sINjLtaLokKCF0np8aG3ZL+jTljo/Z1bHzyBp
   R9hurKK0xrkrlx3Y51igWjyr4wTRcJrUl4EFdJ84gIaa78RsD6bnRlWxy
   V3aom8quZjzYAckUUBWD2IxNQHXcOAnyRTIDCoSs3otaIdY5hu//luzZz
   ubLG86q0+0rFH0ZyNzdO+dH1sDLljKZglX1k5hFPhtgPO2bT/N68wHJ5Z
   O49vf8yu2FWFqWPmmLsMfuoIf5/aXM9rJhn4GYxzRy7X/Y+zjl0dLSKE8
   X9oRTDnIVsnNqiEzG5V6WKU7wkElH5PnF6BtzC1zmBUXKV0x0YbLy0My5
   A==;
X-CSE-ConnectionGUID: tsxd1O5eQr6mtrhVo+F7iw==
X-CSE-MsgGUID: qSzduiTBR+yWHfA98B2dKw==
X-IronPort-AV: E=Sophos;i="6.23,104,1770566400"; 
   d="scan'208";a="138411874"
Received: from mail-southcentralusazon11012054.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2026 20:15:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBDYwpn26sbav3vEbgRoMdbgMyX+DzEe//iADpGShgLitl+Jo+d6NAb8leYdLNMqOrxnJ8HzoRRujTx0GjjQSMI5PNUXLjqqby8ou6jStmmuWW99HN63icRjif6IIReuZp+LbW+IzwPaQpZHCjbrMPhB15snQt9XYkZSJ2MKaEPyzKGW6JV+xeIqKmJNf/essDAY+z1rIu4OycvpG709R3pTWpLpce5ry53Q5dAbeEp9I5J8tTscKkfEDCXhJNLkwrSINqcKZ2flSynKvWEDejjG60WO/l5kCE5OsKwunavukk1kpRyzS2qikN7MVsrlPOxO/EpmW9LwPpBHvPSmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJbdbKdz3Ocgjjhj1ibqANi4s1LG501Wj9um0yD6ShY=;
 b=i1z7dmeAGDo1gIP4BR7v/nUDwm//hW+ydwt2+yYTU8dyrCoyYPNQqonE9pswovw7O0J+h5jcGOXejUfULnXM32P8au/6bVtxnjkoZ5H7XU8YE+ZYZ2rA6olhuHfv0y6MTQL5iL+1BPJ3wOS5Wt9iJS/TZ+SmbgVFwzSHzmrNvnFKWU7EU22PNivI9DvsPvTBuO4XTNpVUV+lPkcEGk7+GzfTw005d82ABN2/J2JfHT90Zk2WRutQGLz+0OLCNHZY1zKD/TEdZVYQ6YnbiZg2dD9mLq1wl+atidyq+2xnKq6tUuKWBthbtj+yy4B9ysJrfAsKZuTQp9As4eq7sHgKeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJbdbKdz3Ocgjjhj1ibqANi4s1LG501Wj9um0yD6ShY=;
 b=K25MEKxw18zWFOr+m5dqJZHzuffR9Kc2WUR/m/mgn0n+qNan6DGB3C71HQMDc82OgNCG1iPdB5WJXSIppYHQouYbg5X59ontmx5fgGU191bDnkHYbiN5AXQHu5buWpQbv4hyZED3kwLqiHOAF2oUfHt+3tMa2mLRXxCrMpkTRyY=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH0PR04MB8035.namprd04.prod.outlook.com (2603:10b6:610:fb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.19; Fri, 6 Mar
 2026 12:15:11 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 12:15:11 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 1/3] bcache: add bcache/001
Thread-Topic: [PATCH blktests v5 1/3] bcache: add bcache/001
Thread-Index: AQHcrLERpi7CBqV8rE+bxIIqScMSerWhbF2A
Date: Fri, 6 Mar 2026 12:15:10 +0000
Message-ID: <aarDdfJPu1NBuuvM@shinmob>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-1-04cd4c9080d7@suse.de>
In-Reply-To: <20260305-bcache-v5-1-04cd4c9080d7@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH0PR04MB8035:EE_
x-ms-office365-filtering-correlation-id: 82f6068c-ae44-4120-1308-08de7b7a03ce
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 wgLbgzgKf1PJJOvUkMSoOH/bShdgRIMTMcTijr/XJKHuuSqkG7Cv952QHD+bcnZJfxNgzqiNr2rd2dssNkN30TxpaLylin7gzibjxEZoWkTt5yRJtwQmlqdgxqBB9IS5MTHl8GZqiYBqfl9+wC1bYe7fo59NjJsj1+RNjJu2Y5lMeISQbFJMkb1GlUk9fxD0fhvR6NnXXKy/N4AzLpq5GTqJVCb5kP/G8mI6XQlcvK1woxNJuoPKQwQ3RjgMD2LyFwIIGt0kw+u2goNjBN+0GhzdD0CKkQQszGcJ/KfLEJSwu965Ja1C9H5iQTMHOWEiTx0GrNyfk+PZIRkou6xwsuToDrEDijVPQI7hgT16Jxsm00eiafQU8a2meGMMhISleb6bfve/vxFGDRLbTN9N8Zh6r4OB+ahBrEhRTc5Soyw5pPwE6ssr5o8KwX3d1tLkzjC4ViyUBnXDzakzxgBxjRaN1CC3cTsArxqpymqkaGWuADi+SAlOAV84x1FIILmaBmuAZpCvo2OFC34oc+EfCGvaEEN83HPXPcfoDQVvt041N6l5hl5zwStxjb4MQE74fIP3DXAdkfZu0RGPJjKzAJv5XeUmFz7s60NFag1rgpiPyEFxCRGDOAe+1QutfEhIwJLy1CKfk/le8q53C64iFHb7jbln0nn794n8TkGNaNusRKEQLMyf2Q6MHii2kRH52JlRy2cNO1TInNs9SVfWhQmyxfdruxtT3o9OYTxfLvI5fS07QXdIO6sZS4qxUF6Ne5TLiLTieW8csVRjjWpzGjPTt4SHRCTb46hzeWFGCc4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ov7vCO6EfeSyzpHSUiAvyLaW4s51to5UuXmbdG5URG0ivnrtl4Zr+vITGsmy?=
 =?us-ascii?Q?QlHt3CoGF2ArbYUCwJXcJktwCvSOJOXp3ex5jcVkProZAWHqsz53etBPfF+C?=
 =?us-ascii?Q?ql4Qduc+Fhlx6CSxa3mhXxukzPO1vl8NQWUZCJx/Q0kz6eAoE3qI2ykvV4ok?=
 =?us-ascii?Q?x5HDqhC6PPn7Dk3KpPpipweCQuJAwdE1vAlmyCcgHzmUBqNpNv/utUxAWm+P?=
 =?us-ascii?Q?wkWLXGAOjbs7C00HnJB287G3ltKOuSNcj7AED5CsMWXq1fefbmHcwSWiWDdx?=
 =?us-ascii?Q?0kP9hAxt7hiZJNlndLpOpHFlCWTPHzfNj+m8ZA/7VAUtVluM+r4oe0EDrHvB?=
 =?us-ascii?Q?zTY0fSM7DSwyCsbI7r7/v1us5OTwXu8J2FzOUp8dJfRfAKzeVr1QeefF16h1?=
 =?us-ascii?Q?YMEuj186xr5XUBMkA8f4OHFTXzjzCt1tvNLRqVVtVnsF3PR2cNKTfoqxuYiL?=
 =?us-ascii?Q?4azuyA/FnKQ3QqKQcfBpe6Cpp5Kt+vMcbKgdsAMqAA5Rij/RXEHGSNybOs7n?=
 =?us-ascii?Q?EYDDuH6jFx/ZsTUhPv9/swmaY0mNleCCT4JjDTuZfdiR4jsVHYEiDYqCVFGn?=
 =?us-ascii?Q?LCNWnddadmqbx3Gsa1XsF21x2AUjCb7oYiasV7BfVSnPWRtoX9Y78cj6dBb5?=
 =?us-ascii?Q?/ciTMQBpQIt7UqNVz9Je7r9G+47W4G0PVse/2Kc9gCNu8qJmbq6DwLmHpKBD?=
 =?us-ascii?Q?f8wEvjhEQBeV+gb8ogiJ1JRpz38nAb2R2TW46NmNwwpilASBdtWzHvho8p/X?=
 =?us-ascii?Q?P1VJ/t4+FNI8x06sGEgKtE31SYx7gCCHz6D6PXvFCoJrTWdD6bdarNAjeIvs?=
 =?us-ascii?Q?URo6bgPME2B2vhRCFbGAq8ECMzNEg8yB0iiXtH7FdmyIxUID5jve8u/t18J5?=
 =?us-ascii?Q?4VsOvDseB2Fzk1R8iJeT/wH3VWIDZUoO/pmop7ncyy9PWzMPIo8mULQhtTuf?=
 =?us-ascii?Q?jk3SRyxK/B6le4CqIjGGoeP8k9Ru34HsXmdpV+BZf6ohbSnm2CV5IBxP0uha?=
 =?us-ascii?Q?dx+kNhmqOWusuXpKHsuR9kK/2u2bMjkbW9fzyJvguQUrCCLJvcImmnHaRQfD?=
 =?us-ascii?Q?TT1paPAAMGbUPfTe62s8hsHzdbfaXZEuU+0JXFRqvhUg/PNxVfy4vGjmFQXg?=
 =?us-ascii?Q?16AyCYxoo5VjligURwUW8wkg5odTQz8nDNiBMoOu2B4cdwgv5GUT+38l7S7c?=
 =?us-ascii?Q?MsDEf3kYo9cGj9MSmp79l4a8CBTUksbvjoZjrRIfIoPdU44XHpITQgJsstRy?=
 =?us-ascii?Q?WhtZIjXrCKyQP6qHXd5mGSpoKHtnsUUymHbVmt8MzJzrv7+7oJcG3jCl2ARY?=
 =?us-ascii?Q?k4TROEugjnAdy1VjbtXoOvTJlJ5gOEmHvBZIrVMs/OMyRtQrMxpWkSkm2ccC?=
 =?us-ascii?Q?/HCxymnCU9V6PccQEC9JvyHGD7kZTNesBPZfCPxyD6MxujwLjaU60Nbl/CfS?=
 =?us-ascii?Q?teLl88hCLrzh5+bpYQZlto0MJ2esn8k/MEaXrTObnHNSAsU0JywN7TUkdZjm?=
 =?us-ascii?Q?nKtCPJ56SPcW7maingBXao9SDheI03vRYKM554Ez868J/IbKt3kowtvl0TT/?=
 =?us-ascii?Q?uev5tTpnRYpNO0Ro5ie1vpQ5CSY4wyc65DbIeDAJo1+rF0E/V2br0qOn2i3s?=
 =?us-ascii?Q?PQH3BSVV4LhPb0+OM0JJM87WCaHSNmrombFabHOZyEdrDjp5x1k90qgcYsgf?=
 =?us-ascii?Q?1ie1zIliB9q737l0CEohHSjwM6SyHgD1ZhYQTzPhnqeeErRXc1NFV4xv0uPJ?=
 =?us-ascii?Q?uEJXkfJdNuA0vjpwOaJ8RJ8OyekVizU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C58EFA379BB4D47BFB77CC03D975D6F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	UArHK4aXva7XocHVsj86qBRL8ME9+EM0bW3m/bHLoqGJ2H84+BGs8eipsmi0lP7t0k3Jr8zdZl1Unr1YOXqwkh9rnxKflgF2iHsiApRu6Ybakw4ZjbXlysOyzwW2pGH9br6kVoMY3u3pvwofej90CjcK80Bwi7lVzy5WWKhvXLj53axBZgvgkqgZSsW+UYzMPkqk8IF/Z+3g68eW1ruP74ciTDwxa0TMvDR4KvvgDk0lIJoyw/rPoEUb0dmF2iSbgopt0oHUbVcwLZF1Kg+LcAGz2Y+jTKqutm8mllzeepObZSGNh2VUo1ZyhJsfnJgPHKq3rGB6V2kWz2jGKPs5ug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+IDcZlW8FnyMr84D5tikc6PWDeEZpar7qkakbt/iSZqpGfsFhPqzkU1haR/dEk+41BMO5/lTfL6Y62EfwQ0jopo88ebB22wdlybOs9GcWJIgNSatRV80E2AjIglg8P/JHsDL8C5V7VYPe5kA+XXprzaNXMJe2Bk2NFeJiNj1FK69HIUkgTuWyymMGyXrWsD1j4gvOX7qGg7NrHHuAomilENgtLbIDBFjCLiLCfrRpX3yx42viRko0rBfyQwNWKld2Dw+cpP/jvEpJrc4p5iPLZDbvJjnw1OPa0u5uW6Xu95owkNqxQ4x7awui/PrGS9GKk4/qeQF47QA4Xa1lpiTOhYmLqXgVyr1Qw1+dTj1PKgeF0ySX7CH1b7Gz20i0c2vfTx+EHDYr/zCgcsjZmWan5M3LDlbrl5qZV1V+te21K+wK/ikMdk0h5sIxn52mVT1DKopIrPiVbxE6UNKgi3/B0HHfoOUqX05xzdtD7Q3/k6gxUxbBUOA/dNAC+vNp9a3aPrp0F+PIuXFGCYVvlhdUgCWpK6rYk0MLuMG7Z10en46EKAeubL+u/1cQpePS9y+mzMqzUilhU1y3wxTDKPDp1EWC5RGgzgeQzk8Eh3BH3jVe4hSWHlYn4opD5+Kxd4A
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f6068c-ae44-4120-1308-08de7b7a03ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 12:15:11.3134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOynYXr3827E0mr1XG0zoFw3kI/zUZ6e1remNbTuikkcOVY4WRHHBG+tdWssPAlqk0beQEYFqbyb6qNJxgAOqoILEeBD31YUx9Ojdkej7bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8035

On Mar 05, 2026 / 16:01, Daniel Wagner wrote:
> So far we are missing tests for bcache. Besides a relative simple
> setup/teardown tests add also the corresponding infrastructure. More
> tests are to be expected to depend on this.
>=20
> _create_bcache/_remove_bcache are tracking the resources and if anything
> is missing it will complain.
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  tests/bcache/001     |  44 ++++++
>  tests/bcache/001.out |   3 +
>  tests/bcache/rc      | 377 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 424 insertions(+)
>=20
> diff --git a/tests/bcache/001 b/tests/bcache/001
> new file mode 100755
> index 000000000000..64d5d45d9e6e
> --- /dev/null
> +++ b/tests/bcache/001
[...]
> +_create_bcache() {
> +	local -a cdevs=3D()
> +	local -a bdevs=3D()
> +	local -a ARGS=3D()
> +	local -a created_devs=3D()
> +	local bucket_size=3D"64k"
> +	local block_size=3D"4k"

[...]

> +	# add /dev prefix to device names
> +	cdevs=3D( "${cdevs[@]/#/\/dev\/}" )
> +	bdevs=3D( "${bdevs[@]/#/\/dev\/}" )

Here, /dev/ prefix is added to arguments of _bcache_wipe_devs() call below.

> +
> +	# make-bcache expects empty/cleared devices
> +	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"

[...]

> +_remove_bcache() {
> +	local -a cdevs=3D()
> +	local -a bdevs=3D()
> +	local -a csets=3D()
> +	local -a bcache_devs=3D()
> +	local uuid

[...]

> +	local timeout
> +	for cset in "${csets[@]}"; do
> +		timeout=3D0
> +		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
> +			sleep 0.5
> +			(( timeout++ ))
> +		done
> +	done

However, /dev prefix is not added here for the _bcache_wipe_devs() call bel=
ow. I
added the hunk below, then observed the nvme?n1 files are no longer created=
 in
my environment.

       # add /dev prefix to device names
       cdevs=3D( "${cdevs[@]/#/\/dev\/}" )
       bdevs=3D( "${bdevs[@]/#/\/dev\/}" )

Other than this, this patch looks good to me. If you are okay with it, I ca=
n
fold-in the change above when I apply this patch.

> +
> +	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
> +}=
