import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../components/custom_snackbar.dart';
import '../components/default_text_field.dart';
import '../constants.dart';
import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final SocialCubit cubit = SocialCubit.get(context);
        _nameController.text = cubit.userData!.name;
        _phoneController.text = cubit.userData!.phone;
        if (cubit.userData!.bio != null) {
          _bioController.text = cubit.userData!.bio!;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            titleSpacing: 0.0,
            actions: [
              state is UpdateLoadingStatus
                  ? const Center(child: CircularProgressIndicator())
                  : TextButton(
                      child: const Text('Update'),
                      onPressed: () {
                        (cubit.coverImage != null &&
                                    cubit.coverImageUrl == null) ||
                                (cubit.profileImage != null &&
                                    cubit.profileImageUrl == null)
                            ? showSnakBar(
                                context,
                                'Please wait until the images are completed',
                                defaultColor)
                            : cubit.update(context,
                                name: _nameController.text,
                                phone: _phoneController.text,
                                bio: _bioController.text);
                      },
                    ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UpdateLoadingStatus)
                    const LinearProgressIndicator(),
                  SizedBox(
                    height: 210,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 170,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                  image: DecorationImage(
                                    image: cubit.coverImage == null
                                        ? NetworkImage(
                                            cubit.userData!.cover,
                                          )
                                        : FileImage(cubit.coverImage!)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit
                                      .pickImage(ImageSource.gallery, 'cover')
                                      .then(
                                    (image) {
                                      if (image != null)
                                        cubit.uploadImage(
                                            context, 'cover', image);
                                    },
                                  );
                                },
                                icon: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.photo_camera_outlined,
                                      size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 64,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: cubit.profileImage == null
                                    ? NetworkImage(
                                        cubit.userData!.image,
                                      )
                                    : FileImage(cubit.profileImage!)
                                        as ImageProvider,
                              ),
                            ),
                            //https://img.freepik.com/free-photo/portrait-dark-skinned-confident-man-with-curly-afro-hairstyle-has-calm-face-expression_273609-8520.jpg?t=st=1657161450~exp=1657162050~hmac=6df8961f503ba4669783c9f721ee8fea50e3d61568f32ba3f68fbe5222e5feca&w=1380

                            //https://img.freepik.com/free-vector/3d-earth-graphic-symbolizing-global-trade-illustration_456031-131.jpg?t=st=1657401016~exp=1657401616~hmac=e6637c7d8f704bea0aace9fb9c5bb50cb2bfc6d0380bc7e6b69257eb3cc3162f&w=996
                            IconButton(
                              onPressed: () {
                                cubit
                                    .pickImage(ImageSource.gallery, 'profile')
                                    .then(
                                  (image) {
                                    if (image != null)
                                      cubit.uploadImage(
                                        context,
                                        'profile',
                                        image,
                                      );
                                  },
                                );
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                child:
                                    Icon(Icons.photo_camera_outlined, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state is UploadProfileImgLoadingStatus ||
                      state is UploadCoverImgLoadingStatus)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 8),
                        Text('Updating Images, Please Wait!...'),
                        SizedBox(height: 2),
                        LinearProgressIndicator(),
                      ],
                    ),
                  const SizedBox(height: 25),
                  DefaultTextField(
                    label: 'Name',
                    controller: _nameController,
                    prefix: Icons.person_rounded,
                    type: TextInputType.name,
                    validate: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DefaultTextField(
                    label: 'Bio',
                    controller: _bioController,
                    prefix: Icons.info,
                    type: TextInputType.text,
                    validate: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'bio is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DefaultTextField(
                    label: 'Phone',
                    controller: _phoneController,
                    prefix: Icons.phone,
                    type: TextInputType.phone,
                    validate: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
