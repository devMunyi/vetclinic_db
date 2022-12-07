/* Queries that provide answers to the questions from all projects. */
/* ====== TRANSACTION 1 ====== */
BEGIN TRANSACTION;

-- update
UPDATE animals SET species = 'unspecified';

--- Vefify records after update operation
SELECT * FROM animals;

-- ROLLBACK UPDATE 
ROLLBACK TRANSACTION;

-- Verify rollback operation
SELECT * FROM animals;



/* ===== TRANSACTION 2 ====== */
BEGIN TRANSACTION;

-- first update
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

-- second update
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

-- verify the two consecutive update operations are effective
SELECT * FROM animals;

-- commit the updates
COMMIT;


/* ===== TRANSACTION 3 ====== */
-- begin transaction
BEGIN TRANSACTION;

--- delete all records
DELETE FROM animals;

-- verify successful delete operation
SELECT * FROM animals;

-- rollback
ROLLBACK TRANSACTION;


/* ===== TRANSACTION 4 ====== */
-- begin transaction
BEGIN TRANSACTION;

-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the update transaction.
SAVEPOINT UPDATE_RECORDS_SP;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO UPDATE_RECORDS_SP;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- Commit transaction
COMMIT;



/* ANSWERS TO QUERIES ONLY  */
-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT * FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals WHERE neutered = true OR neutered = false);

-- What is the minimum and maximum weight of each type of animal?
SELECT MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;



/*  ================= query multiple tables ============= */
-- What animals belong to Melody Pond? 
SELECT a.id, a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, o.full_name AS owner_name, a.owner_id FROM animals a JOIN owners o ON o.id = a.owner_id WHERE a.owner_id = 4;

-- List of all animals that are pokemon (their type is Pokemon)
SELECT a.id, a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, s.name AS species, a.species_id FROM animals a JOIN species s ON s.id = a.species_id WHERE a.species_id = 1;

-- List all owners and their animals, remember to include those that don't own any animal
SELECT o.id, o.full_name, o.age, a.name AS animal_name, a.id AS animal_id FROM owners o LEFT JOIN animals a ON a.owner_id = o.id;

-- How many animals are there per species?
SELECT COUNT(*) AS animal_count_per_species FROM animals a JOIN species s ON s.id = a.species_id GROUP BY a.species_id;

-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM species s JOIN animals a ON a.species_id = s.id JOIN owners o ON o.id = a.owner_id WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT * FROM animals a JOIN owners o ON o.id = a.owner_id WHERE escape_attempts = 0 AND o.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT o.full_name as owner_full_name, COUNT(a.name) AS Number_of_animals FROM owners o LEFT JOIN animals a ON o.id = a.owner_id GROUP BY owner_full_name ORDER BY Number_of_animals DESC;
