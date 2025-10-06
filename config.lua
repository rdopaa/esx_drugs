Config = {}

Config.Locale = 'es'

Config.Delays = {
	WeedProcessing = 1000 * 10
	MethProcessing = 1000 * 10,
	HeroinProcessing = 1000 * 10
}

Config.DrugDealerItems = {
	marijuana = 1000,
	methamphetamine = 2500,
	heroin = 3500
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. Requires esx_license

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 15000},
	meth_processing = {label = _U('license_meth'), price = 25000},
	heroin_processing = {label = _U('license_heroin'), price = 35000}
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.