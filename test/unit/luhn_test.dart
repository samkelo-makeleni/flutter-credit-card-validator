import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart' as vm show luhnCheck, inferCardType;
import 'package:flutter_test/flutter_test.dart';



void main() {
  test('Luhn valid numbers pass', () {
	expect(vm.luhnCheck('4539578763621486'), true); 
	expect(vm.luhnCheck('6011000990139424'), true); 
  });

  test('Luhn invalid fails', () {
	expect(vm.luhnCheck('411111111111112'), false);
  });

  test('Infer card types', () {
	expect(vm.inferCardType('4'), 'Visa');
	expect(vm.inferCardType('51'), 'MasterCard');
	expect(vm.inferCardType('34'), 'American Express');
  });
}