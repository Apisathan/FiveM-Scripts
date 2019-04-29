Simple resource, der gemmer folks penge, inventory osv, når folk leaver og matcher når personen joiner igen, også sender den en besked på discord, hvis personen har fået et rollback med præcis hvad personen har mistet.

**Preview:**
<br/><img width='50%' src="https://i.gyazo.com/218267ac9e92ebc844bdbdfe72ad1535.png">

**Husk og lave følgende tabler:**
```
CREATE TABLE IF NOT EXISTS `logging` (
  `user_id` int(11) NOT NULL,
  `wallet` int(11) NOT NULL,
  `bank` int(11) NOT NULL,
  `weapons` text NOT NULL,
  `inventory` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `logging_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```
```
CREATE TABLE IF NOT EXISTS `rollback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `before_wallet` int(11) NOT NULL,
  `after_wallet` int(11) NOT NULL,
  `before_bank` int(11) NOT NULL,
  `after_bank` int(11) NOT NULL,
  `before_weapons` text NOT NULL,
  `after_weapons` text NOT NULL,
  `before_inventory` text NOT NULL,
  `after_inventory` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13024 DEFAULT CHARSET=latin1;
```
