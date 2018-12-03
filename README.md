# Utility Belt

A set of functions/macros for easily building applications.

## Why make every deps optional?

`utility_belt` exists to provide a place for common modules abstracted from different repositories.

It contains code related to password, cryptography, jwt, module generation etc.

As `utility_belt` grows, more and more dependencies was added. For `goldorin`, it only uses `DynamicModule` from `utility_belt`. However, since `utility_belt` contains cryptographic related code, it uses some cryptographic dependencies. So when `goldorin` uses `utility_belt` as dependency in `mix.exs`, it will download all the cryptographic dependencies and compile them in order to compile `goldorin`. This doesn't make sense and adds complexity to the project.

The original goal is to abstract common code(`DynamicModule`) so other project can also use it. However the result end up being `goldorin` carries a bunch of dependencies it never needs.

The fix is to set every dependency in `utility_belt` to `optional: true`. This will prevent mix to download unnecessary dependencies to the project that never needs. For projects do need those dependencies, they need to explicitly include those dependencies, as they always should do.

There are few exceptions dependencies cannot set `optional: true`

- `con_cache`: it's used in `UtilityBelt.Application.start/2`
- `ecto`: `import Ecto.Query` is used in `UtilityBelt.Ecto.QueryBuilder`
- `faker`: it's application needs to be started at runtime
