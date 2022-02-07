import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../viewmodel/cubit/add_coin_cubit.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCoinPage extends StatelessWidget {
  const AddCoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
      body: Padding(
        padding: context.paddingLow,
        child: BlocConsumer<AddCoinCubit, AddCoinState>(
          listener: (context, state) {
            if (state is AddCoinAlreadyExist) {
              showScaffoldMessage(
                  context, "Coin is already exist in usd section 🤪");
            }
            if (state is AddCoinAlreadyAdded) {
              showScaffoldMessage(
                  context, "Coin is already added your new list 🤪");
            }
            if (state is AddCoinSuccessfullylAdded) {
              showScaffoldMessage(context, "Coin Added 🤪");
            }
          },
          builder: (context, state) {
            if (state is AddCoinInitial) {
              return const Center(child: Text("INITIAL"));
            } else if (state is AddCoinError) {
              return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
            } else if (state is AddCoinCompleted) {
              MainCurrencyModel result = state.currency;
              return buildListViewBody(result, context);
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "no",
      onPressed: () => context.read<AddCoinCubit>().addCoin(),
      label: buildFloatingActionButtonContent(context),
    );
  }

  Row buildFloatingActionButtonContent(BuildContext context) {
    return Row(
      children: [
        const Text("ADD YOUR NEW LİST"),
        SizedBox(
          width: context.lowValue,
        ),
        const Icon(Icons.add)
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Add Coin"),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => context.read<AddCoinCubit>().clearAll(),
            icon: const Icon(Icons.delete_outline))
      ],
    );
  }

  ListView buildListViewBody(MainCurrencyModel result, BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: currencyPriceCardItem(
                  context,
                  LocaleKeys.CoinDetailPage_lowOf24Hour.locale,
                  result.lowOf24h ?? ""),
            ),
            Expanded(
              child: currencyPriceCardItem(
                  context,
                  LocaleKeys.CoinDetailPage_highLowOf24Hour.locale,
                  result.highOf24h ?? ""),
            ),
          ],
        ),
        currencyPriceCardItem(context, "ID", result.id),
        currencyPriceCardItem(context, "Name", result.name.toUpperCase()),
        currencyPriceCardItem(context, "Last Price", result.lastPrice ?? ""),
        currencyPriceCardItem(context, "Last Update", result.lastUpdate ?? ""),
        buildAddButton(context)
      ],
    );
  }

  OutlinedButton buildAddButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () => context.read<AddCoinCubit>().addCoin(),
        child: const Text("ADD YOUR NEW LİST"));
  }

  Card currencyPriceCardItem(BuildContext context, String title, String price) {
    return Card(
      child: Padding(
        padding: context.paddingLow,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: title + ": ", style: context.textTheme.headline6),
            TextSpan(text: price, style: context.textTheme.subtitle1)
          ]),
        ),
      ),
    );
  }

  void showScaffoldMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: context.midDuration,
    ));
  }
}
