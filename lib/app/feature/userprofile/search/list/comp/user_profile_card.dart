import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/user_profile_model.dart';
import '../../../../utils/app_text_title_value.dart';
import '../../../access/user_profile_access_page.dart';
import '../../bloc/user_profile_search_bloc.dart';
import '../../../view/user_profile_view_page.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileModel model;
  const UserProfileCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              model.photo != null && model.photo!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        model.photo!,
                        height: 70,
                        width: 70,
                      ),
                    )
                  : const SizedBox(
                      height: 70,
                      width: 70,
                      child: Icon(Icons.person_outline),
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppTextTitleValue(
                    //   title: 'Id: ',
                    //   value: model.id,
                    // ),
                    AppTextTitleValue(
                      title: 'Email: ',
                      value: model.email,
                    ),
                    AppTextTitleValue(
                      title: 'Nome: ',
                      value: '${model.name}',
                    ),

                    AppTextTitleValue(
                      title: 'Telefone: ',
                      value: '${model.phone}',
                    ),

                    Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<UserProfileSearchBloc>(
                                      context),
                                  child: UserProfileAccessPage(
                                      userProfileModel: model),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserProfileViewPage(model: model),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.assignment_ind_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // copy(String text) async {
  //   Get.snackbar(text, 'Id copiado.',
  //       margin: const EdgeInsets.all(10), duration: const Duration(seconds: 1));
  //   await Clipboard.setData(ClipboardData(text: text));
  // }
}
