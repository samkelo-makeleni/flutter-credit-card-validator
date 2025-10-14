

class CreditCardModel {
	final String number;
	final String type;
	final String cvv;
	final String issuingCountry;
	
	final String? expiry;

	CreditCardModel({required this.number, required this.type, required this.cvv, required this.issuingCountry, this.expiry});

	Map<String, dynamic> toJson() => {
				'number': number,
				'type': type,
				'cvv': cvv,
				'issuingCountry': issuingCountry,
				'expiry': expiry,
			};

	factory CreditCardModel.fromJson(Map<String, dynamic> j) => CreditCardModel(
				number: j['number'],
				type: j['type'],
				cvv: j['cvv'],
				issuingCountry: j['issuingCountry'],
				expiry: j['expiry'],
			);
}