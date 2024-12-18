import 'package:financify_wallet/blocs/auth/auth_bloc.dart';
import 'package:financify_wallet/shared/shared_method.dart';
import 'package:financify_wallet/shared/theme.dart';
import 'package:financify_wallet/ui/pages/pin_page.dart';
import 'package:financify_wallet/ui/pages/profile_edit_page.dart';
import 'package:financify_wallet/ui/pages/profile_edit_pin_page.dart';
import 'package:financify_wallet/ui/pages/sign_in_page.dart';
import 'package:financify_wallet/ui/widgets/buttons.dart';
import 'package:financify_wallet/ui/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }

        if (state is AuthInitial) {
          Get.offAll(() => const SignInPage());
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AuthSuccess) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: state.user.profilePicture == null
                              ? const AssetImage('assets/img_profile.png')
                              : NetworkImage(state.user.profilePicture!)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: state.user.verified == 1
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: greenColor,
                                  size: 24,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      state.user.name.toString(),
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_edit_profile.png',
                      title: 'Edit Profile',
                      onTap: () async {
                        final result = await Get.to(() => const PinPage());
                        if (result == true) {
                          Get.to(() => const ProfileEditPage());
                        }
                      },
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_pin.png',
                      title: 'My PIN',
                      onTap: () async {
                        final result = await Get.to(() => const PinPage());
                        if (result == true) {
                          Get.to(() => const ProfileEditPinPage());
                        }
                      },
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_wallet.png',
                      title: 'Wallet Settings',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_reward.png',
                      title: 'My Rewards',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_help.png',
                      title: 'Help Center',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      iconUrl: 'assets/ic_logout.png',
                      title: 'Log Out',
                      onTap: () {
                        context.read<AuthBloc>().add(AuthLogout());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 87,
              ),
              CustomTextButton(
                title: 'Report a Problem',
                onPressed: () {},
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }
}
