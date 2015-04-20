ALTER TABLE `Management`.`distribution` 
ADD COLUMN `last_successful_transfer` DATETIME NOT NULL AFTER `last_updated`;

