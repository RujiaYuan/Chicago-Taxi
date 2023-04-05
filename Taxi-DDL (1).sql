-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema taxi
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema taxi
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `taxi`;
CREATE SCHEMA IF NOT EXISTS `taxi` DEFAULT CHARACTER SET utf8 ;
USE `taxi` ;

-- -----------------------------------------------------
-- Table `taxi`.`dim_companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`dim_companies` (
  `idCompanies` INT NOT NULL,
  `company_name` VARCHAR(45) NULL,
  `company_type` VARCHAR(45) NULL,
  PRIMARY KEY (`idCompanies`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`dim_city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`dim_city` (
  `idcity` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  PRIMARY KEY (`idcity`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`dim_census_tract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`dim_census_tract` (
  `idcensus_tract` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`idcensus_tract`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`fact_trips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`fact_trips` (
  `idTrips` INT NOT NULL,
  `from_address` VARCHAR(45) NULL,
  `to_address` VARCHAR(45) NULL,
  `duration` FLOAT NULL,
  `distance` FLOAT NULL,
  `start_timestamp` DATETIME NULL,
  `end_timestamp` DATETIME NULL,
  `Companies_idCompanies` INT NOT NULL,
  `from_zip` INT NOT NULL,
  `to_zip` INT NOT NULL,
  `from_city_id` INT NOT NULL,
  `to_city_id` INT NOT NULL,
  `from_tract_id` INT NOT NULL,
  `to_tract_id` INT NOT NULL,
  PRIMARY KEY (`idTrips`, `Companies_idCompanies`, `from_zip`, `to_zip`, `from_city_id`, `to_city_id`, `from_tract_id`, `to_tract_id`),
  INDEX `fk_Trips_Companies1_idx` (`Companies_idCompanies` ASC) VISIBLE,
  INDEX `fk_Trips_city1_idx` (`to_city_id` ASC) VISIBLE,
  INDEX `fk_from_city_id_city1_idx` (`from_city_id` ASC) VISIBLE,
  INDEX `fk_Trips_census_tract1_idx` (`from_tract_id` ASC) VISIBLE,
  INDEX `fk_Trips_census_tract2_idx` (`to_tract_id` ASC) VISIBLE,
  CONSTRAINT `fk_Trips_Companies1`
    FOREIGN KEY (`Companies_idCompanies`)
    REFERENCES `taxi`.`dim_companies` (`idCompanies`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_city1`
    FOREIGN KEY (`to_city_id`)
    REFERENCES `taxi`.`dim_city` (`idcity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_from_city_id_city1`
    FOREIGN KEY (`from_city_id`)
    REFERENCES `taxi`.`dim_city` (`idcity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_census_tract1`
    FOREIGN KEY (`from_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Trips_census_tract2`
    FOREIGN KEY (`to_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`dim_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`dim_payments` (
  `idPayments` INT NOT NULL,
  `type` VARCHAR(45) NULL,
  `amount` FLOAT NULL,
  `trips_id` INT NOT NULL,
  PRIMARY KEY (`idPayments`),
  INDEX `fk_Payments_Trips1_idx` (`trips_id` ASC) VISIBLE,
  CONSTRAINT `fk_Payments_Trips1`
    FOREIGN KEY (`trips_id`)
    REFERENCES `taxi`.`fact_trips` (`idTrips`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`race`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`race` (
  `race_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`race_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`census_tract_has_race`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`census_tract_has_race` (
  `census_tract_id` INT NOT NULL,
  `race_id` INT NOT NULL,
  `percentage` FLOAT NULL,
  PRIMARY KEY (`census_tract_id`, `race_id`),
  INDEX `fk_census_tract_has_race_race1_idx` (`race_id` ASC) VISIBLE,
  INDEX `fk_census_tract_has_race_census_tract1_idx` (`census_tract_id` ASC) VISIBLE,
  CONSTRAINT `fk_census_tract_has_race_census_tract1`
    FOREIGN KEY (`census_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_census_tract_has_race_race1`
    FOREIGN KEY (`race_id`)
    REFERENCES `taxi`.`race` (`race_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`age_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`age_group` (
  `idage_group` INT NOT NULL,
  `group_name` VARCHAR(45) NULL,
  PRIMARY KEY (`idage_group`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`census_tract_has_age_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`census_tract_has_age_group` (
  `census_tract_id` INT NOT NULL,
  `age_group_id` INT NOT NULL,
  `percentage` FLOAT NULL,
  PRIMARY KEY (`census_tract_id`, `age_group_id`),
  INDEX `fk_census_tract_has_age_group_age_group1_idx` (`age_group_id` ASC) VISIBLE,
  INDEX `fk_census_tract_has_age_group_census_tract1_idx` (`census_tract_id` ASC) VISIBLE,
  CONSTRAINT `fk_census_tract_has_age_group_census_tract1`
    FOREIGN KEY (`census_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_census_tract_has_age_group_age_group1`
    FOREIGN KEY (`age_group_id`)
    REFERENCES `taxi`.`age_group` (`idage_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`gender`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`gender` (
  `gender_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`gender_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`census_tract_has_gender`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`census_tract_has_gender` (
  `census_tract_id` INT NOT NULL,
  `gender_gender_id` INT NOT NULL,
  PRIMARY KEY (`census_tract_id`, `gender_gender_id`),
  INDEX `fk_census_tract_has_gender_gender1_idx` (`gender_gender_id` ASC) VISIBLE,
  INDEX `fk_census_tract_has_gender_census_tract1_idx` (`census_tract_id` ASC) VISIBLE,
  CONSTRAINT `fk_census_tract_has_gender_census_tract1`
    FOREIGN KEY (`census_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_census_tract_has_gender_gender1`
    FOREIGN KEY (`gender_gender_id`)
    REFERENCES `taxi`.`gender` (`gender_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `taxi`.`dim_census_tract_has_gender`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `taxi`.`dim_census_tract_has_gender` (
  `census_tract_id` INT NOT NULL,
  `gender_id` INT NOT NULL,
  `percentage` FLOAT NULL,
  PRIMARY KEY (`census_tract_id`, `gender_id`),
  INDEX `fk_dim_census_tract_has_gender_gender1_idx` (`gender_id` ASC) VISIBLE,
  INDEX `fk_dim_census_tract_has_gender_dim_census_tract1_idx` (`census_tract_id` ASC) VISIBLE,
  CONSTRAINT `fk_dim_census_tract_has_gender_dim_census_tract1`
    FOREIGN KEY (`census_tract_id`)
    REFERENCES `taxi`.`dim_census_tract` (`idcensus_tract`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dim_census_tract_has_gender_gender1`
    FOREIGN KEY (`gender_id`)
    REFERENCES `taxi`.`gender` (`gender_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
