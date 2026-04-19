# Basic Usage

```dart
ExampleConnector.instance.CreateUser(createUserVariables).execute();
ExampleConnector.instance.GetUser(getUserVariables).execute();
ExampleConnector.instance.ListAllUnits().execute();
ExampleConnector.instance.GetUnitByCode(getUnitByCodeVariables).execute();
ExampleConnector.instance.CreateUnit(createUnitVariables).execute();
ExampleConnector.instance.ListEnrolledUnits(listEnrolledUnitsVariables).execute();
ExampleConnector.instance.EnrollInUnit(enrollInUnitVariables).execute();
ExampleConnector.instance.DropUnit(dropUnitVariables).execute();
ExampleConnector.instance.ListTasksByUser(listTasksByUserVariables).execute();
ExampleConnector.instance.ListTasksByUnit(listTasksByUnitVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.CreateTask({ ... })
.description(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

