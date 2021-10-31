import 'package:example/src/modules/auth/login/login_view.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_viewmodel.dart';

@FormView(fields: [FormTextField(name: "phone")])
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (BuildContext context, LoginViewModel model, Widget? child) =>
          Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  label: model.showCode
                      ? const Text("Enter Verification Code")
                      : const Text("Enter Phone")),
            ),
            const SizedBox(
              height: 100,
            ),
            if (model.errorMessage.isNotEmpty)
              Text(
                model.errorMessage,
                style: const TextStyle(color: Colors.red),
              )
          ],
        ),
        bottomSheet: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              child:
                  model.showCode ? const Text("Verify") : const Text("Login"),
              onPressed: () => model.login(),
            )),
      ),
      viewModelBuilder: () =>
          LoginViewModel(emptyInput: () => phoneController.clear()),
    );
  }
}
