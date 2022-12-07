/* Populate database with sample data. */
INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
('Charmander', '2020-02-08', 0, false, -11),
('Plantmon', '2021-11-15', 2, true, -5.7),
('Squirtle', '1993-04-02', 3, false, -12.13),
('Angemon', '2005-06-12', 1, true, -45),
('Boarmon', '2005-06-07', 7, true, 20.4),
('Blossom', '1998-10-13', 3, true, 17),
('Ditto', '2022-05-14', 4, true, 22);


--- dummy data to insert into owners table
INSERT INTO owners(full_name, age)
VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);


--- dummy data to insert into species table
INSERT INTO species(name)
VALUES
('Pokemon'),
('Digimon');

/* ===== Modifying inserted animals so it includes the species_id value:  */
-- 1) If the name ends in "mon" it will be Digimon represented by id 2 in species table
UPDATE animals SET species_id = 2 WHERE name LIKE '%mon';

-- 2) All other animals are Pokemon represented by id 1 in species table
UPDATE animals SET species_id = 1 WHERE species_id IS NULL;



/* ====== Modifying inserted animals to include owner information (owner_id): */
-- 1) Sam Smith owns Agumon
UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';

--2) Jennifer Orwell owns Gabumon and Pikachu
UPDATE animals SET owner_id = 2 WHERE name = 'Gabumon' OR name = 'Pikachu';

--3) Bob owns Devimon and Plantmon
UPDATE animals SET owner_id = 3 WHERE name = 'Devimon' OR name = 'Plantmon';

--4) Melody Pond owns Charmander, Squirtle, and Blossom
UPDATE animals SET owner_id = 4 WHERE name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom';

--5) Dean Winchester owns Angemon and Boarmon
UPDATE animals SET owner_id = 5 WHERE name = 'Angemon' OR name = 'Boarmon';