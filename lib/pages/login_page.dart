import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/locale/globalization.dart';
import 'package:qianshi_music/pages/home_page.dart';
import 'package:qianshi_music/provider/auth_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/stores/index_controller.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/utils/sputils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  var _isObscure = true;
  String? _account, _password;
  Color _eyeColor = Colors.grey;
  final List _loginMethod = [
    {
      'title': 'google',
      'icon': Icons.fiber_dvr,
    },
    {
      'title': 'facebook',
      'icon': Icons.facebook,
    },
    {
      'title': 'twitter',
      'icon': Icons.account_balance,
    }
  ];
  final _indexController = Get.find<IndexController>();
  final CurrentUserController _currentUserController = Get.find();
  Timer? _timer;
  final _countDown = 60.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                const SizedBox(height: 50),
                buildAccountTextField(),
                const SizedBox(height: 30),
                buildPasswordTextField(context),
                // buildForgetPasswordText(context),
                buildLanguageSelect(context),
                const SizedBox(height: 50),
                buildLoginButton(context),
                buildAnonimousLoginLink(context),
                const SizedBox(height: 30),
                buildOtherLoginText(),
                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        Globalization.login.tr,
        style: const TextStyle(fontSize: 42),
      ),
    );
  }

  Widget buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40,
          height: 2,
        ),
      ),
    );
  }

  Widget buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: Globalization.account.tr),
      validator: (v) {
        if (v!.trim().isEmpty) {
          return Globalization.accountCanNotBeEmpty.tr;
        }
        if (v.length < 3) {
          return Globalization.accountIsTooShort.tr;
        }
        return null;
      },
      onChanged: (value) {
        _account = value;
        logger.i(_account);
      },
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            // obscureText: _isObscure,
            onChanged: (v) => _password = v,
            validator: (value) {
              if (value!.isEmpty) {
                return Globalization.passwordCanNotBeEmpty.tr;
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: Globalization.password.tr,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                        _eyeColor = _isObscure
                            ? Colors.grey
                            : Theme.of(context).iconTheme.color!;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _eyeColor,
                    ))),
          ),
        ),
        Obx(
          () => _countDown.value == 60
              ? TextButton(
                  onPressed: () {
                    _sent(context);
                  },
                  child: const Text(
                    "发送",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    "${_countDown.value}s",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          child: Text(
            Globalization.forgetPassword.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 270,
      child: ElevatedButton(
        child: Text(Globalization.login.tr,
            style: Theme.of(context).primaryTextTheme.headlineSmall),
        onPressed: () {
          if ((_formKey.currentState as FormState).validate()) {
            (_formKey.currentState as FormState).save();
            _doLogin(context);
          }
        },
      ),
    );
  }

  Widget buildAnonimousLoginLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            _anonimousLogin(context);
          },
          child: const Text(
            '游客登录',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildOtherLoginText() {
    return Center(
        child: Text(Globalization.otherAccountLogin.tr,
            style: const TextStyle(color: Colors.grey, fontSize: 14)));
  }

  Widget buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(item['title'] + Globalization.login.tr),
                            action: SnackBarAction(
                              label: Globalization.actionCancel.tr,
                              onPressed: () {},
                            )),
                      );
                    },
                    icon: Icon(
                      item['icon'],
                      color: Theme.of(context).iconTheme.color,
                    ));
              }))
          .toList(),
    );
  }

  Widget buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Globalization.noAccount.tr),
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          child: Text(
            Globalization.clickToRegister.tr,
            style: const TextStyle(color: Colors.green),
          ),
          onTap: () {},
        )
      ],
    );
  }

  Future _sent(context) async {
    logger.i(_account);
    if (_account == null || _account == '' || _timer != null) {
      return;
    }
    final response = await AuthProvider.sent(_account!);
    logger.i(response);
    if (response.statusCode == 200 && response.data['code'] == 200) {
      _countDown.value = 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _countDown.value--;
        if (timer.tick == 60) {
          timer.cancel();
          _timer = null;
        }
      });
    } else {
      Get.snackbar(Globalization.error.tr, "发送短信失败",
          backgroundColor: Theme.of(context).primaryColor);
    }
  }

  Future _doLogin(context) async {
    try {
      final response = await AuthProvider.login(_account!, captcha: _password);
      if (response.code == 200) {
        SpUtil().setBool("IsLogin", true);
        SpUtil().setString("cookie", response.cookie!);
        Global.cookie = response.cookie!;
        _currentUserController.currentAccount.value = response.account;
        _currentUserController.currentProfile.value = response.profile;
        Get.off(() => const HomePage());
      } else {
        Get.snackbar(Globalization.error.tr,
            Globalization.errorAccountNoExistsOrIncorrectPassword.tr,
            backgroundColor: Theme.of(context).primaryColor);
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar(Globalization.error.tr,
          Globalization.errorAccountNoExistsOrIncorrectPassword.tr,
          backgroundColor: Theme.of(context).primaryColor);
    }
  }

  Future _anonimousLogin(context) async {
    final anonimousResponse = await AuthProvider.anonimous();
    if (anonimousResponse.code != 200) {
      Get.snackbar(Globalization.error.tr, anonimousResponse.msg ?? "登录失败",
          backgroundColor: Theme.of(context).primaryColor);
      return;
    }
    Global.cookie = anonimousResponse.cookie!;
    final response = await AuthProvider.account();
    if (response.code != 200) {
      Get.snackbar(Globalization.error.tr, response.msg ?? "登录失败",
          backgroundColor: Theme.of(context).primaryColor);
      return;
    }
    SpUtil().setBool("IsLogin", true);
    SpUtil().setString("cookie", anonimousResponse.cookie!);
    _currentUserController.currentAccount.value = response.account;
    _currentUserController.currentProfile.value = response.profile;
    Get.off(() => const HomePage());
  }

  Widget buildLanguageSelect(BuildContext context) {
    return DropdownButtonFormField<Language>(
        decoration: InputDecoration(
          labelText: Globalization.language.tr,
        ),
        value: _indexController.currentLanguage.value,
        items: _indexController.languages
            .map((e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Text(e.displayName),
                ))
            .toList(),
        onChanged: (val) {
          if (val == null) return;
          _indexController.currentLanguage.value = val;
        });
  }
}
