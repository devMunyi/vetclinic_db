/* Database schema to keep the structure of entire database. */

 ---  to a create a table named animals
CREATE TABLE IF NOT EXISTS animals(
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(100),
	date_of_birth DATE,
	escape_attempts INT,
	neutered BOOLEAN,
	weight_kg DECIMAL
);

 -- to add a new column named species to animals table
ALTER TABLE animals
ADD species VARCHAR(100);

-- to create a table named owners
CREATE TABLE IF NOT EXISTS owners(
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(255),
	age INT,
	PRIMARY KEY (id)
);


-- to create a table named species
CREATE TABLE IF NOT EXISTS species(
	id INT GENERATED ALWAYS AS IDENTITY, 
	name VARCHAR(255),
	PRIMARY KEY (id)
);


/* ===== further modifying animals table ===== */
-- 1) make id column a PRIMARY KEY
ALTER TABLE animals
ADD PRIMARY KEY (id);

-- 2) Remove column species
ALTER TABLE animals
DROP COLUMN species;

-- 3) Add column species_id which is a foreign key referencing species table
-- first add a species_id column
ALTER TABLE animals
ADD species_id INT;

-- make species_id column a foreign key
ALTER TABLE animals
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id)
REFERENCES species(id);

-- 4) Add column owner_id which is a foreign key referencing the owners table
-- first add owner_id column
ALTER TABLE animals
ADD owner_id INT;

-- second make owner_id column a foreign key
ALTER TABLE animals
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id)
REFERENCES owners(id);


/* ======= Vet clinic database: add vets table, visits and specialization join tables ========  */

-- to create a table named vets
CREATE TABLE IF NOT EXISTS vets(
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(200),
	age INT,
	date_of_graduation DATE,
	PRIMARY KEY (id)
);


-- to create a join table named 'specializations' for a many-to-many relationship between the tables species and vets
CREATE TABLE IF NOT EXISTS specializations(
	vet_id INT,
	species_id INT,
	PRIMARY KEY (vet_id, species_id),
	CONSTRAINT fk_vet_id FOREIGN KEY (vet_id) REFERENCES vets (id),
	CONSTRAINT fk_species_id FOREIGN KEY (species_id) REFERENCES species (id)
);


-- to create a join table named 'visits' for a many-to-many relationship between the tables animals and vets
CREATE TABLE IF NOT EXISTS visits(
	animal_id INT,
	vet_id INT,
	date_of_visit DATE,
	PRIMARY KEY (animal_id, vet_id, date_of_visit),
	CONSTRAINT fk_animal_id FOREIGN KEY (animal_id) REFERENCES animals (id),
	CONSTRAINT fk_vet_id FOREIGN KEY (vet_id) REFERENCES vets (id)
);