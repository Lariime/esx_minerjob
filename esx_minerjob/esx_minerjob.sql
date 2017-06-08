USE `gta5_gamemode_essential`;

INSERT INTO `jobs` (name, label)
VALUES
  ('miner', 'Mineur')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES
  ('miner',0,'employee','',500,'{"shoes":24,"helmet_1":0,"torso_1":56,"torso_2":0,"pants_1":36,"glasses_1":0,"pants_2":0,"arms":63,"helmet_2":0,"face":19,"decals_1":0,"skin":34,"glasses_2":0,"decals_2":0,"hair_2":0,"hair_1":2,"tshirt_1":59,"hair_color_2":0,"hair_color_1":5,"sex":0,"tshirt_2":1}','{"arms":72,"tshirt_1":36,"tshirt_2":1,"hair_color_2":0,"glasses":0,"torso_1":88,"helmet_1":0,"glasses_1":5,"skin":13,"glasses_2":0,"helmet_2":0,"sex":1,"hair_1":2,"pants_2":0,"decals_2":0,"pants_1":35,"decals_1":0,"torso_2":0,"face":6,"shoes":24,"hair_color_1":0,"hair_2":0}')
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
