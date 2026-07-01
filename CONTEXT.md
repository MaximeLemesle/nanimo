# Nanimo

Emotional journal for pet owners: document shared moments, milestones, and health of each pet. This glossary pins the ubiquitous language of the domain. It is a glossary only — no implementation details.

## Language

**Souvenir (Event)**:
A journal entry documenting a moment in a pet's life — title, date, optional description, optional photos, linked to one or more pets. The user-facing word is "souvenir"; the code entity is `Event`.
_Avoid_: Memory, post, entry (in UI copy use "souvenir").

**Offline-first**:
In this project, offline-first means **reads are available offline** — the interface renders events, pets, and health info from the local cache without connectivity. It does **not** mean offline writes: creating, updating, or deleting data requires a live connection.
_Avoid_: Using "offline-first" to imply offline mutations.

**Pet–Event link**:
The many-to-many relationship between a pet and an event: one event can belong to several pets and one pet to several events. Persisted via the `pets_events` join.
_Avoid_: "owner", "attached pet".
