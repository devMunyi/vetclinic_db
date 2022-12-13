/* Database schema to keep the structure of entire database. */
CREATE TABLE animals(
  id SERIAL,
  name VARCHAR(50),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  species_id INT REFERENCES species(id),
  owner_id INT REFERENCES owners(id),
  PRIMARY KEY(id)
);

CREATE TABLE species(
  id SERIAL,
  name VARCHAR(100),
  PRIMARY KEY(id)
);

CREATE TABLE owners(
  id SERIAL,
  full_name VARCHAR(100),
  age INT,
  PRIMARY KEY(id)
);

CREATE TABLE vets(
  id SERIAL,
  name VARCHAR(100),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

CREATE TABLE specializations(
  id SERIAL,
  species_id INT REFERENCES species(id),
  vet_id INT REFERENCES vets(id),
  PRIMARY KEY(id)
);

CREATE TABLE visits(
  id SERIAL,
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE,
  PRIMARY KEY(id)
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);


-- create an index on animal_id column in visits table
CREATE INDEX animals_id_index ON visits(animal_id); 

-- create an index on vet_id column in visits table
CREATE INDEX vets_id_index ON visits(vet_id);

-- create an index on email column in owners table
CREATE INDEX owners_email_index ON owners(email);
