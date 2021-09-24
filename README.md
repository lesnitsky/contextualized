# contextualized

[![lesnitsky.dev](https://lesnitsky.dev/shield.svg?hash=45352)](https://lesnitsky.dev?utm_source=contextualized)
[![GitHub stars](https://img.shields.io/github/stars/lesnitsky/contextualized.svg?style=social)](https://github.com/lesnitsky/contextualized)
[![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_dev.svg?label=Follow%20me&style=social)](https://twitter.com/lesnitsky_dev)

Context is a HashMap with shadowing (inherits parent values) and helpers to work with `Type`s as keys

## Installation

pubspec.yaml:

```yaml
dependencies:
  contextualized: ^1.0.0
```

## Example

```dart
class A {
  const A(this.value);
  final int value;
}

class B {
  const B(this.value);
  final int value;
}

const key = A(42);
const value = B(15);

typedef Factory<T> = T Function();

final parent = Context<A, B>;
final context = Context<A, B>;
final typeContext = Context<Type, Factory>;

parent[key] = value;
context.inherit(parent);

context[key] == value;
context[key] = const B(34);
context[key] == const B(34);
parent[key] == value;

void set<T>(T v) {
  typeContext[T] = () => v;
}

void setNullable<T>(T? v) {
  typeContext[T?] = () => v;
}

set<A>(const A(42));
typeContext.getValueByTypeKey<A>()() == const A(42);

setNullable<A>(const A(42));
setNullable<B>(null);

typeContext.getValueByTypeKey<A>(nullable: true)() == const A(42);
typeContext.getValueByTypeKey<B>(nullable: true)() == null;
```

## License

MIT
