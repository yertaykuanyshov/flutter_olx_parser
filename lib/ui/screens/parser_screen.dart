import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olx_parser/bloc/parser_cubit.dart';
import 'package:olx_parser/model/parsed_data.dart';
import 'package:olx_parser/repository/excel_repository.dart';
import 'package:olx_parser/repository/interface/license_repository.dart';
import 'package:olx_parser/repository/license_repository.dart';
import 'package:olx_parser/repository/olx_repository.dart';
import 'package:olx_parser/ui/components/appbar.dart';
import 'package:olx_parser/ui/components/parse_button.dart';
import 'package:olx_parser/ui/components/url_field.dart';

class ParserScreen extends StatefulWidget {
  ParserScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ParserScreen> {
  final OlxRepository _olxRepository = OlxRepository();
  final ExcelRepository _excelRepository = ExcelRepository();

  late final ParserCubit _parserCubit;

  @override
  void initState() {
    super.initState();

    _parserCubit = ParserCubit(_olxRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParserAppBar(),
      body: BlocBuilder(
        bloc: _parserCubit,
        builder: (_, state) {
          if (state is ParsingStarted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  ParseButton(
                    value: 'Тоқтату',
                    onTap: () => _parserCubit.stop(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Жиналған хабарландыру саны: 123"),
                ],
              ),
            );
          }

          if (state is ParsingFinished) {
            return Column(
              children: [
                MaterialButton(
                  child: const Text("Сохранит в формате  Excel"),
                  onPressed: () => _parserCubit.export(),
                ),
                ParseButton(
                  value: 'Жаңадан бастау',
                  onTap: () => _parserCubit.emit(ParserView()),
                ),
              ],
            );
          }

          return Column(
            children: [
              UrlField(
                onChanged: (v) => {},
              ),
              const SizedBox(height: 10),
              ParseButton(
                value: 'Номерлерді жинау',
                onTap: () => _parserCubit.start(),
              ),
            ],
          );
        },
      ),
    );
  }
}
