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
SELECT * FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) 
FROM animals WHERE neutered = true OR neutered = false);

-- What is the minimum and maximum weight of each type of animal?
SELECT MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;



/*  ================= query multiple tables ============= */
-- What animals belong to Melody Pond? 
SELECT a.id, a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, o.full_name AS owner_name, a.owner_id 
FROM animals a JOIN owners o ON o.id = a.owner_id 
WHERE a.owner_id = 4;

-- List of all animals that are pokemon (their type is Pokemon)
SELECT a.id, a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, s.name AS species, a.species_id 
FROM animals a JOIN species s ON s.id = a.species_id 
WHERE a.species_id = 1;

-- List all owners and their animals, remember to include those that don't own any animal
SELECT o.id, o.full_name, o.age, a.name AS animal_name, a.id AS animal_id FROM owners o 
LEFT JOIN animals a ON a.owner_id = o.id;

-- How many animals are there per species?
SELECT COUNT(*) AS animal_count_per_species FROM animals a 
JOIN species s ON s.id = a.species_id GROUP BY a.species_id;

-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM species s JOIN animals a ON a.species_id = s.id 
JOIN owners o ON o.id = a.owner_id WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT * FROM animals a 
JOIN owners o ON o.id = a.owner_id 
WHERE escape_attempts = 0 AND o.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT o.full_name as owner_full_name, COUNT(a.name) AS Number_of_animals FROM owners o 
LEFT JOIN animals a ON o.id = a.owner_id GROUP BY owner_full_name ORDER BY Number_of_animals DESC;


/*  queries PART  */
-- Who was the last animal seen by William Tatcher?
SELECT a.name AS animal_name, vts.name AS vet_name, v.date_of_visit FROM visits v 
JOIN animals a ON a.id = v.animal_id 
JOIN vets vts ON vts.id = v.vet_id 
WHERE v.vet_id = 1 ORDER BY v.date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(*) FROM visits WHERE vet_id = 3;

-- List all vets and their specialties, including vets with no specialties
SELECT vts.id, vts.name as vet_name, vts.age, vts.date_of_graduation, s.name AS species_of_specialization FROM vets vts 
LEFT JOIN specializations sp ON sp.vet_id = vts.id 
LEFT JOIN species s ON s.id = sp.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vts.name AS vet_name, a.name AS animal_name FROM visits vst 
JOIN animals a ON a.id = vst.animal_id 
JOIN vets vts ON vts.id = vst.vet_id 
WHERE vst.vet_id = 3 AND vst.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name as animal_name, COUNT(vst.animal_id) AS Number_of_visits FROM visits vst 
LEFT JOIN animals a ON a.id = vst.animal_id 
GROUP BY animal_name ORDER BY Number_of_visits DESC LIMIT 1;

--Who was Maisy Smith's first visit?
SELECT animals.name AS animal_name, visits.date_of_visit FROM visits 
JOIN animals ON animals.id = visits.animal_id 
WHERE visits.vet_id = 2 ORDER BY visits.date_of_visit ASC LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT 
animals.name AS animal_name, 
animals.date_of_birth, animals.escape_attempts, 
animals.neutered, 
animals.weight_kg, 
vets.name AS vet_name, 
vets.age AS vet_age, 
vets.date_of_graduation AS vet_date_of_graduation, 
visits.date_of_visit 
FROM visits 
JOIN animals ON animals.id = visits.animal_id JOIN vets ON vets.id = visits.vet_id 
GROUP BY visits.animal_id, visits.vet_id, visits.date_of_visit, animals.id, vets.id 
ORDER BY date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(vi.animal_id) 
FROM visits vi
INNER JOIN vets ve ON vi.vet_id = ve.id 
INNER JOIN animals a ON a.id = vi.animal_id
INNER JOIN specializations sp ON sp.species_id = ve.id
WHERE sp.species_id != a.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS species_name, COUNT(vi.animal_id) AS visits
FROM visits vi
JOIN vets ve ON ve.id = vi.vet_id
JOIN animals a ON a.id = vi.animal_id
JOIN species s ON s.id = a.species_id
WHERE ve.name = 'Maisy Smith'
GROUP BY species_name
ORDER BY visits DESC LIMIT 1;


-- create an index on animal_id column in visits table
CREATE INDEX animals_id_index ON visits(animal_id); 

-- create an index on vet_id column in visits table
CREATE INDEX vets_id_index ON visits(vet_id);

-- create an index on email column in owners table
CREATE INDEX owners_email_index owners(email);
