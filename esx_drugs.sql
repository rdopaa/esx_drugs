USE `es_extended`;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('cannabis', 'Cannabis', 3, 0, 1),
	('marijuana', 'Marijuana', 2, 0, 1),
	('meth_raw', 'Metanfetamina Cruda', 3, 0, 1),
	('meth', 'Metanfetamina', 2, 0, 1),
	('heroin_raw', 'Heroína Sin Procesar', 3, 0, 1),
	('heroin', 'Heroína', 2, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weed_processing', 'Licencia de Procesamiento de Marihuana'),
	('meth_processing', 'Licencia de Procesamiento de Metanfetamina'),
	('heroin_processing', 'Licencia de Procesamiento de Heroína')
;
