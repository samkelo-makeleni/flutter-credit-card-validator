import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../scoped_models/credit_card_viewmodel.dart';

class SavedCardsWidget extends StatelessWidget {
  const SavedCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreditCardViewModel>();
    return ListView.builder(
      itemCount: vm.cards.length,
      itemBuilder: (context, i) {
        final c = vm.cards[i];
        return ListTile(
          leading: const Icon(Icons.credit_card),
          title: Text(
            '**** **** **** ${c.number.substring(c.number.length - 4)}',
          ),
          subtitle: Text('${c.type} • ${c.issuingCountry}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => vm.deleteAt(i),
          ),
        );
      },
    );
  }
}
