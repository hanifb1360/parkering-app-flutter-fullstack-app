import '../models/person.dart';
import 'dart:async';
import '../objectbox.g.dart';

class PersonRepository {
  final Box<Person> personBox;

  PersonRepository(this.personBox);

  Future<List<Person>> getAll() async {
    try {
      return personBox.getAll();
    } catch (e) {
      throw Exception("Failed to fetch persons: $e");
    }
  }

  Future<Person?> getById(int id) async {
    try {
      return personBox.get(id);
    } catch (e) {
      throw Exception("Failed to fetch person by ID: $e");
    }
  }

  Future<Person?> findByPersonalNumber(String personalNumber) async {
    try {
      final query = personBox
          .query(Person_.personalNumber.equals(personalNumber))
          .build();
      final person = query.findFirst();
      query.close();
      return person;
    } catch (e) {
      throw Exception("Failed to fetch person by personal number: $e");
    }
  }

  Future<Person> create(Person person) async {
    try {
      // Let ObjectBox assign the ID automatically
      final newId = personBox.put(person);
      person.id = newId; // Update the person with the new ID
      return person;
    } catch (e) {
      throw Exception("Failed to create person: $e");
    }
  }

  Future<Person> update(int id, Person updatedPerson) async {
    try {
      final existingPerson = await getById(id);
      if (existingPerson != null) {
        updatedPerson.id = id;
        personBox.put(updatedPerson);
        return updatedPerson;
      } else {
        throw Exception("Person not found");
      }
    } catch (e) {
      throw Exception("Failed to update person: $e");
    }
  }

  Future<Person> delete(int id) async {
    try {
      final existingPerson = await getById(id);
      if (existingPerson != null) {
        personBox.remove(id);
        return existingPerson;
      } else {
        throw Exception("Person not found");
      }
    } catch (e) {
      throw Exception("Failed to delete person: $e");
    }
  }
}
