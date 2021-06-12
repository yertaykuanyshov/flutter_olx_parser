import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:olx_parser/bloc/activation_cubit.dart';
import 'package:olx_parser/bloc/activation_cubit_state.dart';
import 'package:olx_parser/repository/license_repository.dart';
import 'package:olx_parser/ui/components/activation/activation_key_form.dart';
import 'package:olx_parser/ui/components/base_progress_bar.dart';
import 'package:olx_parser/ui/screens/parser_screen.dart';

class ActivationScreen extends StatefulWidget {
  static String routeName = "activation_screen";

  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final LicenseRepository _licenseRepository = LicenseRepositoryImpl();
  late ActivationCubit _activationCubit;

  @override
  void initState() {
    super.initState();

    _activationCubit = ActivationCubit(_licenseRepository);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: NavigationView(
        appBar: NavigationAppBar(
          title: Text('OLX парсер'),
          automaticallyImplyLeading: true,
        ),
      ),
      content: BlocConsumer(
        bloc: _activationCubit,
        listener: (_, state) {
          if (state is InValidKey) {
            Get.showSnackbar(GetBar(
              messageText: Text("Ключ дұрыс емес"),
            ));
          }

          if (state is ValidActivationKey) {
            Get.to(ParserScreen());
          }
        },
        builder: (_, state) {
          if (state is ActivationForm) {
            return ActivationKeyForm(
              onActivate: (String passedLicenseKey) {
                _activationCubit.activateLicenseKey(passedLicenseKey);
              },
            );
          }

          return BaseProgressBar();
        },
      ),
    );
  }
}
