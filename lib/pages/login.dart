import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ovrsr/pages/home.dart';
import 'package:ovrsr/pages/password_reset.dart';
import 'package:ovrsr/provider/userProfileProvider.dart';
import 'package:ovrsr/utils/apptheme.dart';
import 'package:ovrsr/widgets/easySnackBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends ConsumerState<LoginPage> {
  var _isLoading = false;
  var _isObscure = true;
  var _isInit = true;
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUserName = '';

  late UserProfileProvider _userProfileProvider;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  _getProviderSettings() async {
    _userProfileProvider = ref.read(userProfileProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _getProviderSettings();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid && context.mounted) {
      _formKey.currentState!.save();
    }
    return isValid;
  }

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _userProfileProvider.fetchUserProfileIfNeeded();
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = _auth.currentUser;
        if (user != null) {
          _userProfileProvider.email = user.email ?? "";
          _userProfileProvider.userName = userName;
          _userProfileProvider.password = password;
          await _userProfileProvider.writeUserProfileToDb();

          if (!user.emailVerified) {
            await user.sendEmailVerification();
            // ignore: use_build_context_synchronously
            EasySnackbar.show(SnackbarType.info,
                'Check your email for confirmation', context);
          }
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      if (err is FirebaseAuthException) {
        if (err.code == 'email-already-in-use') {
          // ignore: use_build_context_synchronously
          EasySnackbar.show(SnackbarType.error,
              'Email already in use. Try logging in', context);
        } else if (err.code == 'INVALID_LOGIN_CREDENTIALS') {
          // ignore: use_build_context_synchronously
          EasySnackbar.show(
              SnackbarType.error, 'Username or password is incorrect', context);
          setState(() {
            _isLoading = false;
          });
        }
        if (!mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  //_isLogin ? const Text('Login') : const Text('Sign Up'),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: _isLogin ? const Text('Login') : const Text('Sign Up'),
      //   automaticallyImplyLeading: false,
      //   titleTextStyle: GoogleFonts.montserrat(
      //     fontWeight: FontWeight.bold,
      //     color: Colors.black,
      //     fontSize: 24,
      //   ),
      //   backgroundColor: AppTheme.light,
      // ),
      appBar: AppBar(
        title: _isLogin ? const Text('Login') : const Text('Sign Up'),
        automaticallyImplyLeading: false,
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24,
        ),
        backgroundColor: AppTheme.light,
        actions: [
          Image.asset(
            'assets/images/Logo_Dark.png',
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
          )
        ],
      ),

      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Logo_Light.png'),
                      ),
                      border: Border.all(
                        width: 3,
                        color: AppTheme.light,
                        style: BorderStyle.solid,
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 650,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: AppTheme.light,
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.jacquesFrancois(),
                                label: const Text(
                                  'Username',
                                  style: TextStyle(color: AppTheme.light),
                                ),
                                filled: true,
                                fillColor: AppTheme.meduim,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(
                                    color: AppTheme.accent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username Cannot Be Left Blank';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUserName = value!;
                              },
                            ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            maxLength: 320,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: AppTheme.light,
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.jacquesFrancois(),
                              label: const Text(
                                'Email',
                                style: TextStyle(color: AppTheme.light),
                              ),
                              filled: true,
                              fillColor: AppTheme.meduim,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppTheme.accent,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email Cannot Be Left Blank';
                              }
                              final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value);
                              if (!emailValid) {
                                return 'Please Enter a Valid Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            cursorColor: AppTheme.light,
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.jacquesFrancois(),
                              label: const Text(
                                'Password',
                                style: TextStyle(color: AppTheme.light),
                              ),
                              filled: true,
                              fillColor: AppTheme.meduim,
                              suffixIcon: IconButton(
                                icon: _isObscure
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: AppTheme.accent,
                                  width: 2,
                                ),
                              ),
                            ),
                            obscureText: _isObscure,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password Cannot Be Left Blank';
                              }
                              if (value.length < 5) {
                                return 'Password cannot be less than five characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(0, 128, 109, 0),
                    foregroundColor: AppTheme.light,
                  ),
                  onPressed: () {
                    if (_saveForm()) {
                      _submitAuthForm(_enteredEmail, _enteredPassword,
                          _enteredUserName, _isLogin, context);
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: AppTheme.accent,
                        )
                      : _isLogin
                          ? const Text('Log In')
                          : const Text('Sign Up'),
                ),
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  _isLogin
                                      ? const Text('Don\'t have an account?')
                                      : const Text('Have an account?'),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(0, 128, 109, 0),
                                      foregroundColor: AppTheme.light,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: _isLogin
                                        ? const Text('Sign Up')
                                        : const Text('Log In'),
                                  ),
                                ],
                              ),
                              //Button for if you forgot your passwords
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(0, 128, 109, 0),
                                  foregroundColor: AppTheme.light,
                                ),
                                onPressed: () => Navigator.of(context)
                                    .push<String>(MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordPage())),
                                child: const Text('Forgot Password'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
