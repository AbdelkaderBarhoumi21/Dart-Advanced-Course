// Non-nullable by default
String name = 'John'; // Cannot be null
int age = 25;         // Cannot be null

// Nullable types
String? nullableName;   // Can be null
int? nullableAge;       // Can be null

// Null assertion operator (!)
String? getName() => 'Alice';
String definitelyName = getName()!; // Throws if null

// Null-aware operators
String? possibleName;
String displayName = possibleName ?? 'Unknown'; // If null


int? length = possibleName?.length; // Safe access
