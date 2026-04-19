# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUser
#### Required Arguments
```dart
String uid = ...;
ExampleConnector.instance.getUser(
  uid: uid,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserData, GetUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUser(
  uid: uid,
);
GetUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;

final ref = ExampleConnector.instance.getUser(
  uid: uid,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListAllUnits
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listAllUnits().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListAllUnitsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listAllUnits();
ListAllUnitsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listAllUnits().ref();
ref.execute();

ref.subscribe(...);
```


### GetUnitByCode
#### Required Arguments
```dart
String code = ...;
ExampleConnector.instance.getUnitByCode(
  code: code,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUnitByCodeData, GetUnitByCodeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUnitByCode(
  code: code,
);
GetUnitByCodeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String code = ...;

final ref = ExampleConnector.instance.getUnitByCode(
  code: code,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListEnrolledUnits
#### Required Arguments
```dart
String studentId = ...;
ExampleConnector.instance.listEnrolledUnits(
  studentId: studentId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListEnrolledUnitsData, ListEnrolledUnitsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listEnrolledUnits(
  studentId: studentId,
);
ListEnrolledUnitsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String studentId = ...;

final ref = ExampleConnector.instance.listEnrolledUnits(
  studentId: studentId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListTasksByUser
#### Required Arguments
```dart
String assignedToId = ...;
ExampleConnector.instance.listTasksByUser(
  assignedToId: assignedToId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTasksByUserData, ListTasksByUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listTasksByUser(
  assignedToId: assignedToId,
);
ListTasksByUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String assignedToId = ...;

final ref = ExampleConnector.instance.listTasksByUser(
  assignedToId: assignedToId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListTasksByUnit
#### Required Arguments
```dart
String unitId = ...;
String assignedToId = ...;
ExampleConnector.instance.listTasksByUnit(
  unitId: unitId,
  assignedToId: assignedToId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTasksByUnitData, ListTasksByUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listTasksByUnit(
  unitId: unitId,
  assignedToId: assignedToId,
);
ListTasksByUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String unitId = ...;
String assignedToId = ...;

final ref = ExampleConnector.instance.listTasksByUnit(
  unitId: unitId,
  assignedToId: assignedToId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetGroupsForUser
#### Required Arguments
```dart
String userId = ...;
ExampleConnector.instance.getGroupsForUser(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetGroupsForUserData, GetGroupsForUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getGroupsForUser(
  userId: userId,
);
GetGroupsForUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = ExampleConnector.instance.getGroupsForUser(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetGroupForUnit
#### Required Arguments
```dart
String unitId = ...;
ExampleConnector.instance.getGroupForUnit(
  unitId: unitId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetGroupForUnitData, GetGroupForUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getGroupForUnit(
  unitId: unitId,
);
GetGroupForUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String unitId = ...;

final ref = ExampleConnector.instance.getGroupForUnit(
  unitId: unitId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListGroupMembers
#### Required Arguments
```dart
String groupId = ...;
ExampleConnector.instance.listGroupMembers(
  groupId: groupId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListGroupMembersData, ListGroupMembersVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listGroupMembers(
  groupId: groupId,
);
ListGroupMembersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;

final ref = ExampleConnector.instance.listGroupMembers(
  groupId: groupId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMessages
#### Required Arguments
```dart
String groupId = ...;
ExampleConnector.instance.listMessages(
  groupId: groupId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMessagesData, ListMessagesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMessages(
  groupId: groupId,
);
ListMessagesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;

final ref = ExampleConnector.instance.listMessages(
  groupId: groupId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListNotifications
#### Required Arguments
```dart
String userId = ...;
ExampleConnector.instance.listNotifications(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListNotificationsData, ListNotificationsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listNotifications(
  userId: userId,
);
ListNotificationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = ExampleConnector.instance.listNotifications(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String uid = ...;
String email = ...;
String name = ...;
String role = ...;
ExampleConnector.instance.createUser(
  uid: uid,
  email: email,
  name: name,
  role: role,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUser, we created `CreateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUserVariablesBuilder {
  ...
   CreateUserVariablesBuilder studentId(String? t) {
   _studentId.value = t;
   return this;
  }
  CreateUserVariablesBuilder program(String? t) {
   _program.value = t;
   return this;
  }
  CreateUserVariablesBuilder year(int? t) {
   _year.value = t;
   return this;
  }
  CreateUserVariablesBuilder department(String? t) {
   _department.value = t;
   return this;
  }
  CreateUserVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createUser(
  uid: uid,
  email: email,
  name: name,
  role: role,
)
.studentId(studentId)
.program(program)
.year(year)
.department(department)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUser(
  uid: uid,
  email: email,
  name: name,
  role: role,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;
String email = ...;
String name = ...;
String role = ...;

final ref = ExampleConnector.instance.createUser(
  uid: uid,
  email: email,
  name: name,
  role: role,
).ref();
ref.execute();
```


### CreateUnit
#### Required Arguments
```dart
String code = ...;
String name = ...;
String lecturerId = ...;
int credits = ...;
String semester = ...;
int maxStudents = ...;
ExampleConnector.instance.createUnit(
  code: code,
  name: name,
  lecturerId: lecturerId,
  credits: credits,
  semester: semester,
  maxStudents: maxStudents,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUnit, we created `CreateUnitBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUnitVariablesBuilder {
  ...
   CreateUnitVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createUnit(
  code: code,
  name: name,
  lecturerId: lecturerId,
  credits: credits,
  semester: semester,
  maxStudents: maxStudents,
)
.description(description)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUnitData, CreateUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUnit(
  code: code,
  name: name,
  lecturerId: lecturerId,
  credits: credits,
  semester: semester,
  maxStudents: maxStudents,
);
CreateUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String code = ...;
String name = ...;
String lecturerId = ...;
int credits = ...;
String semester = ...;
int maxStudents = ...;

final ref = ExampleConnector.instance.createUnit(
  code: code,
  name: name,
  lecturerId: lecturerId,
  credits: credits,
  semester: semester,
  maxStudents: maxStudents,
).ref();
ref.execute();
```


### EnrollInUnit
#### Required Arguments
```dart
String studentId = ...;
String unitId = ...;
ExampleConnector.instance.enrollInUnit(
  studentId: studentId,
  unitId: unitId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<EnrollInUnitData, EnrollInUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.enrollInUnit(
  studentId: studentId,
  unitId: unitId,
);
EnrollInUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String studentId = ...;
String unitId = ...;

final ref = ExampleConnector.instance.enrollInUnit(
  studentId: studentId,
  unitId: unitId,
).ref();
ref.execute();
```


### DropUnit
#### Required Arguments
```dart
String studentId = ...;
String unitId = ...;
ExampleConnector.instance.dropUnit(
  studentId: studentId,
  unitId: unitId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DropUnitData, DropUnitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.dropUnit(
  studentId: studentId,
  unitId: unitId,
);
DropUnitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String studentId = ...;
String unitId = ...;

final ref = ExampleConnector.instance.dropUnit(
  studentId: studentId,
  unitId: unitId,
).ref();
ref.execute();
```


### CreateTask
#### Required Arguments
```dart
String title = ...;
String status = ...;
String priority = ...;
Timestamp dueDate = ...;
String assignedToId = ...;
String createdById = ...;
String unitId = ...;
ExampleConnector.instance.createTask(
  title: title,
  status: status,
  priority: priority,
  dueDate: dueDate,
  assignedToId: assignedToId,
  createdById: createdById,
  unitId: unitId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateTask, we created `CreateTaskBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateTaskVariablesBuilder {
  ...
   CreateTaskVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  CreateTaskVariablesBuilder estimatedHours(double? t) {
   _estimatedHours.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createTask(
  title: title,
  status: status,
  priority: priority,
  dueDate: dueDate,
  assignedToId: assignedToId,
  createdById: createdById,
  unitId: unitId,
)
.description(description)
.estimatedHours(estimatedHours)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateTaskData, CreateTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createTask(
  title: title,
  status: status,
  priority: priority,
  dueDate: dueDate,
  assignedToId: assignedToId,
  createdById: createdById,
  unitId: unitId,
);
CreateTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String status = ...;
String priority = ...;
Timestamp dueDate = ...;
String assignedToId = ...;
String createdById = ...;
String unitId = ...;

final ref = ExampleConnector.instance.createTask(
  title: title,
  status: status,
  priority: priority,
  dueDate: dueDate,
  assignedToId: assignedToId,
  createdById: createdById,
  unitId: unitId,
).ref();
ref.execute();
```


### UpdateTaskStatus
#### Required Arguments
```dart
String id = ...;
String status = ...;
double completedHours = ...;
ExampleConnector.instance.updateTaskStatus(
  id: id,
  status: status,
  completedHours: completedHours,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateTaskStatusData, UpdateTaskStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateTaskStatus(
  id: id,
  status: status,
  completedHours: completedHours,
);
UpdateTaskStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String status = ...;
double completedHours = ...;

final ref = ExampleConnector.instance.updateTaskStatus(
  id: id,
  status: status,
  completedHours: completedHours,
).ref();
ref.execute();
```


### DeleteTask
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteTask(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteTaskData, DeleteTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteTask(
  id: id,
);
DeleteTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteTask(
  id: id,
).ref();
ref.execute();
```


### CreateGroup
#### Required Arguments
```dart
String name = ...;
String unitId = ...;
ExampleConnector.instance.createGroup(
  name: name,
  unitId: unitId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateGroupData, CreateGroupVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createGroup(
  name: name,
  unitId: unitId,
);
CreateGroupData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String unitId = ...;

final ref = ExampleConnector.instance.createGroup(
  name: name,
  unitId: unitId,
).ref();
ref.execute();
```


### AddGroupMember
#### Required Arguments
```dart
String groupId = ...;
String userId = ...;
String role = ...;
ExampleConnector.instance.addGroupMember(
  groupId: groupId,
  userId: userId,
  role: role,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddGroupMemberData, AddGroupMemberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addGroupMember(
  groupId: groupId,
  userId: userId,
  role: role,
);
AddGroupMemberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
String userId = ...;
String role = ...;

final ref = ExampleConnector.instance.addGroupMember(
  groupId: groupId,
  userId: userId,
  role: role,
).ref();
ref.execute();
```


### SendMessage
#### Required Arguments
```dart
String groupId = ...;
String senderId = ...;
String text = ...;
ExampleConnector.instance.sendMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SendMessageData, SendMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.sendMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
);
SendMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String groupId = ...;
String senderId = ...;
String text = ...;

final ref = ExampleConnector.instance.sendMessage(
  groupId: groupId,
  senderId: senderId,
  text: text,
).ref();
ref.execute();
```


### MarkNotificationRead
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.markNotificationRead(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<MarkNotificationReadData, MarkNotificationReadVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.markNotificationRead(
  id: id,
);
MarkNotificationReadData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.markNotificationRead(
  id: id,
).ref();
ref.execute();
```


### CreateNotification
#### Required Arguments
```dart
String userId = ...;
String title = ...;
String body = ...;
String type = ...;
ExampleConnector.instance.createNotification(
  userId: userId,
  title: title,
  body: body,
  type: type,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateNotificationData, CreateNotificationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createNotification(
  userId: userId,
  title: title,
  body: body,
  type: type,
);
CreateNotificationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String title = ...;
String body = ...;
String type = ...;

final ref = ExampleConnector.instance.createNotification(
  userId: userId,
  title: title,
  body: body,
  type: type,
).ref();
ref.execute();
```

