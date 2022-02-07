import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../product/response_models/gecho/gecho_id_list_model.dart';
import '../../add_coin_page/viewmodel/cubit/add_coin_cubit.dart';
import '../viewmodel/cubit/search_page_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: context.paddingNormal,
        child: Column(
          children: [
            SizedBox(
              height: context.height * 0.07,
              child: buildRowAndSearchIconRow(context),
            ),
            Expanded(
              flex: 8,
              child: Scrollbar(
                child: buildBlocConsumer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildRowAndSearchIconRow(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 9, child: buildTextFormField(context)),
        Expanded(
          child: IconButton(
              color: context.theme.tabBarTheme.labelColor,
              onPressed: context.read<SearchPageCubit>().searchCoin,
              icon: const Icon(Icons.search)),
        )
      ],
    );
  }

  BlocConsumer<SearchPageCubit, SearchPageState> buildBlocConsumer() {
    return BlocConsumer<SearchPageCubit, SearchPageState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is SearchPageInitial) {
          return SvgPicture.asset(AppConstant.instance.SEARCH_IMAGE_PATH);
        } else if (state is SearchPageCompleted) {
          return completedBody(state.foundIdList, context);
        } else if (state is SearchPageItemNotFound) {
          return SvgPicture.asset(AppConstant.instance.SVG_404_PATH);
        } else if (state is SearchPageLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          return SvgPicture.asset(AppConstant.instance.SVG_404_PATH);
        }
      },
    );
  }

  Row buildFloatingActionButtonContent(BuildContext context) {
    return Row(
      children: [
        const Text("Search"),
        SizedBox(
          width: context.lowValue,
        ),
        const Icon(Icons.search)
      ],
    );
  }

  Column completedBody(List<GechoAllIdList> list, BuildContext context) {
    return Column(
      children: [
        (context.watch<SearchPageCubit>().listItemCount != null &&
                list.isNotEmpty)
            ? Text(
                "Searched within ${context.watch<SearchPageCubit>().listItemCount} results")
            : Container(),
        Expanded(
          flex: 8,
          child: Scrollbar(
            child: buildListViewBuilder(list),
          ),
        ),
      ],
    );
  }

  TextFormField buildTextFormField(BuildContext context) {
    return TextFormField(
      controller: context.read<SearchPageCubit>().controller,
      cursorColor: context.theme.colorScheme.onBackground,
      onChanged: (v) {
        context.read<SearchPageCubit>().searchCoin();
      },
      decoration: InputDecoration(
        contentPadding: context.paddingLowHorizontal * 2.5,
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
        title: const Text("Search PAGE"),
        centerTitle: true,
      );

  ListView buildListViewBuilder(List<GechoAllIdList> list) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/addCoinPage");
            context.read<AddCoinCubit>().fetchCoin((list[index].id ?? ""));
          },
          child: buildCard(list[index], index, context),
        );
      },
      itemCount: list.length,
    );
  }

  Card buildCard(GechoAllIdList item, int index, BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.normalValue, vertical: context.lowValue / 2),
        child: Row(
          children: [
            Expanded(child: Text((index + 1).toString())),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: " + (item.id ?? "")),
                  Text("Name: " + (item.name ?? "")),
                  Text("Symbol: " + (item.symbol ?? ""))
                ],
              ),
            ),
            const Icon(Icons.forward)
          ],
        ),
      ),
    );
  }
}
