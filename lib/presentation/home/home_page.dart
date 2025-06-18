import 'package:chat_app/core/theme/color.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/data/repositories/contact_repository.dart';
import 'package:chat_app/presentation/auth/login_page.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ContactRepository _contactRepository;
  @override
  void initState() {
    _contactRepository = getIt<ContactRepository>();
    super.initState();
  }

  void _showContactList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Contacts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _contactRepository.getRegisterContact(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('errr: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data;
                    if (data!.isEmpty) {
                      return Center(child: Text('contact not found'));
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final contact = data[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.5),
                            child: Text(contact['name'][0].toUpperCase()),
                          ),
                          title: Text(contact['name']),
                          subtitle: Text(contact['phoneNumber']),
                          onTap: () {},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(LoginPage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Melo'),
            actions: [
              IconButton(
                onPressed: () async => await getIt<AuthCubit>().signOut(),
                icon: Icon(Icons.logout_rounded),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showContactList(context),
            child: Icon(Icons.chat_rounded, color: Colors.white),
          ),
          body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Image.asset('assets/image/google.png'),
                ),
                title: Text('parth'),
                subtitle: Text('new message'),
                trailing: Card(
                  shape: CircleBorder(),
                  color: ColorPalette.primery,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
