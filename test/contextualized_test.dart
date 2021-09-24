import 'package:flutter_test/flutter_test.dart';

import 'package:contextualized/contextualized.dart';

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

void main() {
  late Context<A, B> context;
  setUp(() => context = Context<A, B>());

  group('Context<T, K>', () {
    group('operators:', () {
      test('gets values with [] operator', () {
        context = Context<A, B>({key: value});
        expect(context[key], value);
      });

      test('sets values with []= operator', () {
        context[key] = value;
        expect(context[key], value);
      });
    });

    group('#inherit:', () {
      test('inherits values from parent', () {
        final parent = Context({key: value});
        context.inherit(parent);

        expect(context[key], value);
      });

      test('overrides parent values', () {
        final parent = Context({key: value});
        context.inherit(parent);

        context[key] = const B(34);
        expect(context[key], const B(34));
      });

      test('sets parent value', () {
        final parent = Context({key: value});
        context.inherit(parent);

        expect(context.parent, parent);
      });

      test("set operator doesn't override parent value", () {
        final parent = Context({key: value});
        context.inherit(parent);

        context[key] = const B(34);
        expect(parent[key], value);
      });
    });

    group('#addAll:', () {
      test('sets all values from other context w/o inheriting it', () {
        final parent = Context({key: value});
        context.addAll(parent);

        expect(context[key], value);
        expect(context.parent, null);
      });
    });

    group('#remove:', () {
      test('removes value', () {
        final parent = Context({key: value});
        context.addAll(parent);

        context.remove(key);
        expect(context[key], null);
      });
    });

    group('clear', () {
      test('removes all keys', () {
        context[key] = value;
        context.clear();

        expect(context[key], null);
      });

      test('sets parent to null', () {
        final parent = Context({key: value});
        context.inherit(parent);

        context.clear();

        expect(context.parent, null);
      });

      test("doesn't clear parent", () {
        final parent = Context({key: value});
        context.inherit(parent);

        context.clear();

        expect(parent[key], value);
      });
    });

    group('#getValueByTypeKey', () {
      test('resolves value by type key', () {
        final context = Context<Type, B>();
        context[A] = value;

        final v = context.getValueByTypeKey<A>();
        expect(v, value);
      });

      test('resolves value by nullable type', () {
        final context = Context<Type, B>();

        void set<T>(B value) {
          context[T] = value;
        }

        set<A?>(value);

        final v = context.getValueByTypeKey<A>(nullable: true);
        expect(v, value);
      });
    });
  });
}
