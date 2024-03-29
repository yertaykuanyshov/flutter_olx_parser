import 'package:logger/logger.dart';

const String phoneNumberAjaxUrl =
    "https://www.olx.kz/kk/ajax/misc/contact/phone/productId/?pt=phoneToken";

const String patternProductCode = r"([A-Z])\w+";
const String patternPhoneNumberToken = r"[a-z 0-9]{128}";

const defaultHttpHeader = {"cookie": ""};

final logger = Logger();
