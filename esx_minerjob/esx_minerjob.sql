USE `gta5_gamemode_essential`;

INSERT INTO `jobs` (name, label)
VALUES
  ('miner', 'Mineur')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES
  ('miner',0,'employee','',500,'{}','{}')
;

INSERT INTO `items` (name, label) 
VALUES
 ('stone','Pierre'),
 ('washed_stone','Pierre Lavée'),
 ('copper','Cuivre'),
 ('iron','Fer'),
 ('gold','Or'),
 ('diamond','Diamant')
 ;
