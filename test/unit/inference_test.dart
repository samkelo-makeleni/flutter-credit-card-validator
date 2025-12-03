import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart' as vm show inferCardType;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Infer Visa card type', () {
    expect(vm.inferCardType('4'), 'Visa');
    expect(vm.inferCardType('4539578763621486'), 'Visa');
  });

  test('Infer MasterCard type', () {
    expect(vm.inferCardType('51'), 'MasterCard');
    expect(vm.inferCardType('55'), 'MasterCard');
    expect(vm.inferCardType('2'), 'MasterCard');
  });

  test('Infer American Express type', () {
    expect(vm.inferCardType('34'), 'American Express');
    expect(vm.inferCardType('37'), 'American Express');
  });

  test('Infer Discover card type', () {
    expect(vm.inferCardType('6011'), 'Discover');
    expect(vm.inferCardType('65'), 'Discover');
  });

  test('Unknown card type', () {
    expect(vm.inferCardType('9'), 'Unknown');
    expect(vm.inferCardType('0'), 'Unknown');
  });
}
